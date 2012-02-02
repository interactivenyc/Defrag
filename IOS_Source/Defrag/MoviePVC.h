//
//  MoviePVC.h
//  Defrag
//
//  Created by Steve Warren on 10/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "PageViewController.h"

@interface MoviePVC : PageViewController
{
    MPMoviePlayerViewController *moviePlayerViewController;
    
    UISwipeGestureRecognizer *swipeRightRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;   
	UISwipeGestureRecognizer *swipeUpRecognizer;
	UISwipeGestureRecognizer *swipeDownRecognizer; 
    
    UITapGestureRecognizer *tapRecognizer;
    
    NSURL *fileURL;
    MPMoviePlayerController *moviePlayer;
    
    bool movieFinished;
}

@property (nonatomic, retain) MPMoviePlayerViewController *moviePlayerViewController;

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;   
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownRecognizer; 

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

@property bool movieFinished;


//GESTURE SUPPORT
-(void)setupGestureRecognizers;
-(void)handleGesture: (UIGestureRecognizer *)sender;
-(void)sendGesture: (UISwipeGestureRecognizer *)sender;
-(void)handleTap: (UITapGestureRecognizer *)sender;
-(void)stopPlaying;

@end
