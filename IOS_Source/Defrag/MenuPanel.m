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
    
    
    UIButton *top = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1024, 42)];
    top.backgroundColor = [UIColor blackColor];
    top.alpha = .50;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];  
    [top addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    UIButton *bottom = [[UIButton alloc] initWithFrame:CGRectMake(0, 726, 1024, 42)];
    bottom.backgroundColor = [UIColor blackColor];
    bottom.alpha = .50;
    
    [self addSubview:top];
    [top release];
    [self addSubview:bottom];
    [bottom release];
    
    [self addButton:@"home.png" xPos:20 yPos:10];
    [self addButton:@"menu.png" xPos:60 yPos:11];
    
    
    [self addButton:@"info.png" xPos:945 yPos:10];
    [self addButton:@"help.png" xPos:985 yPos:10];
    
    
    
    
    // create the UIToolbar at the bottom of the view controller
	//
    toolbar = [UIToolbar new];
	toolbar.barStyle = UIBarStyleDefault;
    
    // size up the toolbar and set its frame
	[toolbar sizeToFit];
	CGFloat toolbarHeight = [toolbar frame].size.height;
	CGRect mainViewBounds = self.bounds;
	[toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
								 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight * 2.0) + 2.0,
								 CGRectGetWidth(mainViewBounds),
								 toolbarHeight)];
	
	[self addSubview:toolbar];
    
	[self createToolbarItems];
	

    
}


- (void)createToolbarItems
{	

    
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(buttonClicked:)];
     
	// create a special tab bar item with a custom image and title
	UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(buttonClicked:)];
	
    
    // create a bordered style button with custom title
	UIBarButtonItem *helpItem = [[UIBarButtonItem alloc] initWithTitle:@"HELP"
                                                                   style:UIBarButtonItemStyleDone	// note you can use "UIBarButtonItemStyleDone" to make it blue
                                                                  target:self
                                                                  action:@selector(buttonClicked:)];
	
	NSArray *items = [NSArray arrayWithObjects: homeItem, menuItem, helpItem, nil];
	[self.toolbar setItems:items animated:NO];
	

	[homeItem release];
	[menuItem release];
	[helpItem release];
}

-(void) addButton:(NSString *)imageName xPos:(int)xPos yPos:(int)yPos{
    NSLog(@"MenuPanel ");
    
    UIImage *buttonImage;
    UIButton *aButton;
    
    buttonImage = [UIImage imageNamed:imageName];
        
    aButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    aButton.frame = CGRectMake(xPos, yPos, 24, 24);
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];  
    [aButton addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    [self addSubview:aButton];
}


-(void)buttonClicked:(UITapGestureRecognizer *)sender {
    
    UIView *senderView = sender.view;
    
    NSLog(@"MenuPanel ***************************");
    NSLog(@"MenuPanel buttonClicked %@", senderView);
    NSLog(@"MenuPanel ***************************");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BUTTON_HOME object:self];
    
}


@end
