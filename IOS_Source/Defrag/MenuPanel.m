//
//  MenuPanel.m
//  Defrag
//
//  Created by Steve Warren on 11/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "MenuPanel.h"

@implementation MenuPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)createMenuPanel{
    NSLog(@"TOC createMenuPanel");
    
    UIButton *bg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 48)];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = .50;
    
    [self addSubview:bg];
    
}


@end
