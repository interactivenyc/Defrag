//
//  ThumbView.h
//  Defrag
//
//  Created by Steve Warren on 11/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbView : UIView
{
    NSDictionary *articleData;   
    int thumbIndex;
}

@property (nonatomic, retain) NSDictionary *articleData;
@property int thumbIndex;



@end
