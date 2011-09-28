//
//  PageData.h
//  Defrag
//
//  Created by Steve Warren on 9/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageData : NSObject
{
    NSDictionary *data;
}

//*********************************************************
#pragma mark - INTERNAL PROPERTIES AND METHODS
//*********************************************************

@property (nonatomic, retain) NSDictionary *data;

@end
