//
//  DefragViewController.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface DefragViewController : UINavigationController <UIGestureRecognizerDelegate, NSXMLParserDelegate>
{	    
	UISwipeGestureRecognizer *swipeRightRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;   
	UISwipeGestureRecognizer *swipeUpRecognizer;
	UISwipeGestureRecognizer *swipeDownRecognizer;   
    
    NSDictionary *contentDict;
    
    int articleCount;
    int articleIndex;
    int pageCount;
    int pageIndex;

    MPMoviePlayerController *moviePlayer;
    
    
}


//*********************************************************
	#pragma mark - INTERNAL PROPERTIES AND METHODS
//*********************************************************

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownRecognizer;

@property (nonatomic, retain) NSDictionary *contentDict;

@property int articleCount;
@property int pageCount;
@property int articleIndex;
@property int pageIndex;

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;


-(void)setupGestureRecognizer;
-(void)logPageInfo;
-(NSDictionary *)getMediaItem;
-(void)handleGesture: (UIGestureRecognizer *)sender;
-(void)turnPage: (char)whichDirection;
-(void)playerPlaybackDidFinish:(NSNotification *)notification;

@end
