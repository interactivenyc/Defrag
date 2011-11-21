//
//  TblOfContents.m
//  Defrag
//
//  Created by Steve Warren on 11/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "TableOfContents.h"
#import "ThumbView.h"
#import "DefragAppDelegate.h"

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
    
    UIView *tableOfContentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 332, 758.0f)];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 332, 758.0f)];
    scrollView.backgroundColor = [UIColor clearColor];
    //scrollView.layer.cornerRadius = 10.0f;
    //scrollView.layer.borderWidth = 2.0f;
    //scrollView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    UIView *transparentBG = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 332.0f, 758.0f)];
    transparentBG.backgroundColor = [UIColor blackColor];
    transparentBG.alpha = .50;
    
    [tableOfContentsView addSubview:transparentBG];
    [tableOfContentsView addSubview:scrollView];
    
    int articleCount = [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] count];
    int thumbWidth = 325;
    int thumbHeight = 87;
    int thumbY;
    int yOrigin = 18.0;
    int cellPadding = 50.0f;
    int TOCHeight = 10;
    
    ThumbView *thumbView;
      
    for (int i=0; i<articleCount; i++) {
        //NSLog(@"loop:%i", i);
        
        thumbY = ((thumbHeight + cellPadding) * i);
        
        thumbView = [[ThumbView alloc] initWithFrame:CGRectMake(3.0f, thumbY+yOrigin, thumbWidth, thumbHeight)];
        [thumbView initWithArticleData:[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:i]];
        thumbView.thumbIndex = i;
        //thumbView.backgroundColor = [UIColor greenColor];
        
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
    [transparentBG release];
    [tableOfContentsView release];
    
}



- (void)thumbnailClicked:(UITapGestureRecognizer *)sender {
    
    ThumbView *thumbView = (ThumbView *)sender.view;
    
    NSLog(@"TOC ***************************");
    NSLog(@"TOC thumbnailClicked index:%i Title:%@", thumbView.thumbIndex, [thumbView.articleData objectForKey:@"Title"]);
    NSLog(@"TOC ***************************");
    
    DefragAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.viewController setArticleByIndex:thumbView.thumbIndex];
    
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
