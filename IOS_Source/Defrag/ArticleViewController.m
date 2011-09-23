//
//  ArticleViewController.m
//  Defrag
//
//  Created by Steve Warren on 9/14/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "ArticleViewController.h"

@implementation ArticleViewController

@synthesize articleWebView;
@synthesize articleURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     NSLog(@"ArticleViewController initWithNibName");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	self.articleWebView.delegate = self;	// setup the delegate as the web view is shown
}


- (void)viewDidLoad
{
    NSLog(@"ArticleViewController viewDidLoad articleURL: %@", articleURL);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	self.articleWebView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
	self.articleWebView.backgroundColor = [UIColor greenColor];
	self.articleWebView.scalesPageToFit = YES;
	//self.articleWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.articleWebView.delegate = self;
	[self.view addSubview: self.articleWebView];
    
    NSLog(@"articleWebView.loading: %@", articleWebView);
    [self.articleWebView loadRequest:[NSURLRequest requestWithURL:articleURL]];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.articleWebView stopLoading];	// in case the web view is still loading its content
	self.articleWebView.delegate = nil;	// disconnect the delegate as the webview is hidden
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"ArticleViewController webViewDidStartLoad: %@", articleURL);
    
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"ArticleViewController webViewDidFinishLoad");
    
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"ArticleViewController didFailLoadWithError: %@", error);
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

@end




