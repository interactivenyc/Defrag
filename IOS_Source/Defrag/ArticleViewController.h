//
//  ArticleViewController.h
//  Defrag
//
//  Created by Steve Warren on 9/14/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController <UIWebViewDelegate> {
    
    UIWebView *articleWebView;
    NSURL *articleURL;
    
}

@property (nonatomic, retain) UIWebView *articleWebView;
@property (nonatomic, retain) NSURL *articleURL;


@end
