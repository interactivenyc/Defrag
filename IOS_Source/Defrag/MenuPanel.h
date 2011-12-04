//
//  MenuPanel.h
//  Defrag
//
//  Created by Steve Warren on 11/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>

//extern NSString *BUTTON_CLICKED;

@interface MenuPanel : UIView{
   // NSDictionary *buttonDict;
    UIToolbar *toolbar;
}

@property(nonatomic, retain) UIToolbar *toolbar;

-(void)createMenuPanel;

- (void)createToolbarItems;


-(void)addButton:(NSString *)imageName xPos:(int)xPos yPos:(int)yPos;
-(void)buttonClicked:(UITapGestureRecognizer *)sender;

@end
