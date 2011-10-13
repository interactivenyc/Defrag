//
//  Utils.h
//  Defrag
//
//  Created by swarren on 7/9/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utils : NSObject {
@private
    
}

+ (void)test;

+ (void)log;

@end


//*****************************************
#pragma mark - CODE SNIPPETS REFERENCE
//*****************************************


/*
 
 
 ADD EVENT LISTENER FOR VIDEO PLAYER
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
 
 - (void) playerPlaybackDidFinish:(NSNotification*)notification
 {
 NSLog(@"WHY?");
 self.player.fullscreen = NO;
 }
 
 
 
 
 */