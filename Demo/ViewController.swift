//
//  ViewController.swift
//  Demo
//
//  Created by Salmaan Ahmed on 06/01/2021.
//

import UIKit

class ViewController: UIViewController {

    var tableViewCells = [Int]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addPullToRefresh()
    }

    func setup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        for i in 0...20 { tableViewCells.append(i) }
    }
}

// MARK: - Pull To Refresh
extension ViewController {
    func addPullToRefresh() {
        tableView.ptr.headerHeight = 50
        tableView.ptr.headerView = getProgressCircle()
        tableView.ptr.headerCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self?.tableView.ptr.isLoadingHeader = false
            }
        }
        
        tableView.ptr.footerCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self?.tableView.ptr.isLoadingFooter = false
            }
        }
    }
}

// MARK: - TableView Delegate and Data Source
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "Cell at index \(tableViewCells[indexPath.row])"
        return cell ?? UITableViewCell()
    }
}

// MARK: - Custom Progress Bar
extension ViewController {
    func getProgressCircle() -> UIView {
        
        let parentView = UIStackView()
        parentView.axis = .vertical
        parentView.spacing = 5
        
        let p = RPCircularProgress()
        p.thicknessRatio = 0.1
        p.progressTintColor = .gray
        p.enableIndeterminate()
        parentView.addArrangedSubview(p)
        
        let label = UILabel()
        label.text = "Loading, please wait"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        parentView.addArrangedSubview(label)
        
        return parentView
    }
}
