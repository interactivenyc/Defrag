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

@synthesize swipeRightRecognizer, swipeLeftRecognizer, swipeUpRecognizer, swipeDownRecognizer;

@synthesize contentDict;
@synthesize currentPageView;
@synthesize moviePlayer;

//Integers don't need to be dealloc'ed
@synthesize pageIndex, articleIndex, articleCount, pageCount;


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

//*****************************************
#pragma mark - VIEW DID LOAD
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");

    //NSLog(@"DefragViewController PARSE PLIST");
    contentDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"plist"]];

    articleCount = 8;
    articleIndex = 0;
    pageIndex = 0;
    [self calculatePageCount];
    [self setupGestureRecognizer];
    [self setNavigationBarHidden:YES];    
    [self turnPage:1];
    NSLog(@"PAGE IS COVER - INIT");

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
            // NSLog(@"handleGesture Left");
            if (articleIndex > (articleCount-1)) return;
            
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
    
    [transition setDuration:0.2f];
    
    CALayer *layer;
    layer = nextController.view.layer;
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
}







//*****************************************
#pragma mark - MEMORY CLEANUP
//*****************************************



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
