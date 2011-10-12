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

@synthesize swipeRightRecognizer, swipeLeftRecognizer, swipeUpRecognizer, swipeDownRecognizer;
@synthesize tapRecognizer;

@synthesize currentPageView;
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
    NSLog(@"PAGE IS COVER - INIT");
    
    //NSLog(@"DefragViewController PARSE PLIST");
    contentDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"plist"]];
    
    articleCount = [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] count];
    
    articleIndex = 0;
    pageIndex = 0;
    
    [self calculatePageCount];
    [self setupGestureRecognizers];
    
    [self setNavigationBarHidden:YES];    
    
    [self createPage];
    [self displayPage:1];
    
    //[self createTableOfContents];
    
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
    NSLog(@"***************************");
    NSLog(@"handleGesture");
    NSLog(@"***************************");
    
    char direction;
    
    
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"handleGesture Left");
            
            if (articleIndex >= (articleCount-1)) return;
            
            articleIndex = articleIndex + 1;
            pageIndex = 0;
            [self calculatePageCount];
            direction = 1;
            
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            // NSLog(@"handleGesture Right");
            
            if (articleIndex == 0) return;
            
            articleIndex = articleIndex - 1;
            pageIndex = 0;
            [self calculatePageCount];
            direction = 2;
            
            break;
            
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"handleGesture Up");
            
            NSLog(@"length: %i", [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] count] -1);
            
            
            if (pageIndex == (pageCount -1))
            {
                NSLog(@"LAST PAGE");
                return;
            }else{
                pageIndex = pageIndex + 1; 
            }
            
            ;
            direction = 3;
            
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"handleGesture Down");
            
            if (pageIndex == 0) return;
            pageIndex = pageIndex - 1;
            direction = 4;
            
            break;
            
        default:
            break;
    }
    
    NSLog(@"handleGesture sets articleIndex: %i pageIndex: %i", articleIndex, pageIndex);
    
    [self createPage];
    [self displayPage:direction];
}




- (void)handleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"handleTap");
    
    
    [self displayTableOfContents];
    
}




//*****************************************
#pragma mark - PAGE NAVIGATION
//*****************************************


-(void)createPage
{
    NSLog(@"createPage");
    
    //NSDictionary *pageDictionary = [self getMediaItem];
    
   // NSLog(@"initWithDictionary: %@", pageDictionary);
    
    
    //*****************************************
    #pragma mark - THIS IS WHERE WE'RE CURRENTLY BREAKING
    //*****************************************
    
    //PageData *pageData = [[PageData alloc] init ];
                           
                           //]initWithDictionary:[self getMediaItem]];
    
    PageData *pageData = [[PageData alloc] init ];
    pageData.pageDictionary = [self getMediaItem];
    
                           
                           
    NSString *mediaType = [pageData getMediaType];
    NSLog(@"mediaType: %@", mediaType);
    
    if ([mediaType isEqualToString:@"jpg"]){
        currentPageView = [[ImagePVC alloc] init ];
    }else if ([mediaType isEqualToString:@"mov"]){
        currentPageView = [[MoviePVC alloc] init ];
        
    }
    
    NSLog(@"page allocated: %@", currentPageView);
    
    [currentPageView initWithPageData:pageData];
    [currentPageView displayPage];
    
    
    /*
     if ([[currentPageView getMediaType] isEqualToString:@"jpg"]){
     [self displayJPG:whichDirection];
     
     } else if ([[currentPageView getMediaType] isEqualToString:@"mov"]){
     [self displayMOV:whichDirection];
     }
     */
    
    
    [pageData release];
    [mediaType release];
    //[pageDictionary release];
    
    
}





-(void)displayPage:(int)direction
{
    NSLog(@"displayPage");
    
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
    [self pushViewController:currentPageView animated:NO];
    
}





//*****************************************
#pragma mark - TABLE OF CONTENTS / ARTICLE NAVIGATION
//*****************************************


-(void)createTableOfContents{
    NSLog(@"createTableOfContents");
    tableOfContentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, 250.0f, 250.0f)];
    tableOfContentsView.backgroundColor = [UIColor orangeColor];
    
    tableOfContentsViewController = [[UIViewController alloc] init];
    tableOfContentsViewController.view = tableOfContentsView;
    
    popoverViewController = [[UIPopoverController alloc] initWithContentViewController:tableOfContentsViewController];
    
}


- (void)displayTableOfContents{
    NSLog(@"displayTableOfContents");
    
    
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
    
    NSLog(@"logPageInfo");
    NSLog(@"    mediaType:, %@", [currentPageView.pageData getMediaType]);
    NSLog(@"    mediaPath:, %@", [currentPageView.pageData getMediaPath]);
    
}


-(void)calculatePageCount
{
    pageCount = [[[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Media"] count];
    NSLog(@"pageCount: %i", pageCount);
}


- (NSDictionary *)getMediaItem {
    NSLog(@"getMediaItem: ");
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
    return YES;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
