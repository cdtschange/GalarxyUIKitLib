//
//  TouchAbleLabel.h
//  testTags
//
//  Created by Alex on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBCyclingLabel.h"
@class  TouchAbleLabel;

@protocol TouchAbleLabelDelegate <NSObject>
@required
- (void)touchAbleLabel:(TouchAbleLabel *)myLabel touchesWtihTag:(NSInteger)tag;
@end

@interface TouchAbleLabel : BBCyclingLabel 
{
    id <TouchAbleLabelDelegate> delegate;
}


@property (nonatomic, assign) id <TouchAbleLabelDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;




@end