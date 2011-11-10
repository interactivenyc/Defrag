//
//  TblOfContents.m
//  Defrag
//
//  Created by Steve Warren on 11/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "TableOfContents.h"
#import "ThumbView.h"

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
    NSLog(@"TOC createTableOfContents");
    
    UIView *tableOfContentsView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 200.0f, 738.0f)];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 140.0f, 718.0f)];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.layer.cornerRadius = 10.0f;
    scrollView.layer.borderWidth = 2.0f;
    scrollView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [tableOfContentsView addSubview:scrollView];
    
    int articleCount = [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] count];
    int thumbWidth = 120.0f;
    int thumbHeight = 90.0f;
    int thumbY;
    int yOrigin = 20.0;
    int cellPadding = 50.0f;
    int TOCHeight = 10;
    
    ThumbView *thumbView;
      
    for (int i=0; i<articleCount; i++) {
        //NSLog(@"loop:%i", i);
        
        thumbY = ((thumbHeight + cellPadding) * i);
        
        thumbView = [[ThumbView alloc] initWithFrame:CGRectMake(10.0f, thumbY+yOrigin, thumbWidth, thumbHeight)];
        [thumbView initWithArticleData:[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:i]];
        thumbView.thumbIndex = i;
        thumbView.backgroundColor = [UIColor greenColor];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailClicked:)];  
        [thumbView addGestureRecognizer:tapRecognizer];
        
        [scrollView addSubview:thumbView];
        
        TOCHeight += (thumbView.frame.size.height + cellPadding);
        
        [thumbView release];
        [tapRecognizer release];
    }
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(140, TOCHeight)];
    
    [self addSubview:tableOfContentsView];
    
    [scrollView release];
    [tableOfContentsView release];
    
}



- (void)thumbnailClicked:(UITapGestureRecognizer *)sender {
    
    ThumbView *thumbView = (ThumbView *)sender.view;
    
    NSLog(@"TOC ***************************");
    NSLog(@"TOC thumbnailClicked index:%i Title:%@", thumbView.thumbIndex, [thumbView.articleData objectForKey:@"Title"]);
    NSLog(@"TOC ***************************");
    
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
