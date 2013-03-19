//
//  ScrollActivityIndicator.h
//  WandaKTV
//
//  Created by wangjia on 24/12/12.
//  Copyright (c) 2012 WandaKtvInc.. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PullViewNoneAlignment   = 0,
    PullViewTopAlignment    = 1,
    PullViewBottomAlignment = 2,
    PullViewLeftAlignment    = 3,
    PullViewRightAlignment   = 4,
} PullViewAlignment;

typedef enum{
	EGOOPullPulling = 0,
	EGOOPullNormal  = 1,
	EGOOPullLoading = 2,
} EGOPullState;

@protocol ScrollActivityIndicatorDelegate;
@interface ScrollActivityIndicator : UIView

+ (id)indicatorWithPullAlignment:(PullViewAlignment)alignment;

@property (nonatomic, assign) id<ScrollActivityIndicatorDelegate> delegate;
@property (nonatomic, unsafe_unretained) UIScrollView *scrollView;
@property (nonatomic, assign) PullViewAlignment pullAlgnment;
@property (nonatomic, strong) NSDate *lastUpdateDate;
@property (nonatomic, assign) BOOL isPullIndicatorActive;

- (void)setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor arrowImage:(UIImage *)arrowImage;

@end

@protocol ScrollActivityIndicatorDelegate <NSObject>
@optional
- (void)scrollActivityIndicator:(ScrollActivityIndicator *)indicator
                  pullAlignment:(PullViewAlignment)pullAlignment;
@end