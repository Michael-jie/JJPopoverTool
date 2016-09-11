## 示例效果
![API文档](../1.gif)
## Installation
### Using [CocoaPods](http://cocoapods.org)

1.	Add the pod `JJPopoverTool` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

```ruby
platform :ios, "7.0"
target 'TargetName' do
pod 'JJPopoverTool'
end
```
1.	Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.
1.	Import the `JJPopoverTool.h` header.
* With `use_frameworks!` in your Podfile
* Swift: `import JJPopoverTool`
* Objective-C: `#import <JJPopoverTool/JJPopoverTool.h>` (or with Modules enabled: `@import JJPopoverTool;`)
* Without `use_frameworks!` in your Podfile
* Swift: Add `#import "JJPopoverTool.h"` to your bridging header.
* Objective-C: `#import "JJPopoverTool.h"`

### 使用说明
将`JJPopoverTool`导入到工程中
#####Here's an example:

```objective-c
// 内容的View
UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 140, 44 * 3)];
tableView.dataSource =self;
tableView.delegate = self;
// 使用类方法弹出popover
// tableView : 弹出的内容
// sender : 指向的控件
// @[self.a, self.b] : 过滤的控件(不受popover影响的)
[JJPopoverTool presentContentView:tableView
pointToItem:sender
passThroughViews:@[self.a, self.b]];

// 退出popover
// 判断如果弹出了popover则退出
if ([JJPopoverTool isShowPopover]) {
[JJPopoverTool dismiss];
}

```
### 接口说明
```objective-c
/**
*  弹出popver
*
*  @param contentView 内容
*  @param item        指向的控件
*  @param passthroughViews 设置不受popover影响的控件
*/
+ (void)presentContentView:(UIView *)contentView
pointToItem:(UIView *)item
passThroughViews:(NSArray *)passthroughViews;

/**
*  退出popover
*/
+ (void)dismiss;

/**
*  是否弹出了popover
*/
+ (BOOL)isShowPopover;
```