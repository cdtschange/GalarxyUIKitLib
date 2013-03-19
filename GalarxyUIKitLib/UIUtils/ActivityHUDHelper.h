//
//  PopupHelper.h
//  GalarxyUIKitLib
//
//  Created by Wei Mao on 12/24/12.
//  Copyright (c) 2012 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface ActivityHUDHelper : NSObject

typedef void (^void_action_block)(void);

+ (void)setBackgroundDim:(BOOL)isDim;

//DejalActivityView
+ (BOOL)isBezelActivityViewLoading;
+ (void)displayBezelActivityViewIn:(UIView *)view;
+ (void)displayBezelActivityViewIn:(UIView *)view withText:(NSString *)text;
+ (void)removeBezelActivityView:(BOOL)animated;
//MBHUD
+ (void)displayMBHUDActivityViewIn:(UIView *)view;
+ (void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text;
+ (void)removeMBHUDActivityViewIn:(UIView *)view;
+ (void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text customView:(UIImageView *)customView removeAfterDelay:(int)delay;
+ (void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text description:(NSString *)description customView:(UIImageView *)customView removeAfterDelay:(int)delay;
+ (void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text customView:(UIImageView *)customView removeAfterDelay:(int)delay afterAction:(void_action_block)afterAction;
+ (void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text description:(NSString *)description customView:(UIImageView *)customView removeAfterDelay:(int)delay afterAction:(void_action_block)afterAction;

+(MBProgressHUD *)displayMBHUDActivityProgressViewIn:(UIView *)view;
@end
