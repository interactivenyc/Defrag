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
@synthesize moviePlayerController;
@synthesize tapRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc {
    [moviePlayerViewController dealloc];    
    [super dealloc];
}


-(void)pageWillDisplay
{
    //[super displayPage];
    NSLog(@"MoviePVC displayPage");
    NSLog(@"MoviePVC MEDIA TYPE: MOV");
    
    NSString *rootPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [rootPath stringByAppendingPathComponent: [pageData getMediaPath]];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    
    [self setupGestureRecognizers];
    
    
    //trying to restrict orientation of moviePlayer
        /*
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            [moviePlayerViewController shouldAutorotateToInterfaceOrientation:YES];
        }else{
            [moviePlayerViewController shouldAutorotateToInterfaceOrientation:NO];
        }
         */
    
    //
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerViewController.moviePlayer];
    
}



/*-(void)displayMOV:(int)whichDirection
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
 */

-(void)pageDidDisplay
{
    moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
    [moviePlayerController setFullscreen:YES];
    [moviePlayerController setControlStyle:MPMovieControlStyleFullscreen];
    
    [moviePlayerController.view setFrame: self.view.bounds];
    [self.view addSubview:moviePlayerController.view];
    [moviePlayerController play];
}



-(void)playerPlaybackDidFinish:(NSNotification *)notification
{
    NSLog(@"MoviePVC playerPlaybackDidFinish");

    [[NSNotificationCenter defaultCenter]
        removeObserver: self
        name: MPMoviePlayerPlaybackDidFinishNotification
        object: moviePlayerViewController];
    
}


//GESTURE SUPPORT
-(void)setupGestureRecognizers
{
    NSLog(@"MoviePVC setupGestureRecognizers");
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [moviePlayerViewController.moviePlayer.view addGestureRecognizer:tapRecognizer];
}


-(void)handleGesture: (UIGestureRecognizer *)sender
{
    NSLog(@"***************************");
    NSLog(@"handleGesture");
    NSLog(@"***************************");
    
}
-(void)handleTap: (UITapGestureRecognizer *)sender
{
    NSLog(@"***************************");
    NSLog(@"MoviePVC handleTap");
    NSLog(@"***************************");
    
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
