//
//  MenuPanel.h
//  Defrag
//
//  Created by Steve Warren on 11/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

//#import "DefragViewController.h"
#import "TableOfContents.h"

//extern NSString *BUTTON_CLICKED;

@interface MenuPanel : UIView <UINavigationBarDelegate>{
    
    //DefragViewController *defragViewController;
    
    NSDictionary *buttonDict;
    UIToolbar *toolbar;
    TableOfContents *tableOfContentsView;

}

//@property(nonatomic, retain) DefragViewController *defragViewController;
@property(nonatomic, retain) NSDictionary *buttonDict;
@property(nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) TableOfContents *tableOfContentsView;


-(void)createMenuPanel;
-(void)createToolbarItems;
-(void)buttonClicked:(id)sender;

//TABLE OF CONTENTS
-(void)displayTableOfContents;
-(void)tableOfContentsHasAppeared;
-(void)removeTableOfContentsView;

@end
