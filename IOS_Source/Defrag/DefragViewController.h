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

extern NSString *BUTTON_CLICKED;

@interface DefragViewController : UINavigationController <UIGestureRecognizerDelegate>
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



//*********************************************************
#pragma mark - INTERNAL METHODS
//*********************************************************


//GESTURE SUPPORT
-(void)setupGestureRecognizers;
-(void)handleGesture: (UIGestureRecognizer *)sender;
-(void)handleTap: (UITapGestureRecognizer *)sender;

//ON SWIPE - PAGE NAVIGATION
-(void)setArticleByIndex:(int)newIndex;
-(void)createPage;
-(void)displayPage;
//-(void)pageHasDisplayed;

-(void)displayMenuPanel;
-(void)menuPanelHasAppeared;
-(void)removeMenuPanelView;

//UTILITIES
-(void)logPageInfo;
-(NSDictionary *)getMediaItem;
-(void)calculatePageCount;

@end
