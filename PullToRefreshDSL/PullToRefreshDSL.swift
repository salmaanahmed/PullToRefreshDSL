//
//  PullToRefreshDSL.swift
//  PullToRefreshDSL
//
//  Created by Salmaan Ahmed on 06/01/2021.
//

import Foundation
import UIKit

// MARK: - Extension to create DSL of UIScrollView
extension UIScrollView {
    private struct AssociatedKey {
        static var paginationView: UInt8 = 0
    }
    
    var ptr: PullToRefreshDSL {
        if let ptr = objc_getAssociatedObject(self, &AssociatedKey.paginationView) as? PullToRefreshDSL {
            return ptr
        } else {
            let ptr = PullToRefreshDSL(scroll: self)
            objc_setAssociatedObject(self, &AssociatedKey.paginationView, ptr, .OBJC_ASSOCIATION_RETAIN)
            return ptr
        }
    }
}

// MARK: - Pull To Refresh
public class PullToRefreshDSL: NSObject {
    
    private static var context = 0
    
    weak var scrollView: UIScrollView?
    public var headerHeight: CGFloat = 60
    public var footerHeight: CGFloat = 60
    public var animationDuration: TimeInterval = 0.6
    
    public var headerView: UIView?
    public var footerView: UIView?
    
    public var headerCallback: (() -> Void)? {
        didSet {
            if headerCallback == nil {
                headerView?.removeFromSuperview()
            }
        }
    }
    
    public var footerCallback: (() -> Void)? {
        didSet {
            if footerCallback == nil {
                footerView?.removeFromSuperview()
            }
        }
    }
    
    public var isLoadingHeader = false {
        didSet {
            if oldValue == isLoadingHeader { return }
            if isLoadingHeader {
                showHeader()
                headerCallback?()
            } else {
                hideHeader()
            }
        }
    }
    
    public var isLoadingFooter = false {
        didSet {
            if oldValue == isLoadingFooter { return }
            if isLoadingFooter {
                showFooter()
                footerCallback?()
            } else {
                hideFooter()
            }
        }
    }
    
    internal init(scroll: UIScrollView) {
        scrollView = scroll
        super.init()
        
        setupHeaderAndFooterView()
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
}

// MARK: - Header and Footer View
extension PullToRefreshDSL {
    func setupHeaderAndFooterView() {
        if headerView == nil {
            let headerView = UIActivityIndicatorView(frame: .zero)
            headerView.startAnimating()
            self.headerView = headerView
        }
        
        if footerView == nil {
            let footerView = UIActivityIndicatorView(frame: .zero)
            footerView.startAnimating()
            self.footerView = footerView
        }
    }
}

// MARK: - ScrollView Delegate
extension PullToRefreshDSL {
    
    fileprivate func removeObserver() {
        scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: &PullToRefreshDSL.context)
    }
    
    fileprivate func addObserver() {
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.old, .new], context: &PullToRefreshDSL.context)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIScrollView.contentOffset) && context == &PullToRefreshDSL.context {
            scrollViewDidScroll()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    public func scrollViewDidScroll() {
        guard let scrollView = scrollView, !isLoadingFooter || !isLoadingFooter else { return }
        
        if scrollView.contentOffset.y < headerHeight.negative && !isLoadingHeader && headerCallback != nil {
            isLoadingHeader = true
        } else if scrollView.maxContentOffset.y > 0 && scrollView.contentOffset.y > scrollView.maxContentOffset.y + footerHeight && !isLoadingFooter && footerCallback != nil {
            isLoadingFooter = true
        }
    }
    
    func showHeader() {
        guard let scrollView = scrollView, let headerView = headerView else { return }
        headerView.frame = CGRect(x: 0, y: -headerHeight, width: scrollView.bounds.size.width, height: headerHeight)
        scrollView.addSubview(headerView)
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.scrollView?.contentInset.top += self.headerHeight
        }
    }
    
    func hideHeader() {
        headerView?.removeFromSuperview()
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.scrollView?.contentInset.top -= self.headerHeight
        }
    }
    
    func showFooter() {
        guard let scrollView = scrollView, let footerView = footerView else { return }
        footerView.frame = CGRect(x: 0, y: scrollView.contentSize.height + scrollView.contentInset.bottom, width: scrollView.contentSize.width, height: footerHeight)
        scrollView.addSubview(footerView)
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.scrollView?.contentInset.bottom += self.footerHeight
        }
    }
    
    func hideFooter() {
        footerView?.removeFromSuperview()
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.scrollView?.contentInset.bottom -= self.footerHeight
        }
    }
}

// MARK: - Helper Functions
fileprivate extension UIScrollView {
    var maxContentOffset: CGPoint {
      return CGPoint(
        x: contentSize.width - bounds.width + contentInset.right,
        y: contentSize.height - bounds.height + contentInset.bottom)
    }
}

fileprivate extension CGFloat {
    var negative: CGFloat {
        self * -1
    }
}
