//
//  PageViewController.m
//  Defrag
//
//  Created by Steve Warren on 10/11/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "PageViewController.h"

@implementation PageViewController

@synthesize pageData;
@synthesize timeCreated;


-(void)dealloc
{
    NSLog(@"PVC dealloc");
    
    pageData = nil;
    [pageData release];
    //NSLog(@"released pageData");
    
    [timeCreated release];
    //NSLog(@"released timeCreated");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)initWithPageData:(PageData *)data
{
    //NSLog(@"PVC initWithPageData");
    pageData = data;
    timeCreated = [[NSDate alloc] init];
    
}


-(void)logLifetime
{
    NSDate *now = [[NSDate alloc] init];
    NSLog(@"PVC logLifetime:%f", fabs([now timeIntervalSinceDate:timeCreated]));
}

-(void)pageWillDisplay
{
    //NSLog(@"PVC pageWillDisplay");
    //THIS METHOD MUST BE OVERRIDEN IN IMPLEMENTATION CLASSES
}

-(void)pageDidDisplay
{
    //NSLog(@"PVC pageDidDisplay");
    //THIS METHOD MUST BE OVERRIDEN IN IMPLEMENTATION CLASSES
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    NSLog(@"PVC viewDidUnload");
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
