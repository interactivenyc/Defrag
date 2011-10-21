//
//  DefragViewController.m
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "DefragViewController.h"

@implementation DefragViewController

//Integers don't need to be dealloc'ed
@synthesize pageIndex, articleIndex, articleCount, pageCount;
@synthesize direction;

@synthesize swipeRightRecognizer, swipeLeftRecognizer, swipeUpRecognizer, swipeDownRecognizer;
@synthesize tapRecognizer;

@synthesize currentPageView;
@synthesize moviePlayerViewController;
@synthesize contentDict;

@synthesize popoverViewController;
@synthesize tableOfContentsViewController;
@synthesize tableOfContentsView;


//*****************************************
#pragma mark - DEALLOC
//*****************************************

- (void)dealloc {
    [swipeRightRecognizer release];
    [swipeLeftRecognizer release];
    [swipeUpRecognizer release];
    [swipeDownRecognizer release];
    [tapRecognizer release];
    
    [contentDict release];
    [currentPageView release];
    
    [popoverViewController release];
    [tableOfContentsView release];
    [tableOfContentsViewController release];
    
    [super dealloc];
}

//*****************************************
#pragma mark - VIEW DID LOAD
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");
    NSLog(@"DVC PAGE IS COVER - INIT");
    
    //NSLog(@"DefragViewController PARSE PLIST");
    contentDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"plist"]];
    
    articleCount = [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] count];
    
    articleIndex = 0;
    pageIndex = 0;
    direction = 1;
    
    [self calculatePageCount];
    [self setupGestureRecognizers];
    
    [self setNavigationBarHidden:YES];    
    
    [self createPage];
    
    
}


//*****************************************
#pragma mark - GESTURE SUPPORT
//*****************************************


- (void)setupGestureRecognizers {
    
    //NSLog(@"setupGestureRecognizer NEW");
    
    swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpRecognizer];
    
    swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
}


- (void)handleGesture:(UISwipeGestureRecognizer *)sender {
    NSLog(@"DVC ***************************");
    NSLog(@"DVC handleGesture");
    NSLog(@"DVC ***************************");
    
    
    //articleIndex and pageIndex get set in this routine, then the new page is created
    
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"DVC handleGesture Left");
            
            if (articleIndex >= (articleCount-1)) return;
            
            articleIndex = articleIndex + 1;
            pageIndex = 0;
            [self calculatePageCount];
            direction = 1;
            
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"DVC handleGesture Right");
            
            if (articleIndex == 0) return;
            
            articleIndex = articleIndex - 1;
            pageIndex = 0;
            [self calculatePageCount];
            direction = 2;
            
            break;
            
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"DVC handleGesture Up");
            
            if (pageIndex == (pageCount -1))
            {
                NSLog(@"DVC LAST PAGE");
                return;
            }else{
                pageIndex = pageIndex + 1; 
            }
            
            direction = 3;
            
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"DVC handleGesture Down");
            
            if (pageIndex == 0) return;
            pageIndex = pageIndex - 1;
            direction = 4;
            
            break;
            
        default:
            break;
    }
    
    [self createPage];

}


- (void)handleTap:(UITapGestureRecognizer *)sender 
{
    NSLog(@"DVC handleTap");
    [self displayTableOfContents];
}




//*****************************************
#pragma mark - PAGE NAVIGATION
//*****************************************


-(void)createPage
{
    NSLog(@"DVC createPage");
    
    PageData *pageData = [[PageData alloc] init ];
    pageData.pageDictionary = [self getMediaItem];
                           
    NSString *mediaType = [pageData getMediaType];
    NSLog(@"DVC mediaType: %@", mediaType);
    
    if ([mediaType isEqualToString:@"jpg"]){
        currentPageView = [[ImagePVC alloc] init ];
    }else if ([mediaType isEqualToString:@"mov"]){
        currentPageView = [[MoviePVC alloc] init ];
    }
    
    [currentPageView initWithPageData:pageData];
    [currentPageView pageWillDisplay];
    [self displayPage];
    [currentPageView pageDidDisplay];
    
    [pageData release];
}





-(void)displayPage
{
    NSLog(@"DVC displayPage");
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    CALayer *layer;
    layer = currentPageView.view.layer;
    [transition setDuration:0.2f];
    
    switch (direction)
    {
        case 1://left
            [transition setSubtype:kCATransitionFromRight];
            break;
        case 2://right
            [transition setSubtype:kCATransitionFromLeft];
            break;
        case 3://up
            [transition setSubtype:kCATransitionFromTop];
            break;
        case 4://down
            [transition setSubtype:kCATransitionFromBottom];
            break;
        default:
            [transition setSubtype:kCATransitionFromRight];
    }
    
    [layer addAnimation:transition forKey:@"Transition"];  
    
    //handle cleanup of page controllers
    NSLog(@"DVC pushViewController [STOP PUSHING VIEWCONTROLLERS - MANAGE WITH AN ARRAY]");
    
    [self pushViewController:currentPageView animated:NO];
    //[self.view addSubview:currentPageView.view];
    //currentPageView.view.userInteractionEnabled = NO;
    
}





//*****************************************
#pragma mark - TABLE OF CONTENTS / ARTICLE NAVIGATION
//*****************************************


-(void)createTableOfContents{
    NSLog(@"DVC createTableOfContents");
    tableOfContentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, 250.0f, 250.0f)];
    tableOfContentsView.backgroundColor = [UIColor orangeColor];
    
    tableOfContentsViewController = [[UIViewController alloc] init];
    tableOfContentsViewController.view = tableOfContentsView;
    
    popoverViewController = [[UIPopoverController alloc] initWithContentViewController:tableOfContentsViewController];
    
}


- (void)displayTableOfContents{
    NSLog(@"DVC displayTableOfContents");
    
    if (popoverViewController != nil) {
        [popoverViewController dismissPopoverAnimated:YES];
    }
    
    [popoverViewController presentPopoverFromRect:CGRectMake(0.0f, 0.0, 250.0f, 768.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

//*****************************************
#pragma mark - UTILITIES
//*****************************************



- (void)logPageInfo {
    //NSLog(@"Title: %@ Page: %i", [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Title"], pageIndex);
    
    NSLog(@"DVC logPageInfo");
    NSLog(@"DVC     mediaType:, %@", [currentPageView.pageData getMediaType]);
    NSLog(@"DVC     mediaPath:, %@", [currentPageView.pageData getMediaPath]);
    
}


-(void)calculatePageCount
{
    pageCount = [[[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Media"] count];
    NSLog(@"DVC pageCount: %i", pageCount);
}


- (NSDictionary *)getMediaItem {
    NSLog(@"DVC getMediaItem: ");
    //NSLog(@"    articleIndex: %i pageIndex: %i", articleIndex, pageIndex);
    //NSLog(@"debug:  %@", [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex]);
    
    
    return [[[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Media"] objectAtIndex:pageIndex];
}



//*****************************************
#pragma mark - MEMORY CLEANUP
//*****************************************



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    // Only support Landscape Orientations
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)didReceiveMemoryWarning {
    NSLog(@"DVC didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
