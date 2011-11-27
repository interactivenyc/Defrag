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

#import "DefragAppDelegate.h"
#import "ImagePVC.h"
#import "MoviePVC.h"
#import "TableOfContents.h"
#import "MenuPanel.h"

@interface DefragViewController : UINavigationController <UIGestureRecognizerDelegate>
{	    
    int articleCount;
    int articleIndex;
    int pageCount;
    int pageIndex;
    
    char direction;
    
    NSDictionary *contentDict;
    
    PageViewController *currentPageViewController;
    TableOfContents *tableOfContentsView;
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

//CONTENT DATA
@property (nonatomic, retain) NSDictionary *contentDict;

//VIEW CONTROLLERS
@property (nonatomic, retain) PageViewController *currentPageViewController;
@property (nonatomic, retain) TableOfContents *tableOfContentsView;

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
-(void)pageHasDisplayed;

//TABLE OF CONTENTS
-(void)displayTableOfContents;
-(void)tableOfContentsHasAppeared;
-(void)removeTableOfContentsView;

- (void)displayMenuPanel;
-(void)menuPanelHasAppeared;
-(void)removeMenuPanelView;

//UTILITIES
-(void)logPageInfo;
-(NSDictionary *)getMediaItem;
-(void)calculatePageCount;

@end
