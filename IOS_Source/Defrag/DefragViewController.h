//
//  DefragViewController.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DefragViewController : UIViewController <UIGestureRecognizerDelegate>{
    
    UIButton *defragButton;    
    UILabel *headerText;
    NSURL *movieURL; 
    
    UITapGestureRecognizer *tapRecognizer;
	UISwipeGestureRecognizer *swipeRightRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;
	
	//UIViewController *contentContainer;
    
    CGPoint *startTouchPosition;
    
}

@property (nonatomic, retain) IBOutlet UIButton *defragButton;
@property (nonatomic, retain) IBOutlet UILabel *headerText;
@property (nonatomic, retain) NSURL *movieURL;

-(IBAction)defragButtonClicked:(id)sender;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;

//@property (nonatomic, retain) UIViewController *contentContainer;

//@property (nonatomic, retain) CGPoint *startTouchPosition;

-(void)setupGestureRecognizer;
-(void)handleGesture: (UIGestureRecognizer *)sender;
-(void)handleTap: (UIGestureRecognizer *)sender;

@end
