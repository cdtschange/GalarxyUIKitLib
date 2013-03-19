//
//  ScrollActivityIndicator.m
//  WandaKTV
//
//  Created by wangjia on 24/12/12.
//  Copyright (c) 2012 WandaKtvInc.. All rights reserved.
//
// CLASS INCULDES
#import "ScrollActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

// CONST DEFINE
#define DEFAULT_ARROW_IMAGE         UIIMAGERESOURCEBUNDLE(@"scrollai_grayArrow",@"png")
#define DEFAULT_BACKGROUND_COLOR    [UIColor clearColor]
#define DEFAULT_TEXT_COLOR          [UIColor grayColor]
#define DEFAULT_ACTIVITY_INDICATOR_STYLE    UIActivityIndicatorViewStyleGray
#define PULL_AREA_HEIGTH 60.0f
#define FLIP_ANIMATION_DURATION 0.18f
#define PULL_TRIGGER_HEIGHT (PULL_AREA_HEIGTH + 5.0f)
#define TXTReleaseToRefresh NSLocalizedString(@"Release to refresh...",@"松开即可刷新...")
#define TXTPullDownToRefresh NSLocalizedString(@"Pull down to refresh...",@"下拉可以刷新...")
#define TXTPullRightToRefresh NSLocalizedString(@"Pull right to refresh...",@"右拉可以刷新...")
#define TXTReleaseToLoadMore NSLocalizedString(@"Release to load more...",@"松开即可加载更多...")
#define TXTPullUpToLoadMore NSLocalizedString(@"Pull up to load more...",@"上拉可以加载更多...")
#define TXTPullLeftToLoadMore NSLocalizedString(@"Pull left to load more...",@"左拉可以加载更多...")
#define TXTLoading NSLocalizedString(@"Loading...",@"加载中...")
#define TXTLastUpdated NSLocalizedString(@"Last Updated:",@"上次更新: ")

@interface ScrollActivityIndicator(){
    CALayer *arrowImage;
    UILabel *statusLabel;
    UILabel *lastUpdatedLabel;
    EGOPullState pullState;
	UIActivityIndicatorView *activityView;
}

- (void)initViews;
- (void)resetViewsLayout;
- (void)refreshLastUpdatedDate;
- (void)scrollViewDidScroll;
- (UIEdgeInsets)pullScrollContentEdgeInsets:(EGOPullState)state;
- (NSString *)pullStatusText:(EGOPullState)state;
- (CATransform3D)ArrowTransform:(EGOPullState)state;
@end

@implementation ScrollActivityIndicator
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize pullAlgnment = _pullAlgnment;
@synthesize lastUpdateDate = _lastUpdateDate;
@synthesize isPullIndicatorActive = _isPullIndicatorActive;

+ (id)indicatorWithPullAlignment:(PullViewAlignment)alignment{
    ScrollActivityIndicator *indicator = [[ScrollActivityIndicator alloc] initWithFrame:CGRectZero];
    indicator.pullAlgnment = alignment;
    return [indicator autorelease];
}

- (void)dealloc{
    arrowImage = nil;
    statusLabel = nil;
    activityView = nil;
    lastUpdatedLabel = nil;
    [self setDelegate:nil];
    [self setScrollView:nil];
    [self setLastUpdateDate:nil];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initViews];
    }
    return self;
}

#pragma mark- private methods
- (void)initViews{
    // Config initialize params
    _isPullIndicatorActive = NO;
    _pullAlgnment = PullViewNoneAlignment;
    
    // Config Last Update Label
    lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
    lastUpdatedLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    lastUpdatedLabel.backgroundColor = [UIColor clearColor];
    lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:lastUpdatedLabel];
    
    // Config Status Updated Label
    statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    statusLabel.font = [UIFont systemFontOfSize:13.0];
    statusLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:statusLabel];
    
    // Config Arrow Image
    arrowImage = [CALayer layer];
    arrowImage.contentsGravity = kCAGravityResizeAspect;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        arrowImage.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    [[self layer] addSublayer:arrowImage];
    
    // Config activity indicator
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
    [self addSubview:activityView];
    
    // Config pull state
    [self setPullState:EGOOPullNormal];
    
    // Config background color, text color and arrow image
    [self setBackgroundColor:nil textColor:nil arrowImage:nil];
}

