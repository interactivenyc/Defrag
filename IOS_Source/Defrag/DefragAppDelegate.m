//
//  DefragAppDelegate.m
//  Defrag
//
//  Created by swarren
//

#import "DefragAppDelegate.h"
#import "DefragViewController.h"
#import "Utils.h"

//NSString *kScalingModeKey	= @"scalingMode";
//NSString *kControlModeKey	= @"controlMode";
//NSString *kBackgroundColorKey	= @"backgroundColor";

@implementation DefragAppDelegate

@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize moviePlayer;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSLog(@"DefragAppDelegate didFinishLaunchingWithOptions");
    
    [Utils test];
         
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
    
    
}

-(void)createMoviePlayer
{
    NSLog(@"createMoviePlayer");
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] init];
    [player.view setFrame: _viewController.view.bounds];  // player's frame must match parent's
	[_viewController.view addSubview: player.view];
    
    self.moviePlayer = player;
    [player release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
}

-(void)initAndPlayMovie:(NSString *)filename
{
    NSLog(@"initAndPlayMovie");
    
    NSString *rootPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [rootPath stringByAppendingPathComponent:filename];
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
    
    // Release the movie instance created in playMovieAtURL:
    [moviePlayer release];
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end