//
//  PageData.m
//  Defrag
//
//  Created by Steve Warren on 9/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "PageData.h"

@implementation PageData

@synthesize pageDictionary;

-(NSString *)getMediaType
{
    return [pageDictionary objectForKey:@"Type"];
}

-(NSString *)getMediaPath
{
    return [pageDictionary objectForKey:@"Media"];
}
    


@end
