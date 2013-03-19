//
//  iCodeBlogAnnotation.m
//  iCodeMap
//
//  Created by Collin Ruffenach on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "iCodeBlogAnnotation.h"


@implementation iCodeBlogAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize annotationType;

-(id)init
{
	return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)inCoord
{
	coordinate = inCoord;
	return self;
}

@end
