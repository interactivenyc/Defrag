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

#import "FBConnect.h"
#import "DataSet.h"

#define AppDelegate (DefragAppDelegate *)[[UIApplication sharedApplication] delegate]

@class DefragViewController;

@interface DefragAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    Facebook *facebook;
    DataSet *apiData;
    NSMutableDictionary *userPermissions;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DefragViewController *viewController;

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) DataSet *apiData;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;

@end

