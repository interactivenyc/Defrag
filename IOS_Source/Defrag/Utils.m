//
//  Utils.m
//  Defrag
//
//  Created by swarren on 7/9/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "Utils.h"


@implementation Utils

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


+ (void)test
{
	NSLog(@"UTILS test");
	//NSLog(@"%@", [self append:one, @" ", two, nil]);
}


void doLog(int level, id formatstring,...)
{
    int i;
    for (i = 0; i < level; i++) printf("    ");
    
    va_list arglist;
    if (formatstring)
    {
        va_start(arglist, formatstring);
        id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
        fprintf(stderr, "%s\n", [outstring UTF8String]);
        va_end(arglist);
        
        [outstring release];
    }
}


+ (void) explode: (id) aView level: (int) level
{
    doLog(level, @"%@", [[aView class] description]);
    doLog(level, @"%@", NSStringFromCGRect([aView frame]));
    for (UIView *subview in [aView subviews])
        [self explode:subview level:(level + 1)];
}


+ (void) showViews
{
    [self explode:[[UIApplication sharedApplication] keyWindow] level:0];
}






+ (void)log
{
	NSLog(@"UTILS log");
}


- (void)dealloc
{
    [super dealloc];
}

@end
