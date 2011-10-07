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

CGPoint startTouchPosition;

@implementation DefragViewController

@synthesize swipeRightRecognizer, swipeLeftRecognizer, swipeUpRecognizer, swipeDownRecognizer;
@synthesize tapRecognizer;

@synthesize contentDict;
@synthesize currentPageView;
//@synthesize navController;

@synthesize tableOfContentsView;

@synthesize moviePlayer;
//@synthesize startTouchPosition;

//Integers don't need to be dealloc'ed
@synthesize pageIndex, articleIndex, articleCount, pageCount;




//*****************************************
#pragma mark - VIEW DID LOAD
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");

    //NSLog(@"DefragViewController PARSE PLIST");
    contentDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"plist"]];
    
    articleCount = [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] count];
    
    articleIndex = 0;
    pageIndex = 0;
    [self calculatePageCount];
    [self setupGestureRecognizer];
    [self setNavigationBarHidden:YES];    
    [self turnPage:1];
    NSLog(@"PAGE IS COVER - INIT");
    
    [self createTableOfContents];

}

//*****************************************
#pragma mark - PAGE NAVIGATION
//*****************************************


- (void)handleGesture:(UISwipeGestureRecognizer *)sender {
    NSLog(@"***************************");
    NSLog(@"handleGesture");
    NSLog(@"***************************");
    
    char direction;
    
    
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"handleGesture Left");
            
            if (articleIndex >= (articleCount-1)) return;
            
            articleIndex = articleIndex + 1;
            pageIndex = 0;
            [self calculatePageCount];
            direction = 1;
            
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            // NSLog(@"handleGesture Right");
            
            if (articleIndex == 0) return;
            
            articleIndex = articleIndex - 1;
            pageIndex = 0;
            [self calculatePageCount];
            direction = 2;
            
            break;
            
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"handleGesture Up");
            
            NSLog(@"length: %i", [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] count] -1);
            
            
            if (pageIndex == (pageCount -1))
            {
                NSLog(@"LAST PAGE");
                return;
            }else{
                pageIndex = pageIndex + 1; 
            }
            
            ;
            direction = 3;
            
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"handleGesture Down");
            
            if (pageIndex == 0) return;
            pageIndex = pageIndex - 1;
            direction = 4;
            
            break;
            
        default:
            break;
    }
    
    NSLog(@"handleGesture sets articleIndex: %i pageIndex: %i", articleIndex, pageIndex);
    
    [self turnPage:direction];
}

-(void)calculatePageCount
{
    pageCount = [[[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Media"] count];
    NSLog(@"pageCount: %i", pageCount);
}


-(void)turnPage: (char)whichDirection
{
    NSLog(@"turnPage");
    
    currentPageView = [[PageViewController alloc] init];
    [currentPageView setPageDataWithDictionary:[self getMediaItem]];
        
    if ([[currentPageView getMediaType] isEqualToString:@"jpg"]){
        [self displayJPG:whichDirection];

    } else if ([[currentPageView getMediaType] isEqualToString:@"mov"]){
        [self displayMOV:whichDirection];
    }
    
   [self logPageInfo];

}





-(void)displayJPG:(int)whichDirection
{
    NSLog(@"MEDIA TYPE: JPG");
    
    UIImage *nextImage;
    UIView *nextView;
    UIViewController *nextController;
    
    nextImage = [UIImage imageNamed:[[self getMediaItem] objectForKey:@"Media"]];
    nextView = [[UIImageView alloc] initWithImage:nextImage];
    nextController = [[UIViewController alloc] init];
    nextController.view = nextView;
    
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    CALayer *layer;
    layer = nextController.view.layer;
    [transition setDuration:0.2f];

    
    switch (whichDirection)
    {
        case 1://left
            [transition setSubtype:kCATransitionFromRight];
            break;
        case 2://right
            [transition setSubtype:kCATransitionFromLeft];
            break;
        case 3://up
            [transition setSubtype:kCATransitionFromTop];
            break;
        case 4://down
            [transition setSubtype:kCATransitionFromBottom];
            break;
        default:
            [transition setSubtype:kCATransitionFromRight];
            
    }
    
    [layer addAnimation:transition forKey:@"Transition"];    
    
    [self pushViewController:nextController animated:NO];
    
    [nextView release];
    [nextImage release];
    [nextController release];

}


-(void)displayMOV:(int)whichDirection
{
    NSLog(@"MEDIA TYPE: MOV");
    NSLog(@"createMoviePlayer");
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] init];
    [player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: player.view];
    
    self.moviePlayer = player;
    [player release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    NSLog(@"initAndPlayMovie: %@", [[self getMediaItem] objectForKey:@"Media"]);
    
    NSString *rootPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [rootPath stringByAppendingPathComponent:[[self getMediaItem] objectForKey:@"Media"]];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    [self.moviePlayer setContentURL:fileURL];
    [self.moviePlayer play];
}





-(void)playerPlaybackDidFinish:(NSNotification *)notification
{
    NSLog(@"playerPlaybackDidFinish");

    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: moviePlayer];

    [moviePlayer.view removeFromSuperview];

    // Release the movie instance created in playMovieAtURL:
    [moviePlayer release];

}


//*****************************************
#pragma mark - SWIPE GESTURE HANDLING
//*****************************************


- (void)setupGestureRecognizer {

    //NSLog(@"setupGestureRecognizer NEW");

    swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];

    swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];

    swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpRecognizer];

    swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
}



