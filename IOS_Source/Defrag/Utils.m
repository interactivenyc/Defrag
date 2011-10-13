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








+ (void)log
{
	NSLog(@"UTILS log");
}


- (void)dealloc
{
    [super dealloc];
}

@end
