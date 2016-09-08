
#import "AlwaysScroll.h"
@interface AlwaysScroll () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *reusableView;
@property (strong, nonatomic) UIImageView *centerView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *imagesArray;
@property (weak, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger index;

@end

@implementation AlwaysScroll

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc] init];
        [self addSubview:self.pageControl];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    }
    return _pageControl;
}

/** 页码 */
- (void)pageShow
{
    self.pageControl.numberOfPages = self.imagesArray.count;

}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}


/** 自动滚动 */
- (void)setTimerWithDuration:(NSTimeInterval)timeInterval
{
    if (self.timer) return;
    NSTimer *timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(start) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;

}
- (void)start
{
    CGFloat w = self.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(self.isLeftScroll ? -1 : w*2, 0) animated:YES];
    
}

/** 向上滚动 */
- (void)setUpScroll:(BOOL)upScroll
{
    if (upScroll && !self.downScroll) {
        
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.centerView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        self.reusableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
}

/** 向下滚动 */
- (void)setDownScroll:(BOOL)downScroll
{
    if (downScroll && !self.upScroll) {
    
        
        
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        self.centerView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.reusableView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
}



/** 继续 */
- (void)continueTimer
{
    [self.timer setFireDate:[NSDate date]];
}

/** 暂停 */
- (void)pause
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

/** 停止 */
- (void)stop
{
    [self.timer invalidate];
}

/** 传进来要滚动的图片 */
- (void)setImages:(NSArray *)images
{
    if (!images.count) return;
    
    self.imagesArray = images;
    
    self.centerView.image = images[0];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        _centerView = [[UIImageView alloc] init];
        [self.scrollView addSubview:_centerView];
        _reusableView = [[UIImageView alloc] init];
    }
    return self;
}

+ (instancetype)alwaysScroll
{
    return [[self alloc] init];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat w = scrollView.frame.size.width;
    long count = self.imagesArray.count;
    
    CGRect f = _reusableView.frame;
    long index = 0;
    if (offsetX > _centerView.frame.origin.x) {
        f.origin.x = scrollView.contentSize.width - w;
        
        index = _centerView.tag + 1;
        if (index >= count) index = 0;
    } else {
        f.origin.x = 0;
        
        index = _centerView.tag - 1;
        if (index < 0) index = count - 1;
    }
    _reusableView.frame = f;
    _reusableView.tag = index;
    
    UIImage *image = self.imagesArray[index];
    
    _reusableView.image = image;
    
    if (offsetX <= 0 || offsetX >= w * 2) {
        UIImageView *temp = _centerView;
        _centerView = _reusableView;
        _reusableView = temp;
        
        _centerView.frame = _reusableView.frame;
        scrollView.contentOffset = CGPointMake(w, 0);
        
        [_reusableView removeFromSuperview];
        
        self.pageControl.currentPage = index;
    } else {
        [self.scrollView addSubview:_reusableView];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.timer) {
        [self pause];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.timer) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self continueTimer];
        });
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.scrollView.frame = self.bounds;
    self.reusableView.frame = self.bounds;
    self.centerView.frame = CGRectMake(w, 0, w, h);
    self.scrollView.contentSize = CGSizeMake(w * 3, 0);
    self.scrollView.contentOffset = CGPointMake(w, 0);
    
    CGRect pageTemp = self.pageControl.frame;
    pageTemp.origin.x = self.frame.size.width * 0.5;
    pageTemp.origin.y = self.frame.size.height * 0.95;
    self.pageControl.frame = pageTemp;
}

@end
