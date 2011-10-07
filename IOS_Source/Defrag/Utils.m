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



+ (NSString *) append:(id) first, ...
{
    NSString * result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
        result = [result stringByAppendingString:first];
        va_start(alist, first);
        while (eachArg == va_arg(alist, id)) 
			result = [result stringByAppendingString:eachArg];
        va_end(alist);
    }
    return result;
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
