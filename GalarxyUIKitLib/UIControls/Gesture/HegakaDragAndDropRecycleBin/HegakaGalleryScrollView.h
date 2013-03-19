//  Copyright (c) 2011 Hegaka
//  All rights reserved


#import <UIKit/UIKit.h>
#import "HegakaAttachmentItem.h"
#import "HegakaGalleryButton.h"

@protocol HegakaGAlleryScrollDelegate;

@interface HegakaGalleryScrollView : UIView <HegakaGalleryButtonDelegate>
{
    
    id <HegakaGAlleryScrollDelegate> delegate;
    
    // MAIN WINDOW WHERE YOU CAN DRAG ICONS
    UIView *mainView;
    
    UIScrollView *_scrollView;
    NSMutableArray *_attachments;
    
    
    NSInteger *_totalSize;
    
    UIImageView *_recycleBin;
    CGRect recycleBinFrame;
    
}

@property (nonatomic, retain) id <HegakaGAlleryScrollDelegate> delegate;

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) NSMutableArray *attachments;

@property (nonatomic, retain) UIImageView *recycleBin;
@property (nonatomic) CGRect recycleBinFrame;

- (void) addAttachment:(HegakaAttachmentItem *)attachment;
- (void) removeAttachment:(HegakaGalleryButton *)button;
- (void) reloadData;


@end

// EVENTS IF YOU WANT TO DISABLE SOME SCROLL ON DID PRESS AND ENABLE IT ON DROP
@protocol HegakaGAlleryScrollDelegate
- (void) didPressButton;
- (void) didDropButton;
@end