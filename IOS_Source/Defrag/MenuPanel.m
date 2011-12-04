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
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
    UIBarButtonItem *prefsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prefs.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];

	NSArray *items = [NSArray arrayWithObjects: homeItem, menuItem, flexItem, infoItem,  prefsItem, nil];
	[self.toolbar setItems:items animated:NO];

	[homeItem release];
	[menuItem release];
    [flexItem release];
	[infoItem release];
	[prefsItem release];
}


-(void)buttonClicked:(id *)sender {
        
    NSLog(@"MenuPanel ***************************");
    NSLog(@"MenuPanel buttonClicked %@", sender);
    NSLog(@"MenuPanel ***************************");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BUTTON_HOME object:self];
    
}


@end
