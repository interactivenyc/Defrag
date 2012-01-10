//
//  DefragViewController.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/CoreAnimation.h>

#import "PageViewController.h"
#import "ImagePVC.h"
#import "MoviePVC.h"
#import "MenuPanel.h"

#import "FBConnect.h"

extern NSString *MENUPANEL_BTN_CLICKED;

@interface DefragViewController : UINavigationController
    <UIGestureRecognizerDelegate,
    FBRequestDelegate,
    FBDialogDelegate,
    FBSessionDelegate>

{	    
    int articleCount;
    int articleIndex;
    int pageCount;
    int pageIndex;
    char direction;
    
    UITapGestureRecognizer *tapRecognizer;
    NSDictionary *contentDict;
    PageViewController *currentPageViewController;
    MenuPanel *menuPanel;
    
    NSArray *permissions;
    
}


//*********************************************************
#pragma mark - INTERNAL PROPERTIES
//*********************************************************

//NAVIGATION PROPERTIES
@property int articleCount;
@property int articleIndex;
@property int pageCount;
@property int pageIndex;
@property char direction;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) NSDictionary *contentDict;
@property (nonatomic, retain) PageViewController *currentPageViewController;
@property (nonatomic, retain) MenuPanel *menuPanel;

@property (nonatomic, retain) NSArray *permissions;

//*********************************************************
#pragma mark - INTERNAL METHODS
//*********************************************************


//GESTURE SUPPORT
-(void)setupGestureRecognizers;
-(void)handleGesture: (UIGestureRecognizer *)sender;
-(void)handleTap: (UITapGestureRecognizer *)sender;
-(void)menuPanelButtonClicked:(NSNotification *)aNotification;

-(void)introduceDefrag:(NSTimer *)timer;

//ON SWIPE - PAGE NAVIGATION
-(void)setArticleByIndex:(int)newIndex;
-(void)createPage;
-(void)displayPage;
-(void)videoFinishedPlaying;

-(void)displayMenuPanel;
-(void)menuPanelHasAppeared;
-(void)removeMenuPanelView;

//UTILITIES
-(void)logPageInfo;
-(NSDictionary *)getMediaItem;
-(void)calculatePageCount;


//FACEBOOK
- (void) apiFQLIMe;;
- (void) apiGraphUserPermissions;
- (void) showLoggedIn;
- (void) showLoggedOut:(BOOL)clearInfo;
- (void)login;
- (void)logout;
- (void)fbPostToWall;

//TWITTER
-(void)tweetAbout;


@end
