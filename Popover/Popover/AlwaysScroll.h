
#import <UIKit/UIKit.h>

@interface AlwaysScroll : UIView

+ (instancetype)alwaysScroll;

/** 传进来要滚动的图片 */
- (void)setImages:(NSArray *)images;

/** 自动滚动 */
- (void)setTimerWithDuration:(NSTimeInterval)timeInterval;

/** 暂停 */
- (void)pause;

/** 继续 */
- (void)continueTimer;

/** 停止 */
- (void)stop;

/** 增加页码, 在传图片之前 */
- (void)pageShow;

/** 当前页码颜色 */
@property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;

/** 未选中的颜色的 */
@property (strong, nonatomic) UIColor *pageIndicatorTintColor;

/** 向左移动 */
@property (assign, nonatomic, getter = isLeftScroll) BOOL leftScroll;

/** 向上移动 */
@property (assign, nonatomic, getter = isUpScroll) BOOL upScroll;

/** 向下移动 */
@property (assign, nonatomic, getter = isUpScroll) BOOL downScroll;

@end
