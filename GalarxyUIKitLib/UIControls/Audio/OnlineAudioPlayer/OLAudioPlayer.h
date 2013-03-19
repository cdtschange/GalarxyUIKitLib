//
//  AudioPlayer.h
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLAudioButton;
@class OLAudioStreamer;

@interface OLAudioPlayer : NSObject {
    OLAudioStreamer *streamer;
    OLAudioButton *button;   
    NSURL *url;
    NSTimer *timer;
}

@property (nonatomic, retain) OLAudioStreamer *streamer;
@property (nonatomic, retain) OLAudioButton *button;
@property (nonatomic, retain) NSURL *url;

- (void)play;
- (void)stop;
- (BOOL)isProcessing;

@end