- (void)resetViewsLayout{
    if (!_scrollView) {
        return;
    }
    
    CGRect frame = _scrollView.bounds;
    CGFloat midX = PULL_AREA_HEIGTH/2.0f;
    CGFloat midY = PULL_AREA_HEIGTH/2.0f;
    switch (_pullAlgnment) {
        case PullViewTopAlignment:{
            self.frame = CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height);
            midX = self.frame.size.width - PULL_AREA_HEIGTH/2.0f;
            midY = self.frame.size.height - PULL_AREA_HEIGTH/2.0f;
            
            lastUpdatedLabel.frame = CGRectMake(0, midY, self.frame.size.width, 20.0);
            statusLabel.frame = CGRectMake(0, midY-18.0, self.frame.size.width, 20.0);
            arrowImage.frame = CGRectMake(25.0, midY-35.0, 30.0, 55.0);
            activityView.frame = CGRectMake(25.0, midY-8.0, 20.0, 20.0);
        }
            break;
        case PullViewBottomAlignment:{
            CGFloat visibleTableDiffBoundsHeight = (_scrollView.bounds.size.height - MIN(_scrollView.bounds.size.height, _scrollView.contentSize.height));
            self.frame = CGRectMake(0, _scrollView.contentSize.height+visibleTableDiffBoundsHeight,
                                    frame.size.width, frame.size.height);
            midX = self.frame.size.width - PULL_AREA_HEIGTH/2.0f;
            midY = PULL_AREA_HEIGTH/2.0;
            
            lastUpdatedLabel.frame = CGRectZero;
            statusLabel.frame = CGRectMake(0, midY-10.0, self.frame.size.width, 20.0);
            arrowImage.frame = CGRectMake(25.0, midY-20.0, 30.0, 55.0);
            activityView.frame = CGRectMake(25.0, midY-8.0, 20.0, 20.0);
        }
            break;
        case PullViewLeftAlignment:{
            self.frame = CGRectMake(-frame.size.width, 0, frame.size.width, frame.size.height);
            midX = self.frame.size.width - PULL_AREA_HEIGTH/2.0f;
            midY = self.frame.size.height - PULL_AREA_HEIGTH/2.0f;
            
            lastUpdatedLabel.frame = CGRectZero;
            statusLabel.frame = CGRectMake(0, self.frame.size.height/2-15.0,
                                           self.frame.size.width-5.0, 20.0);
            statusLabel.textAlignment = UITextAlignmentRight;
            arrowImage.frame = CGRectMake(midX-20.0, self.frame.size.height/2-10.0, 30.0, 55.0);
            activityView.frame = CGRectMake(midX-15.0, self.frame.size.height/2+4.0, 20.0, 20.0);
        }
            break;
        case PullViewRightAlignment:{
            CGFloat visibleTableDiffBoundsWidth = (_scrollView.bounds.size.width - MIN(_scrollView.bounds.size.width, _scrollView.contentSize.width));
            self.frame = CGRectMake(_scrollView.contentSize.width+visibleTableDiffBoundsWidth, 0,
                                    frame.size.width, frame.size.height);
            midX = self.frame.size.width - PULL_AREA_HEIGTH/2.0f;
            midY = self.frame.size.height - PULL_AREA_HEIGTH/2.0f;
            
            lastUpdatedLabel.frame = CGRectZero;
            statusLabel.frame = CGRectMake(5.0, self.frame.size.height/2-15.0,
                                           self.frame.size.width-10.0, 20.0);
            statusLabel.textAlignment = NSTextAlignmentLeft;
            arrowImage.frame = CGRectMake(20.0, self.frame.size.height/2-10.0, 30.0, 55.0);
            activityView.frame = CGRectMake(15.0, self.frame.size.height/2+4, 20.0, 20.0);
        }
            break;
        default:{
            self.frame = CGRectZero;
            lastUpdatedLabel.frame = CGRectZero;
            statusLabel.frame = CGRectZero;
            arrowImage.frame = CGRectZero;
            activityView.frame = CGRectZero;
        }
            break;
    }
}

#define aMinute 60
#define anHour 3600
#define aDay 86400

- (void)refreshLastUpdatedDate {
    if(_lastUpdateDate) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
        NSString *format = [NSString stringWithFormat:@"%@%%@", TXTLastUpdated];
		lastUpdatedLabel.text = [NSString stringWithFormat:format, [formatter stringFromDate:_lastUpdateDate]];
		[formatter release];
    } else {
        lastUpdatedLabel.text = nil;
    }
}

