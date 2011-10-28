//
//  DefragAppDelegate.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/CoreAnimation.h>

#define AppDelegate (DefragAppDelegate *)[[UIApplication sharedApplication] delegate]

@class DefragViewController;

@interface DefragAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DefragViewController *viewController;

@end

