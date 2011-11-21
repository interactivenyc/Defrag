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

    UIView *transparentBG = [[UIView alloc] initWithFrame:CGRectMake(-0.0f, -5.0f, 325.0f, 135.0f)];
    transparentBG.backgroundColor = [UIColor blackColor];
    transparentBG.alpha = .5;
    
    [self addSubview:transparentBG];
    
    UIImage *myImage;
    UIImageView *imageView;
    
    myImage = [UIImage imageNamed:[articleData objectForKey:@"Thumb"]];
    imageView = [[UIImageView alloc] initWithImage:myImage];
    
    CGRect imageFrame = imageView.frame;
    
    imageFrame.origin.x = 10;
    imageFrame.origin.y = 10;
    imageView.frame = imageFrame;
    
    [self addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(136, 0, 180, 24)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [title setText:[articleData objectForKey:@"Title"]];
    [self addSubview:title];
    
    UITextView *description = [[UITextView alloc] initWithFrame:CGRectMake(126, 16, 180, 100)];
    description.backgroundColor = [UIColor clearColor];
    description.textColor = [UIColor whiteColor];
    description.font = [UIFont fontWithName:@"Helvetica-Oblique" size:12];
    [description setText:[articleData objectForKey:@"Description"]];
    
    [self addSubview:description];
    
    [imageView release];
    [title release];
    [description release];
    
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