- (NSString *)pullStatusText:(EGOPullState)state{
    NSString *text = TXTLoading;
    switch (_pullAlgnment) {
        case PullViewTopAlignment:
        case PullViewLeftAlignment:
            if (state == EGOOPullNormal) {
                text = TXTPullDownToRefresh;
            }else if (state == EGOOPullPulling)
            {
                text = TXTReleaseToRefresh;
            }
            break;
        case PullViewRightAlignment:
        case PullViewBottomAlignment:
            if (state == EGOOPullNormal) {
                text = TXTPullUpToLoadMore;
            }else if (state == EGOOPullPulling)
            {
                text = TXTReleaseToLoadMore;
            }
            break;
        default:
            break;
    }
    
    return text;
}

- (CATransform3D)ArrowTransform:(EGOPullState)state{
    CATransform3D transform;
    switch (_pullAlgnment) {
        case PullViewTopAlignment:
            if (state == EGOOPullNormal) {
                transform = CATransform3DIdentity;
            }else{
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }
            break;
        case PullViewBottomAlignment:
            if (state == EGOOPullNormal) {
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }else{
                transform = CATransform3DIdentity;
            }
            break;
        case PullViewLeftAlignment:
            if (state == EGOOPullNormal) {
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 270.0f, 0.0f, 0.0f, 1.0f);
            }else{
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 1.0f);
            }
            break;
        case PullViewRightAlignment:
            if (state == EGOOPullNormal) {
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 1.0f);
            }else{
                transform = CATransform3DMakeRotation((M_PI / 180.0) * 270.0f, 0.0f, 0.0f, 1.0f);
            }
            break;
        default:
            break;
    }
    
    return transform;
}

- (UIEdgeInsets)pullScrollContentEdgeInsets:(EGOPullState)state{
    UIEdgeInsets contentEdge = _scrollView?_scrollView.contentInset:UIEdgeInsetsZero;
    switch (_pullAlgnment) {
        case PullViewTopAlignment:
            if (state == EGOOPullLoading) {
                contentEdge.top = PULL_AREA_HEIGTH;
            }else{
                contentEdge.top = 0.0;
            }
            break;
        case PullViewBottomAlignment:
            if (state == EGOOPullLoading) {
                contentEdge.bottom = PULL_AREA_HEIGTH;
            }else{
                contentEdge.bottom = 0;
            }
            break;
        case PullViewLeftAlignment:
            if (state == EGOOPullLoading) {
                contentEdge.left = PULL_AREA_HEIGTH;
            }else{
                contentEdge.left = 0;
            }
            break;
        case PullViewRightAlignment:
            if (state == EGOOPullLoading) {
                contentEdge.right = PULL_AREA_HEIGTH;
            }else{
                contentEdge.right = 0;
            }
            break;
        default:
            break;
    }
    
    return contentEdge;
}

