# PullToRefreshDSL
One line of code to add pull to refresh view to header or footer of any UIScrollView subclass i.e. Collection/TableView.

![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)
[![Version](https://img.shields.io/cocoapods/v/PaginatedTableView.svg?style=flat)](https://cocoapods.org/pods/PullToRefreshDSL)
[![License](https://img.shields.io/cocoapods/l/PaginatedTableView.svg?style=flat)](https://cocoapods.org/pods/PullToRefreshDSL)
[![Platform](https://img.shields.io/cocoapods/p/PaginatedTableView.svg?style=flat)](https://cocoapods.org/pods/PullToRefreshDSL)
![Country](https://img.shields.io/badge/Made%20with%20%E2%9D%A4-pakistan-green.svg)

## Example

To run the example project, clone the repo, and run `pod install` from the Demo directory first.

## Demo

Pull to refresh is an essestial feature for almost every mobile app but unfortunately it is not that easy.
Also it have some limitations and its own set of bugs which comes with it. Code duplication is one of the main reason which motivated me to work on this library.

Inspired by the `DSL pattern` and how easy it is to use i.e. how `SnapKit` does it, this library also uses the same pattern.
The magic key word is `ptr` to access all your `PullToRefresh` properties/methods.

<br>
<img height="600" src="https://github.com/salmaanahmed/PullToRefreshDSL/blob/master/sample.gif?raw=true" />
<br>

## Usage

**Step 1:** Enable PullToRefresh 🚀
```swift
// You only have to add the callback, rest is taken care of
tableView.ptr.headerCallback = { [weak self] in // weakify self to avoid strong reference
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { // your network call
        self?.tableView.ptr.isLoadingHeader = false // setting false will hide the view
    }
}
``` 
  
**Step 2:** Disable PullToRefresh 🤯
```swift
// Yeah thats all, just set it to nil
tableView.ptr.headerCallback = nil // it is disabled by default
```

**Step 3:** Enjoy!, thats all, you're done 😎

Enjoy `PullToRefresh` provide your user with great user experience
Simple, isnt it?

**Other Settings:** Customizeability 🤔

You can use your own view/activity indicator, just dont forget to add `height`
```swift
tableView.ptr.headerHeight = 50 // Set its height
tableView.ptr.headerView = yourCustomView() // Set your customView
```

You can also add `PullToRefresh` to bottom of your scrollView/tableView/collectionView
```swift
tableView.ptr.footerCallback = { } // add callback to enable
tableView.ptr.footerCallback = nil // set to nil to disable
```

Your scrollView will elegantly animate to hide/show your `PullToRefresh` view
```swift
tableView.ptr.animationDuration = 0.3 // yes you can set it as well
```

You can also show/hide views whenever you want by using following properties
```swift
// Show Header
tableView.ptr.isLoadingHeader = true
tableView.ptr.showHeader()

// Hide Header
tableView.ptr.isLoadingHeader = false
tableView.ptr.hideHeader()

// Show Footer
tableView.ptr.isLoadingFooter = true
tableView.ptr.showFooter()

// Hide Footer
tableView.ptr.isLoadingFooter = false
tableView.ptr.hideFooter()

// NOTE: callbacks will only be fired when using property to show PullToRefresh view
```

## Installation

HorizontalCalendar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PullToRefreshDSL'
```

## Author

Salmaan Ahmed, salmaan.ahmed@hotmail.com

## License

HorizontalCalendar is available under the MIT license. See the LICENSE file for more info.
