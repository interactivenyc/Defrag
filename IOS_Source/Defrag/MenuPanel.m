//
//  MenuPanel.m
//  Defrag
//
//  Created by Steve Warren on 11/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "MenuPanel.h"

@implementation MenuPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)createMenuPanel{
    NSLog(@"MenuPanel createMenuPanel");
    
    UIButton *top = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1024, 42)];
    top.backgroundColor = [UIColor blackColor];
    top.alpha = .50;
    
    UIButton *bottom = [[UIButton alloc] initWithFrame:CGRectMake(0, 726, 1024, 42)];
    bottom.backgroundColor = [UIColor blackColor];
    bottom.alpha = .50;
    
    [self addSubview:top];
    [self addSubview:bottom];
    
    [self addButton:@"home.png" xPos:20 yPos:10];
    [self addButton:@"menu.png" xPos:60 yPos:11];
    
    
    [self addButton:@"info.png" xPos:945 yPos:10];
    [self addButton:@"help.png" xPos:985 yPos:10];
    
    /*
    
    UIImage *articlesImg;
    UIImageView *articlesBtn;
    CGRect articleFrame;
    
    articlesImg = [UIImage imageNamed:@"articles.png"];
    articlesBtn = [[UIImageView alloc] initWithImage:articlesImg];
    
    articleFrame = articlesBtn.frame;
    
    articleFrame.origin.x = 12;
    articleFrame.origin.y = 0;
    articlesBtn.frame = articleFrame;
    
    
    [self addSubview:articlesBtn];
     
     */
    
    
    
}

-(void) addButton:(NSString *)imageName xPos:(int)xPos yPos:(int)yPos{
    
    UIImage *buttonImage;
    UIImageView *newButton;
    CGRect imageFrame;
    
    buttonImage = [UIImage imageNamed:imageName];
    newButton = [[UIImageView alloc] initWithImage:buttonImage];
    
    imageFrame = newButton.frame;
    
    imageFrame.origin.x = xPos;
    imageFrame.origin.y = yPos;
    newButton.frame = imageFrame;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];  
    [newButton addGestureRecognizer:tapRecognizer];
    
    [tapRecognizer release];
    
    [self addSubview:newButton];
    [buttonImage release];
    [newButton release];
}


-(void)buttonClicked:(UITapGestureRecognizer *)sender {
    
    //UIView *senderView = sender.view;
    
    NSLog(@"MenuPanel ***************************");
    NSLog(@"MenuPanel buttonClicked");
    NSLog(@"MenuPanel ***************************");
    
    //DefragAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[appDelegate.viewController setArticleByIndex:thumbView.thumbIndex];
    
}


@end