- (void)scrollViewDidScroll{
    if (!_scrollView) {
        return;
    }
    
    CGPoint contentOffset = _scrollView.contentOffset;
    CGSize contentSize = _scrollView.contentSize;
    CGSize viewSize = _scrollView.bounds.size;
    switch (pullState) {
        case EGOOPullNormal:{
            // 停止拖拽
            if (!_scrollView.isDragging) {
                return;
            }
            
            [self refreshLastUpdatedDate];
            
            // 设置被拖拽状态
            switch (_pullAlgnment) {
                case PullViewTopAlignment:
                    if (contentOffset.y + PULL_AREA_HEIGTH <= 0) {
                        [self setPullState:EGOOPullPulling];
                    }
                    break;
                case PullViewBottomAlignment:
                    if (contentSize.height >= viewSize.height && contentOffset.y+viewSize.height-contentSize.height>PULL_AREA_HEIGTH) {
                        [self setPullState:EGOOPullPulling];
                    }
                    break;
                case PullViewLeftAlignment:
                    if (contentOffset.x+PULL_AREA_HEIGTH <= 0) {
                        [self setPullState:EGOOPullPulling];
                    }
                    break;
                case PullViewRightAlignment:
                    if (contentSize.width >= viewSize.width && contentOffset.x+viewSize.width-contentSize.width > PULL_AREA_HEIGTH) {
                        [self setPullState:EGOOPullPulling];
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        case EGOOPullPulling:{
            switch (_pullAlgnment) {
                case PullViewTopAlignment:
                    if (contentOffset.y+PULL_AREA_HEIGTH>0) {
                        [self setPullState:EGOOPullNormal];
                    }else{
                        if (!_scrollView.isDragging) {
                            [self setPullState:EGOOPullLoading];
                        }
                    }
                    break;
                case PullViewBottomAlignment:
                    if (contentOffset.y+viewSize.height-contentSize.height < PULL_AREA_HEIGTH) {
                        [self setPullState:EGOOPullNormal];
                    }else{
                        if (!_scrollView.isDragging) {
                            [self setPullState:EGOOPullLoading];
                        }
                    }
                    break;
                case PullViewLeftAlignment:
                    if (contentOffset.x+PULL_AREA_HEIGTH > 0) {
                        [self setPullState:EGOOPullNormal];
                    }else{
                        if (!_scrollView.isDragging) {
                            [self setPullState:EGOOPullLoading];
                        }
                    }
                    break;
                case PullViewRightAlignment:
                    if (contentOffset.x+viewSize.width-contentSize.width < PULL_AREA_HEIGTH) {
                        [self setPullState:EGOOPullNormal];
                    }else{
                        if (!_scrollView.isDragging) {
                            [self setPullState:EGOOPullLoading];
                        }
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        case EGOOPullLoading:
            break;
        default:
            break;
    }
}

#pragma mark- setter & getter
- (void)setScrollView:(UIScrollView *)scrollView{
    if (_scrollView) {
        [self removeFromSuperview];
        [_scrollView removeObserver:self forKeyPath:@"bounds"];
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    _scrollView = scrollView;
    if (_scrollView) {
        [_scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"bounds"
                         options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [self resetViewsLayout];
    [self setPullState:EGOOPullNormal];
}

- (void)setPullAlgnment:(PullViewAlignment)pullAlgnment{
    _pullAlgnment = pullAlgnment;
    
    [self resetViewsLayout];
    [self setPullState:EGOOPullNormal];
}

- (BOOL)isPullIndicatorActive{
    return pullState == EGOOPullLoading;
}

- (void)setIsPullIndicatorActive:(BOOL)isPullIndicatorActive{
    if (isPullIndicatorActive) {
        [self setPullState:EGOOPullLoading];
    }else{
        [self setPullState:EGOOPullNormal];
    }
}

- (void)setPullState:(EGOPullState)state{
    EGOPullState prevState = pullState;
    pullState = state;
    
    switch (state) {
        case EGOOPullNormal:{
            if (prevState == EGOOPullLoading) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                arrowImage.transform = [self ArrowTransform:EGOOPullNormal];
                [CATransaction commit];
            }
            
            statusLabel.text = [self pullStatusText:EGOOPullNormal];
            [activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			arrowImage.hidden = NO;
			arrowImage.transform = [self ArrowTransform:EGOOPullNormal];
            [CATransaction commit];
            
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.contentInset = [self pullScrollContentEdgeInsets:EGOOPullNormal];
            }];
            
            [self refreshLastUpdatedDate];
        }
            break;
        case EGOOPullPulling:{
            statusLabel.text = [self pullStatusText:EGOOPullPulling];
            [CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			arrowImage.transform = [self ArrowTransform:EGOOPullPulling];
			[CATransaction commit];
            
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.contentInset = [self pullScrollContentEdgeInsets:EGOOPullPulling];
            }];
        }
            break;
        case EGOOPullLoading:{
            statusLabel.text = [self pullStatusText:EGOOPullLoading];
			[activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			arrowImage.hidden = YES;
			[CATransaction commit];
            
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.contentInset = [self pullScrollContentEdgeInsets:EGOOPullLoading];
            }];
            
            // 外部调用回调
            if (_delegate && [_delegate respondsToSelector:@selector(scrollActivityIndicator:pullAlignment:)]) {
                [_delegate scrollActivityIndicator:self pullAlignment:_pullAlgnment];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark- public methods
- (void)setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor arrowImage:(UIImage *)image{
    self.backgroundColor = backgroundColor? backgroundColor : DEFAULT_BACKGROUND_COLOR;
    
    if(textColor) {
        lastUpdatedLabel.textColor = textColor;
        statusLabel.textColor = textColor;
    } else {
        lastUpdatedLabel.textColor = DEFAULT_TEXT_COLOR;
        statusLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    
    lastUpdatedLabel.shadowColor = [lastUpdatedLabel.textColor colorWithAlphaComponent:0.1f];
    statusLabel.shadowColor = [statusLabel.textColor colorWithAlphaComponent:0.1f];
    arrowImage.contents = (id)(image? image.CGImage : DEFAULT_ARROW_IMAGE.CGImage);
}

#pragma mark- observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll];
    }else if ([keyPath isEqualToString:@"bounds"]){
        [self resetViewsLayout];
    }
}

@end
