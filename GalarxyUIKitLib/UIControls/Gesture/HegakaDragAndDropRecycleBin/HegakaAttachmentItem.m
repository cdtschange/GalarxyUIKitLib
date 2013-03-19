//  Copyright (c) 2011 Hegaka
//  All rights reserved

#import "HegakaAttachmentItem.h"


@implementation HegakaAttachmentItem

@synthesize type, data;

-(id)initWithData:(int)dataType data:(NSData *)dataBytes;
{
    self.type=dataType;
    self.data=dataBytes;
    return self;
}


@end
