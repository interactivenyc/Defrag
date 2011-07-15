//
//  DefragViewController.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DefragViewController : UIViewController <UIGestureRecognizerDelegate>{
    
	
	//*********************************************************
		#pragma mark - INTERFACE BUILDER PROPERTIES
	//*********************************************************
	
    UIButton *defragButton;    
    UILabel *headerText;
	
	//*********************************************************
		#pragma mark - INTERNAL PROPERTIES
	//*********************************************************
	
    NSURL *movieURL; 
    
	UISwipeGestureRecognizer *swipeRightRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;
	
    
}

//*********************************************************
	#pragma mark - INTERFACE BUILDER PROPERTIES AND METHODS
//*********************************************************


@property (nonatomic, retain) IBOutlet UIButton *defragButton;
@property (nonatomic, retain) IBOutlet UILabel *headerText;

-(IBAction)defragButtonClicked:(id)sender;


//*********************************************************
	#pragma mark - INTERNAL PROPERTIES AND METHODS
//*********************************************************

@property (nonatomic, retain) NSURL *movieURL;

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;


-(void)setupGestureRecognizer;
-(void)handleGesture: (UIGestureRecognizer *)sender;


@end
