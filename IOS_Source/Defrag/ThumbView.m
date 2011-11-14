//
//  ThumbView.m
//  Defrag
//
//  Created by Steve Warren on 11/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "ThumbView.h"

@implementation ThumbView

@synthesize articleData;
@synthesize thumbIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initWithArticleData:(NSDictionary *)data
{
    NSLog(@"TV initWithArticleData");
    articleData = data;
    
    UIImage *myImage;
    UIImageView *imageView;
    
    myImage = [UIImage imageNamed:[articleData objectForKey:@"Thumb"]];
    imageView = [[UIImageView alloc] initWithImage:myImage];
    
    [self addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 120, 24)];
    title.backgroundColor = [UIColor clearColor];
    [title setText:[articleData objectForKey:@"Title"]];
    [self addSubview:title];
    
    [imageView release];
    [title release];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
