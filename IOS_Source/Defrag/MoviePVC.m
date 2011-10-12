//
//  MoviePVC.m
//  Defrag
//
//  Created by Steve Warren on 10/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "MoviePVC.h"

@implementation MoviePVC

@synthesize moviePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)displayPage
{
    [super displayPage];
     NSLog(@"MoviePVC displayPage");
    //THIS METHOD MUST BE OVERRIDEN IN IMPLEMENTATION CLASSES
    NSLog(@"MEDIA TYPE: MOV");
    NSLog(@"createMoviePlayer");
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] init];
    [player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: player.view];
    
    self.moviePlayer = player;
    [player release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    NSLog(@"initAndPlayMovie: %@", [pageData getMediaPath]);
    
    NSString *rootPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [rootPath stringByAppendingPathComponent: [pageData getMediaPath]];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    [self.moviePlayer setContentURL:fileURL];
    [self.moviePlayer play];
    
    [rootPath release];
    [filePath release];
    [fileURL release];

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
    NSLog(@"MoviePVC loadView");
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
    
    [moviePlayer dealloc];
        
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
