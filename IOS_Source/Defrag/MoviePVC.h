//
//  MoviePVC.h
//  Defrag
//
//  Created by Steve Warren on 10/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "PageViewController.h"

@interface MoviePVC : PageViewController
{
    MPMoviePlayerViewController *moviePlayerViewController;
    MPMoviePlayerController *mpc;
}

@property (nonatomic, retain) MPMoviePlayerViewController *moviePlayerViewController;
@property (nonatomic, retain) MPMoviePlayerController *mpc;

-(void)displayPage;

@end
