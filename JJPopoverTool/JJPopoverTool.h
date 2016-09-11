//
//  JJPopoverTool.h
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJPopoverTool : NSObject

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

@end
