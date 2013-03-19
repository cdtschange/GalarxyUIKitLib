//
//  MusicLrcHelper.h
//  GalarxyShow
//
//  Created by Wei Mao on 12/18/12.
//  Copyright (c) 2012 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicLrcHelper : NSObject

@property(copy,nonatomic) NSString *songName;
@property(copy,nonatomic) NSString *artist;
@property(copy,nonatomic) NSString *songAlbum;
@property(copy,nonatomic) NSString *songAuthor;

- (NSArray *)parseLrc:(NSString *)lrcContent;

@end
