//
//  DefragViewController.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/CoreAnimation.h>
#import "PageViewController.h"

@interface DefragViewController : UINavigationController <UIGestureRecognizerDelegate>
{	    
	UISwipeGestureRecognizer *swipeRightRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;   
	UISwipeGestureRecognizer *swipeUpRecognizer;
	UISwipeGestureRecognizer *swipeDownRecognizer;   
    
    UITapGestureRecognizer *tapRecognizer;
    
    NSDictionary *contentDict;
    PageViewController *currentPageView;
    
    UIView *tableOfContentsView;
    
    
    int articleCount;
    int articleIndex;
    int pageCount;
    int pageIndex;

    MPMoviePlayerController *moviePlayer;
    
    //CGPoint startTouchPosition;
    
    
}


//*********************************************************
	#pragma mark - INTERNAL PROPERTIES
//*********************************************************

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownRecognizer;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, retain) NSDictionary *contentDict;

@property (nonatomic, retain) PageViewController *currentPageView;

@property (nonatomic, retain) UIView *tableOfContentsView;

@property int articleCount;
@property int articleIndex;
@property int pageIndex;
@property int pageCount;

//@property CGPoint startTouchPosition;

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

//*********************************************************
#pragma mark - INTERNAL METHODS
//*********************************************************

-(void)setupGestureRecognizer;

-(void)logPageInfo;
-(NSDictionary *)getMediaItem;

-(void)handleGesture: (UIGestureRecognizer *)sender;
-(void)handleTap: (UITapGestureRecognizer *)sender;


-(void)createTableOfContents;
-(void)displayTableOfContents;

-(void)calculatePageCount;
-(void)turnPage: (char)whichDirection;
-(void)displayJPG:(int)whichDirection;
-(void)displayMOV:(int)whichDirection;
-(void)playerPlaybackDidFinish:(NSNotification *)notification;

@end