//*****************************************
#pragma mark - TOUCH GESTURE HANDLING
//*****************************************


- (void)handleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"handleTap");
    
    //navController = [[PageNavController alloc] init];
    //[self pushViewController:navController animated:YES];
    
    [self displayTableOfContents];

}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*
    NSLog(@"touchesBegan");
    
    UITouch *touch = [touches anyObject];
    startTouchPosition = [touch locationInView:self.view];
    NSLog(@"CGPoint: %@", NSStringFromCGPoint(startTouchPosition));
     */
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*
    NSLog(@"touchesEnded");
    
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.view];
    NSLog(@"CGPoint: %@", NSStringFromCGPoint(currentTouchPosition));
    
    startTouchPosition = CGPointZero;
    
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            NSLog(@"A DOUBLE TAP OCCURRED");
            
        }
    }
     */
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.view];
    NSLog(@"CGPoint: %@", NSStringFromCGPoint(currentTouchPosition));
    */
    
    /*
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
     */
    
    //[touch release];
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
          
    startTouchPosition = CGPointZero;
}



//*****************************************
#pragma mark - TABLE OF CONTENTS
//*****************************************


-(void)createTableOfContents{
    tableOfContentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, 250.0f, 768.0f)];
    tableOfContentsView.backgroundColor = [UIColor orangeColor];
       
    //[self.view insertSubview:tableOfContentsView atIndex:0];
}


- (void)displayTableOfContents
{
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    CALayer *layer;
    layer = tableOfContentsView.layer;
    [transition setDuration:0.2f];
    [transition setSubtype:kCATransitionFromLeft];    
    [layer addAnimation:transition forKey:@"Transition"];  
    
    [self.view addSubview:tableOfContentsView];
    [UIView commitAnimations];
    
}

//*****************************************
#pragma mark - UTILITIES
//*****************************************



- (void)logPageInfo {
    //NSLog(@"Title: %@ Page: %i", [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Title"], pageIndex);
    
    NSLog(@"logPageInfo");
    NSLog(@"    mediaType:, %@", [currentPageView getMediaType]);
    NSLog(@"    mediaPath:, %@", [currentPageView getMediaPath]);
    
}


- (NSDictionary *)getMediaItem {
    NSLog(@"getMediaItem: ");
    //NSLog(@"    articleIndex: %i pageIndex: %i", articleIndex, pageIndex);
    
    return [[[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Media"] objectAtIndex:pageIndex];
}



//*****************************************
#pragma mark - MEMORY CLEANUP
//*****************************************

- (void)dealloc {
    [swipeRightRecognizer release];
    [swipeLeftRecognizer release];
    [swipeUpRecognizer release];
    [swipeDownRecognizer release];
    
    [moviePlayer release];
    [contentDict release];
    [currentPageView release];
    
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

@end
