//
//  FirstViewController.h
//  Defrag
//
//  Created by Steve Warren on 9/8/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

    //*********************************************************
    #pragma mark - INTERFACE BUILDER PROPERTIES
    //*********************************************************

    UIButton *defragButton;    
    UILabel *headerText;

    //*********************************************************
    #pragma mark - INTERNAL PROPERTIES
    //*********************************************************

    NSURL *movieURL; 

    //*********************************************************
    #pragma mark - INTERFACE BUILDER PROPERTIES AND METHODS
    //*********************************************************


    @property (nonatomic, retain) IBOutlet UIButton *defragButton;
    @property (nonatomic, retain) IBOutlet UILabel *headerText;
    @property (nonatomic, retain) NSURL *movieURL;

    -(IBAction)defragButtonClicked:(id)sender;

@end
