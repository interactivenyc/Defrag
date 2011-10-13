//
//  MoviePVC.m
//  Defrag
//
//  Created by Steve Warren on 10/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "MoviePVC.h"

@implementation MoviePVC

@synthesize moviePlayerViewController;
//@synthesize mpc;

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


-(void)displayPage
{
    [super displayPage];
    NSLog(@"MoviePVC displayPage");
    NSLog(@"MoviePVC MEDIA TYPE: MOV");
    
    NSString *rootPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [rootPath stringByAppendingPathComponent: [pageData getMediaPath]];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    self.moviePlayerViewController = [[[MPMoviePlayerViewController alloc] initWithContentURL:fileURL] autorelease];
    
    [self.view setBackgroundColor:[UIColor redColor]];
    
    [[moviePlayerViewController view] setFrame:[self.view bounds]]; // size to fit parent view exactly    
    
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
    
    moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [moviePlayerViewController.moviePlayer setFullscreen:YES];
    [moviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    [moviePlayerViewController.moviePlayer play];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerViewController];
    
    // [rootPath release];
    // [filePath release];
    // [fileURL release];
    
}

-(void)playerPlaybackDidFinish:(NSNotification *)notification
{
    NSLog(@"MoviePVC playerPlaybackDidFinish");

    [[NSNotificationCenter defaultCenter]
    removeObserver: self
    name: MPMoviePlayerPlaybackDidFinishNotification
    object: moviePlayerViewController];
    
    [moviePlayerViewController.view removeFromSuperview];
    [moviePlayerViewController release];
    
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
