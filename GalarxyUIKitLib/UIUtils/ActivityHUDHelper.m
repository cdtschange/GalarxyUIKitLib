//
//  PopupHelper.m
//  GalarxyUIKitLib
//
//  Created by Wei Mao on 12/24/12.
//  Copyright (c) 2012 isoftstone. All rights reserved.
//

#import "ActivityHUDHelper.h"
#import "DejalActivityView.h"
#import "MBProgressHUD.h"

@implementation ActivityHUDHelper

BOOL dimBackground = YES;


+ (void)setBackgroundDim:(BOOL)isDim{
    dimBackground = isDim;
}
+(BOOL)isBezelActivityViewLoading{
    return [DejalBezelActivityView currentActivityView]!=nil;
}
+(void)displayBezelActivityViewIn:(UIView *)view{
    [DejalBezelActivityView activityViewForView:view];
}
+(void)displayBezelActivityViewIn:(UIView *)view withText:(NSString *)text{
    [DejalBezelActivityView activityViewForView:view withLabel:text];
}
+(void)removeBezelActivityView:(BOOL)animated{
    [DejalBezelActivityView removeViewAnimated:animated];
}
+(void)displayMBHUDActivityViewIn:(UIView *)view{
    [self displayMBHUDActivityViewIn:view withText:nil];
}
+(void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (text) {
        hud.labelText = text;
    }
    hud.dimBackground = dimBackground;
}
+(void)removeMBHUDActivityViewIn:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text customView:(UIImageView *)customView removeAfterDelay:(int)delay{
    [self displayMBHUDActivityViewIn:view withText:text description:nil customView:customView removeAfterDelay:delay];
}
+(void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text description:(NSString *)description customView:(UIImageView *)customView removeAfterDelay:(int)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.customView = customView;
    hud.mode = MBProgressHUDModeCustomView;
    if (description) {
        hud.detailsLabelText = description;
    }
    hud.dimBackground = dimBackground;
    [hud hide:YES afterDelay:delay];
}
+(void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text customView:(UIImageView *)customView removeAfterDelay:(int)delay afterAction:(void_action_block)afterAction{
    [self displayMBHUDActivityViewIn:view withText:text description:nil customView:customView removeAfterDelay:delay afterAction:afterAction];
}
+(void)displayMBHUDActivityViewIn:(UIView *)view withText:(NSString *)text description:(NSString *)description customView:(UIImageView *)customView removeAfterDelay:(int)delay afterAction:(void_action_block)afterAction{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = dimBackground;
    hud.customView = customView;
    if (description) {
        hud.detailsLabelText = description;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		// Do a taks in the background
		sleep(delay);
		// Hide the HUD in the main tread
		dispatch_async(dispatch_get_main_queue(), ^{
			[MBProgressHUD hideHUDForView:view animated:YES];
            if (afterAction) {
                afterAction();
            }
		});
	});
}
+(MBProgressHUD *)displayMBHUDActivityProgressViewIn:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.progress=0;
    hud.dimBackground = dimBackground;
    return hud;
}
@end
