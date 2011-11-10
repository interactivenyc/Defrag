//
//  TblOfContents.m
//  Defrag
//
//  Created by Steve Warren on 11/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "TableOfContents.h"

@implementation TableOfContents

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)createTableOfContents: (NSDictionary *)contentDict{
    NSLog(@"DVC createTableOfContents");
    
    UIView *tableOfContentsView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 200.0f, 748.0f)];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 140.0f, 728.0f)];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.layer.cornerRadius = 10.0f;
    scrollView.layer.borderWidth = 2.0f;
    scrollView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    
    
    [tableOfContentsView addSubview:scrollView];
    
    int articleCount = [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] count];
    
    NSString *thumbPath;
    UIView *nextView;
    UIImage *myImage;
    UIImageView *imageView;
    
    int thumbWidth = 120.0f;
    int thumbHeight = 90.0f;
    int thumbY;
    int yOrigin = 20.0;
    int cellPadding = 20.0f;
    
    int TOCHeight = 10;
    
    for (int i=0; i<articleCount; i++) {
        NSLog(@"loop:%i", i);
        
        thumbPath = [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:i] objectForKey:@"Thumb"];
        thumbY = ((thumbHeight + cellPadding) * i);
        
        //NSLog(@"    thumbPath:%@", thumbPath);
        
        myImage = [UIImage imageNamed:thumbPath];
        imageView = [[UIImageView alloc] initWithImage:myImage];
        
        nextView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, thumbY+yOrigin, thumbWidth, thumbHeight)];
        nextView.backgroundColor = [UIColor greenColor];
        [nextView addSubview:imageView];
        
        [scrollView addSubview:nextView];
        
        TOCHeight += (nextView.frame.size.height + cellPadding);
        NSLog(@"    TOCHeight:%f", TOCHeight);
        
        [nextView release];
        [imageView release];
    }
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(140, TOCHeight)];
    
    [scrollView release];
    

    [self addSubview:tableOfContentsView];
    
    [tableOfContentsView release];
    
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
