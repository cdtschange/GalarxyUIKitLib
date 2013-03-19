//
//  MusicLrcHelper.m
//  GalarxyShow
//
//  Created by Wei Mao on 12/18/12.
//  Copyright (c) 2012 isoftstone. All rights reserved.
//

#import "MusicLrcHelper.h"
#import "MusicLrcLine.h"

@interface MusicLrcHelper()
{
    NSMutableArray *_tempArrayList;
    NSMutableArray *_arrayItemList;
}

@end

@implementation MusicLrcHelper

- (NSArray *)parseLrc:(NSString *)lrcContent
{
    // 按行分割
    NSArray *lineArray = [lrcContent componentsSeparatedByString:@"\n"];
    
    // 解析每一行歌词
    NSMutableArray *tempLineArray = [NSMutableArray array];
    for (NSString *sentence in lineArray) {
        
        // 解析歌曲头，即歌曲信息
        if ([sentence characterAtIndex:sentence.length-1] == ']') {
            if ([sentence hasPrefix:@"[ti:"]) {
                _songName = [sentence substringWithRange:NSMakeRange(4, sentence.length-5)];
                continue;
            }else if([sentence hasPrefix:@"[ar:"]){
                _artist = [sentence substringWithRange:NSMakeRange(4, sentence.length-5)];
                continue;
            }else if([sentence hasPrefix:@"[al:"]){
                _songAlbum = [sentence substringWithRange:NSMakeRange(4, sentence.length-5)];
                continue;
            }else if([sentence hasPrefix:@"[by:"]){
                _songAuthor = [sentence substringWithRange:NSMakeRange(4, sentence.length-5)];
                continue;
            }
        }
        
        // 有用信息分段
        NSArray *components = [sentence componentsSeparatedByString:@"]"];
        if (!components || components.count <= 0) {
            continue;
        }
        
        // 每行只有一句歌词
        NSString *songText = @"";
        if (![(NSString *)components[components.count-1] hasPrefix:@"["]) {
            songText = components[components.count-1];
        }
        
        // 解析歌词
        for (NSString *timeLine in components) {
            
            // 时间段
            if ([timeLine hasPrefix:@"["]) {
                MusicLrcLine *lrcLine = [[MusicLrcLine alloc] init];
                lrcLine.timeLine = [self convertFromLrcTimeFormatString:[timeLine substringFromIndex:1]];
                lrcLine.songLineText = songText;
                [tempLineArray addObject:lrcLine];
            }
        }
    }
    
    // 按时间从小到大的顺序排序
    NSArray *_songlinesArray = [tempLineArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        MusicLrcLine *prevObj = obj1;
        MusicLrcLine *nextObj = obj2;
        if (prevObj.timeLine > nextObj.timeLine) {
            return NSOrderedDescending;
        }else if (prevObj.timeLine < nextObj.timeLine){
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    return _songlinesArray;
}

- (NSTimeInterval)convertFromLrcTimeFormatString:(NSString *)timeString
{
    // timeString格式如：00:00.00..
    if (!timeString || timeString.length <= 3) {
        return 0;
    }
    
    NSString *minuteStr = [timeString substringToIndex:2];
    NSString *secondStr = [timeString substringFromIndex:3];
    return [minuteStr doubleValue]*60+[secondStr doubleValue];
}

@end
