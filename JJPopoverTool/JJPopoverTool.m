//
//  JJPopoverTool.m
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJPopoverTool.h"

#define kArrowH  8 // 箭头高度
#define kArrowW  15 // 箭头宽度
#define kContentMargin 10 // 左右间距
#define kArrowMargin 10 // 箭头指向控件之间的间距
#define kBoardWidth 1 // 边框,箭头的宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface ArrowView : UIView
@property (nonatomic, strong) UIColor *arrowBgColor;

@end
@interface JJPopoverTool ()<UIGestureRecognizerDelegate>
+ (NSMutableSet *)getCopyPassthroughViews;
@end
@implementation ArrowView : UIView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrowBgColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setArrowBgColor:(UIColor *)arrowBgColor {
    _arrowBgColor = arrowBgColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize curSize = rect.size;
    
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置边框的宽度
    CGContextSetLineWidth(context, kBoardWidth);
    // 设置边框的颜色
    CGContextSetStrokeColorWithColor(context, UIColor.grayColor.CGColor);
    // 设置填充颜色
    CGContextSetFillColorWithColor(context, self.arrowBgColor.CGColor);
    
    // 绘制三角
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, curSize.height);
    CGContextAddLineToPoint(context, curSize.width/2, 0);
    CGContextAddLineToPoint(context, curSize.width, curSize.height);
    
    CGContextDrawPath(context, kCGPathEOFillStroke);
}
@end

@interface PopoverView : UIView
@end

@implementation PopoverView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView *subView in [JJPopoverTool getCopyPassthroughViews]) {
        // 如果点击的是过滤的控件 则该控件不接受事件
        if (CGRectContainsPoint(subView.frame, point)) {
            return  nil;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [JJPopoverTool dismiss];
}

@end


@implementation JJPopoverTool
// 使用Set集合效率高
static NSMutableSet *_copyPassthroughViews;

+ (void)initialize {
    _copyPassthroughViews = [NSMutableSet set];
}

+ (NSMutableSet *)getCopyPassthroughViews {
    return _copyPassthroughViews;
}

/**
 *  添加过滤的控件
 */
+ (void)addCopyView {
    // 遍历需要过滤的控件并添加到窗口上
    for (UIView *copyView in _copyPassthroughViews) {
        // 添加到窗口
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        for (UIView *subView in keyWindow.subviews) {
            if ([subView isKindOfClass:[PopoverView class]]) {
                [keyWindow addSubview:copyView];
            }
        }
    }
}

/**
 *  移除过滤的控件
 */
+ (void)removeCopyView {
    for (UIView *copyPassthroughView in _copyPassthroughViews) {
        [copyPassthroughView removeFromSuperview];
    }
    [_copyPassthroughViews removeAllObjects];
}

/**
 *  是否弹出popover
 */
+ (BOOL)isShowPopover {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in keyWindow.subviews) {
        if ([subView isKindOfClass:[PopoverView class]]) {
            return YES;
        }
    }
    return  NO;
}


+ (void)setPassthroughViews:(NSArray *)passthroughViews {
    for (UIView *passthroughView in passthroughViews) {
        // 创建一个新的View(仅仅为了展示)
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:passthroughView];
        UIView *copyView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        copyView.userInteractionEnabled = false;
        
        // 设置对应的位置
        CGRect newR = [passthroughView convertRect:passthroughView.bounds toView:nil];
        copyView.frame = newR;
        
        // 添加的集合中
        [_copyPassthroughViews addObject:copyView];
    }
}

+ (void)presentContentView:(UIView *)contentView
                pointToItem:(UIView *)item
                passThroughViews:(NSArray *)passthroughViews {
    
    // 1.退出popover,移除集合中的控件
    [self dismiss];
    
    // 2.如果有需要过滤的控件则添加到集合中
    if (passthroughViews != nil) {
        [self setPassthroughViews:passthroughViews];
    }
    
    // 2.创建popover并弹出
    [self presentContentView:contentView pointToItem:item];
}

+ (void)presentContentView:(UIView *)contentView pointToItem:(UIView *)item {
    
    // 1.创建popover
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:popoverView];
    
    // 2.如果集合中有数据,则添加过滤的控件
    if (_copyPassthroughViews.count != 0) {
        [self addCopyView];
    }
    
    // 2.创建箭头
    ArrowView *arrowView = [[ArrowView alloc] init];
    if (contentView.backgroundColor != nil) {
        arrowView.arrowBgColor = contentView.backgroundColor;
    }
    arrowView.backgroundColor = [UIColor clearColor];
    [popoverView addSubview:arrowView];
    
    
    // 3.创建内容
    [popoverView insertSubview:contentView belowSubview:arrowView];
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderWidth = kBoardWidth;
    contentView.layer.borderColor = [UIColor grayColor].CGColor;
    
    // 4.更新位置
    // 转换坐标
    CGRect newPointRect = [item convertRect:item.bounds toView:nil];
    // 设置箭头位置
    CGFloat arrowX = (item.frame.size.width - kArrowW) * 0.5 + newPointRect.origin.x;
    CGFloat arrowY = CGRectGetMaxY(newPointRect) + kArrowMargin;
    arrowView.frame = CGRectMake(arrowX, arrowY, kArrowW, kArrowH);
    
    // 设置内容的位置
    CGFloat contentX = arrowView.frame.origin.x - (contentView.frame.size.width - arrowView.frame.size.width) * 0.5;
    CGFloat contentY = CGRectGetMaxY(arrowView.frame) - kBoardWidth;
    CGSize contentSize = contentView.frame.size;
    contentView.frame = (CGRect){contentX, contentY, contentSize};
    if (contentX < kContentMargin) { // 是否少于左边间距
        [self updateX:kContentMargin view:contentView];
    } else if (CGRectGetMaxX(contentView.frame) > (kScreenW - kContentMargin)) { // 超过右边间距
        [self updateX:kScreenW - kContentMargin - contentView.frame.size.width view:contentView];
    }
    
    if (CGRectGetMaxY(contentView.frame) > kScreenH) { // 判断是否超过底部边界
        // 更新内容的y值
        [self updateY:item.frame.origin.y - kArrowMargin - kArrowH - contentView.frame.size.height view:contentView];
        
        // 更新箭头的y值
        [self updateY:item.frame.origin.y - kArrowMargin - kArrowH - kBoardWidth view:arrowView];
        
        // 反转箭头
        arrowView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

/**
 *  更新x值
 */
+ (void)updateX:(CGFloat)x view:(UIView *)view {
    CGRect f = view.frame;
    f.origin.x = x;
    view.frame = f;
}

/**
 *  更新y值
 */
+ (void)updateY:(CGFloat)y view:(UIView *)view {
    CGRect f = view.frame;
    f.origin.y = y;
    view.frame = f;
}

+ (void)dismiss {
    // 移除popover
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in keyWindow.subviews) {
        if ([subView isKindOfClass:[PopoverView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self removeCopyView];
}

@end