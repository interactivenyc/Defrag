//
//  PageViewController.h
//  Defrag
//
//  Created by Steve Warren on 9/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageData.h"

@interface PageViewController : UIViewController
{

    PageData *pageData;
    
}

//*********************************************************
#pragma mark - INTERNAL PROPERTIES AND METHODS
//*********************************************************

@property (nonatomic, retain) PageData *pageData;

-(void)setPageDataWithDictionary:(NSDictionary *)pageDict;
-(NSString *)getMediaType;
-(NSString *)getMediaPath;

@end

