//
//  MenuPanel.m
//  Defrag
//
//  Created by Steve Warren on 11/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "MenuPanel.h"
#import "DefragAppDelegate.h"
#import "DefragViewController.h"

@implementation MenuPanel

@synthesize buttonDict;
@synthesize toolbar;
@synthesize tableOfContentsView;
//@synthesize defragViewController;

int TOC_WIDTH = 332;
int TOC_HEIGHT = 726;

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
    
    toolbar = [UIToolbar new];
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	[toolbar sizeToFit];
    
	[self addSubview:toolbar];
	[self createToolbarItems];
	
}


- (void)createToolbarItems
{	
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    UIBarButtonItem *prefsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prefs.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    
	NSArray *items = [NSArray arrayWithObjects: homeButton, menuButton, flexItem, infoButton,  prefsButton, nil];
    NSArray *itemKeys = [NSArray arrayWithObjects: @"homeButton", @"menuButton", @"flexItem", @"infoButton",  @"prefsButton", nil];

	[self.toolbar setItems:items animated:NO];
        
    buttonDict = [[NSDictionary alloc] initWithObjects:items forKeys:itemKeys];

	[homeButton release];
	[menuButton release];
    [flexItem release];
	[infoButton release];
	[prefsButton release];
}


-(void)buttonClicked:(id)sender {
        
    NSString *buttonName = [[buttonDict allKeysForObject:sender] objectAtIndex:0];
    
    NSLog(@"MenuPanel ***************************");
    NSLog(@"MenuPanel buttonClicked %@", buttonName);
    NSLog(@"MenuPanel ***************************");  
    
    DefragAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    DefragViewController *defragViewController = appDelegate.viewController;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BUTTON_CLICKED object:buttonName];
    
    if ([buttonName isEqualToString:@"homeButton"]){
        [defragViewController setArticleByIndex:0];
        
    }else if ([buttonName isEqualToString:@"menuButton"]){
        [self displayTableOfContents];
        
    }else if ([buttonName isEqualToString:@"infoButton"]){
        
        UIViewController *infoViewController = [[UIViewController alloc] init];
        infoViewController.view.backgroundColor = [UIColor whiteColor];
        
        UIPopoverController *info = [[UIPopoverController alloc] initWithContentViewController:infoViewController];
        info.popoverContentSize = CGSizeMake(300, 300);
        [info presentPopoverFromRect:CGRectMake(952, 24, 24, 24) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

    }else if ([buttonName isEqualToString:@"prefsButton"]){
        UIViewController *infoViewController = [[UIViewController alloc] init];
        infoViewController.view.backgroundColor = [UIColor whiteColor];
        
        UIPopoverController *info = [[UIPopoverController alloc] initWithContentViewController:infoViewController];
        info.popoverContentSize = CGSizeMake(300, 300);
        [info presentPopoverFromRect:CGRectMake(1000, 24, 24, 24) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }    
    
    
}



- (void)displayTableOfContents{
    
    if (!tableOfContentsView)
    {
        NSLog(@"DVC displayTableOfContents");
        
        tableOfContentsView = [[TableOfContents alloc] initWithFrame:CGRectMake(-TOC_WIDTH, 42, TOC_WIDTH, TOC_HEIGHT)];
        
        DefragAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        DefragViewController *defragViewController = appDelegate.viewController;
        [tableOfContentsView createTableOfContents:defragViewController.contentDict];
        
        [self addSubview:tableOfContentsView];
        
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView animateWithDuration:0.2
                         animations:^{tableOfContentsView.frame = CGRectMake(0, 42, TOC_WIDTH, TOC_HEIGHT);}
                         completion:^(BOOL finished){ [self tableOfContentsHasAppeared]; }];
        [UIView commitAnimations];
    }
    else
    {
        NSLog(@"DVC displayTableOfContents DELETE");
        
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView animateWithDuration:0.2
                         animations:^{tableOfContentsView.frame = CGRectMake(-TOC_WIDTH, 42, TOC_WIDTH, TOC_HEIGHT);}
                         completion:^(BOOL finished){ [self removeTableOfContentsView]; }];
        [UIView commitAnimations];
    }
}


-(void)tableOfContentsHasAppeared
{
    NSLog(@"DVC tableOfContentsHasAppeared");
}


-(void)removeTableOfContentsView
{
    [tableOfContentsView removeFromSuperview];
    [tableOfContentsView release];
    tableOfContentsView = nil;
}

- (void)action:(id)sender
{
	NSLog(@"UIBarButtonItem clicked %@", sender);
}


@end
