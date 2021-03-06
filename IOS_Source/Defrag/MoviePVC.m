//
//  MoviePVC.m
//  Defrag
//
//  Created by Steve Warren on 10/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "MoviePVC.h"
#import "DefragAppDelegate.h"

@implementation MoviePVC

@synthesize moviePlayerViewController;
@synthesize swipeLeftRecognizer, swipeRightRecognizer, swipeUpRecognizer, swipeDownRecognizer;
@synthesize tapRecognizer;
@synthesize fileURL, moviePlayer, movieFinished;


-(void)dealloc
{
    [super dealloc];
    NSLog(@"MoviePVC dealloc");
    
    moviePlayerViewController = nil;
    [moviePlayerViewController dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





-(void)pageWillDisplay
{
    [super pageWillDisplay];
    
    //[super displayPage];
    NSLog(@"MoviePVC pageWillDisplay");
    //NSLog(@"MoviePVC MEDIA TYPE: MOV");
    
    movieFinished = FALSE;
    
    NSString *rootPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [rootPath stringByAppendingPathComponent: [pageData getMediaPath]];
    fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    NSLog(@"MoviePVC MPMoviePlayerViewController alloc");
    moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerViewController.moviePlayer];
    
}

-(void)pageDidDisplay
{
    [super pageDidDisplay];
    
    NSLog(@"MoviePVC pageDidDisplay");

    [[moviePlayerViewController view] setFrame:[self.view bounds]]; // size to fit parent view exactly    
    self.view = moviePlayerViewController.moviePlayer.view;
    
    moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [moviePlayerViewController.moviePlayer setFullscreen:YES];
    [moviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleNone];    
    [moviePlayerViewController.moviePlayer play];
    
    [self setupGestureRecognizers];
}

-(void)playerPlaybackDidFinish:(NSNotification *)notification
{
    NSLog(@"MoviePVC playerPlaybackDidFinish");
    movieFinished = TRUE;

}


//GESTURE SUPPORT
-(void)setupGestureRecognizers
{
    //NSLog(@"MoviePVC setupGestureRecognizers");
    
    UIView *gestureCaptureView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, 1024.0f, 768.0f)];
    [self.view addSubview:gestureCaptureView];
    
    swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [gestureCaptureView addGestureRecognizer:swipeRightRecognizer];
    
    swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [gestureCaptureView addGestureRecognizer:swipeLeftRecognizer];
    
    swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [gestureCaptureView addGestureRecognizer:swipeUpRecognizer];
    
    swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [gestureCaptureView addGestureRecognizer:swipeDownRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [gestureCaptureView addGestureRecognizer:tapRecognizer];
    
    [gestureCaptureView release];
}


-(void)handleGesture: (UISwipeGestureRecognizer *)sender
{
    NSLog(@"MoviePVC ***************************");
    
    
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"MoviePVC handleGesture Left");
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"MoviePVC handleGesture Right");
            break;
            
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"MoviePVC handleGesture Up");
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"MoviePVC handleGesture Down");
            break;
            
        default:
            break;
    }
    
    NSLog(@"MoviePVC ***************************");
    
    [self stopPlaying];
    [self performSelector:@selector(sendGesture:) withObject:sender afterDelay:.5];
        
}

-(void)sendGesture: (UISwipeGestureRecognizer *)sender{
    [[AppDelegate viewController] handleGesture:sender];
}
    
    
-(void)handleTap: (UITapGestureRecognizer *)sender
{
    NSLog(@"***************************");
    NSLog(@"MoviePVC handleTap:%@", moviePlayerViewController.moviePlayer);
    NSLog(@"***************************");
    
    if (movieFinished) {
        [[AppDelegate viewController] handleTap:sender];
    }else{
        if (moviePlayerViewController.moviePlayer.playbackState == MPMoviePlaybackStatePlaying){
            [moviePlayerViewController.moviePlayer pause];
        }else if (moviePlayerViewController.moviePlayer.playbackState == MPMoviePlaybackStatePaused){
            [moviePlayerViewController.moviePlayer play];
        } 
    }
    
}


-(void)stopPlaying{
    [moviePlayerViewController.moviePlayer stop];

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
    [super loadView];
    //NSLog(@"MoviePVC loadView");
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"MoviePVC viewDidUnload");

    
    //[mpc dealloc];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
