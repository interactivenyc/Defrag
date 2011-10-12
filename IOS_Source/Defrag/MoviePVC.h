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
    MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

-(void)displayPage;

@end
