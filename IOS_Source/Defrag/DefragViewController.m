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

@synthesize swipeRightRecognizer, swipeLeftRecognizer, tapRecognizer;

//@synthesize contentContainer;

//@synthesize startTouchPosition;



//*****************************************
//
  #pragma mark - MEMORY CLEANUP
//
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


//*****************************************
//
  #pragma mark - VIEW DID LOAD
//
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");
    
    [self setupGestureRecognizer];
    
}


//*****************************************
//
  #pragma mark - EVENT HANDLING
//
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
    
    /*
     Create and configure the four recognizers. Add each to the view as a gesture recognizer.
     */
	
	/*
	UIGestureRecognizer *recognizer;
	*/
	 
    /*
     Create a tap recognizer and add it to the view.
     Keep a reference to the recognizer to test in gestureRecognizer:shouldReceiveTouch:.
     */
	
	
	tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[self.view addGestureRecognizer:tapRecognizer];
    //tapRecognizer = (UITapGestureRecognizer *)recognizer;
    //recognizer.delegate = self;
	//[recognizer release];
	
    
    /*
     Create a swipe gesture recognizer to recognize right swipes (the default).
     We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.
     */
	
	
	swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipeRightRecognizer];
	
	swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swipeLeftRecognizer];
	
	
    /*
     Create a swipe gesture recognizer to recognize left swipes.
     Keep a reference to the recognizer so that it can be added to and removed from the view in takeLeftSwipeRecognitionEnabledFrom:.
     Add the recognizer to the view if the segmented control shows that left swipe recognition is allowed.
     */
	
	/*
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    if ([segmentedControl selectedSegmentIndex] == 0) {
        [self.view addGestureRecognizer:swipeLeftRecognizer];
    }
    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
	[recognizer release];
	 */
    
    /*
     Create a rotation gesture recognizer.
     We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.
     */
	
	/*
	recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationFrom:)];
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	 */
    
    // For illustrative purposes, set exclusive touch for the segmented control (see the ReadMe).
    
	/*
	[segmentedControl setExclusiveTouch:YES];
    */
	 
    /*
     Create an image view to display the gesture description.
     */
	
	/*
    UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 75.0)];
    anImageView.contentMode = UIViewContentModeCenter;
    self.imageView = anImageView;
    [anImageView release];
    [self.view addSubview:imageView];
	 */
}


-(void)handleGesture: (UISwipeGestureRecognizer *)sender
{
	NSLog(@"handleGesture");
	//NSLog(sender.id);	
	
	if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
		NSLog(@"handleGesture Left");
    }
    else {
		NSLog(@"handleGesture Right");
    }
	
	
}

-(void)handleTap: (UIGestureRecognizer *)sender
{
	NSLog(@"handleTap");
	
}




//*****************************************
//
    #pragma - SWIPE GESTURE HANDLING
//
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

@end
