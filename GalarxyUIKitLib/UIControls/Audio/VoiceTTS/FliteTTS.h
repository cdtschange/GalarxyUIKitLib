//
//  FliteTTS.h
//  VoiceTTS
//
//  Created by 朱克锋 on 12-11-15.
//  Copyright (c) 2012年 朱克锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface FliteTTS : NSObject <AVAudioPlayerDelegate> {
	//NSData *soundObj;		
	AVAudioPlayer* audioPlayer;
}

// Use these:
-(void)speakText:(NSString *)text;
-(void)stopTalking;
-(void)setPitch:(float)pitch variance:(float)variance speed:(float)speed;
-(void)setVoice:(NSString *)voicename;
@end
