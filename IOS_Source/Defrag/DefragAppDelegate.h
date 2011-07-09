//
//  DefragAppDelegate.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DefragViewController.h"

@class DefragViewController;

@interface DefragAppDelegate : NSObject <UIApplicationDelegate> {
    
    MPMoviePlayerController *moviePlayer;
    
}

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DefragViewController *viewController;

-(void)initAndPlayMovie:(NSString *)filename;

@end
