//  Copyright (c) 2011 Hegaka
//  All rights reserved


#import <UIKit/UIKit.h>

@protocol HegakaGalleryButtonDelegate;

@interface HegakaGalleryButton : UIView
{
    
    id<HegakaGalleryButtonDelegate> delegate;
    
    CGPoint _originalPosition;
    CGPoint _originalOutsidePosition;
    
    BOOL isInScrollview;
    
    // PARENT VIEW WHERE THE VIEWS CAN BE DRAGGED
    UIView *mainView;
    // SCROLL VIEW WHERE YOU GONNA PUT THE THUMBNAILS
    UIScrollView *scrollParent;
}

@property (nonatomic, retain) id<HegakaGalleryButtonDelegate> delegate;

@property (nonatomic) CGPoint originalPosition;

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIScrollView *scrollParent;

@end


@protocol HegakaGalleryButtonDelegate
-(void) touchDown;
-(void) touchUp;
-(BOOL) isInsideRecycleBin:(HegakaGalleryButton *)button touching:(BOOL)finished;
@end


