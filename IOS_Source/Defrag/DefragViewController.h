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

#import "DefragAppDelegate.h"
#import "ImagePVC.h"
#import "MoviePVC.h"

@interface DefragViewController : UINavigationController <UIGestureRecognizerDelegate>
{	    
    int articleCount;
    int articleIndex;
    int pageCount;
    int pageIndex;
    
    char direction;
    
	UISwipeGestureRecognizer *swipeRightRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;   
	UISwipeGestureRecognizer *swipeUpRecognizer;
	UISwipeGestureRecognizer *swipeDownRecognizer;   
    
    UITapGestureRecognizer *tapRecognizer;
    
    NSDictionary *contentDict;
    
    PageViewController *currentPageView;
    MPMoviePlayerViewController *moviePlayerViewController;
    
    UIPopoverController *popoverViewController;
    UIViewController *tableOfContentsViewController;
    UIView *tableOfContentsView;
    
}


//*********************************************************
#pragma mark - INTERNAL PROPERTIES
//*********************************************************

//NAVIGATION PROPERTIES
@property int articleCount;
@property int articleIndex;
@property int pageIndex;
@property int pageCount;

@property char direction;


//GESTURE RECOGNIZERS
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownRecognizer;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;

//CONTENT DATA
@property (nonatomic, retain) NSDictionary *contentDict;

//PAGE VIEW CONTROLLER
@property (nonatomic, retain) PageViewController *currentPageView;

//MOVIE PLAYER VIEW CONTROLLER
@property (nonatomic, retain) MPMoviePlayerViewController *moviePlayerViewController;

//TABLE OF CONTENTS POPOVER
@property (nonatomic, retain) UIPopoverController *popoverViewController;
@property (nonatomic, retain) UIViewController *tableOfContentsViewController;
@property (nonatomic, retain) UIView *tableOfContentsView;



//*********************************************************
#pragma mark - INTERNAL METHODS
//*********************************************************


//GESTURE SUPPORT
-(void)setupGestureRecognizers;
-(void)handleGesture: (UIGestureRecognizer *)sender;
-(void)handleTap: (UITapGestureRecognizer *)sender;

//ON SWIPE - PAGE NAVIGATION
-(void)createPage;
-(void)displayPage;

//ON TAP - POPOVER HANDLING
-(void)createTableOfContents;
-(void)displayTableOfContents;

//UTILITIES
-(void)logPageInfo;
-(NSDictionary *)getMediaItem;
-(void)calculatePageCount;

@end
