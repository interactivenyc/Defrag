//
//  DefragViewController.h
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DefragViewController : UINavigationController <UIGestureRecognizerDelegate, NSXMLParserDelegate>
{	    
	UISwipeGestureRecognizer *swipeRightRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;   
    int pageIndex;
    NSDictionary *contentDict;
    NSMutableData *contentData;
}


//*********************************************************
	#pragma mark - INTERNAL PROPERTIES AND METHODS
//*********************************************************

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property int pageIndex;
@property (nonatomic, retain) NSDictionary *contentDict;
@property (nonatomic, retain) NSMutableData *contentData;

-(void)setupGestureRecognizer;
-(void)handleGesture: (UIGestureRecognizer *)sender;

@end
