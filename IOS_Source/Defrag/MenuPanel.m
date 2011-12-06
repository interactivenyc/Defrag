//
//  MenuPanel.m
//  Defrag
//
//  Created by Steve Warren on 11/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "MenuPanel.h"
#import "DefragViewController.h"


@implementation MenuPanel

@synthesize buttonDict;
@synthesize toolbar;

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BUTTON_CLICKED object:buttonName];
    
}

- (void)action:(id)sender
{
	NSLog(@"UIBarButtonItem clicked %@", sender);
}


@end
