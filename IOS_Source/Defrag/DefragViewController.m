//
//  DefragViewController.m
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "DefragViewController.h"
#import "DefragAppDelegate.h"

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4

@implementation DefragViewController
@synthesize defragButton;
@synthesize headerText;
@synthesize movieURL; 

@synthesize swipeRightRecognizer, swipeLeftRecognizer;



//*****************************************
	#pragma mark - VIEW DID LOAD
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");
    
    [self setupGestureRecognizer];
    
}


//*****************************************
	#pragma mark - EVENT HANDLING
//*****************************************


-(IBAction)defragButtonClicked:(id)sender;
{
    NSLog(@"defragButtonClicked");
    
    DefragAppDelegate *appDelegate = (DefragAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate initAndPlayMovie:@"DeFragCvr2 V.mov"];

}



-(void)setupGestureRecognizer
{
    
    NSLog(@"setupGestureRecognizer");
	
	swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipeRightRecognizer];
	
	swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swipeLeftRecognizer];
}


-(void)handleGesture: (UISwipeGestureRecognizer *)sender
{
	NSLog(@"handleGesture");
	
	if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
		NSLog(@"handleGesture Left");
    }
    else {
		NSLog(@"handleGesture Right");
    }
	
	
}





//*****************************************
	#pragma mark - SWIPE GESTURE HANDLING
//*****************************************

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    // startTouchPosition is an instance variable
    startTouchPosition = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    // To be a swipe, direction of touch must be horizontal and long enough.
    if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
    {
        // It appears to be a swipe.
        if (startTouchPosition.x < currentTouchPosition.x)
            [self myProcessRightSwipe:touches withEvent:event];
        else
            [self myProcessLeftSwipe:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    startTouchPosition = CGPointZero;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    startTouchPosition = CGPointZero;
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            //[self.superview bringSubviewToFront:self];
            // A DOUBLE TAP OCCURRED
        }
    }
}

*/


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}



//*****************************************
	#pragma mark - MEMORY CLEANUP
//*****************************************

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
