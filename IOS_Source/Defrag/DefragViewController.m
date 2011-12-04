//
//  DefragViewController.m
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "DefragViewController.h"
#import "TableOfContents.h"
#import "Utils.h"

NSString *BUTTON_HOME = @"BUTTON_HOME";



@implementation DefragViewController

//Integers don't need to be dealloc'ed
@synthesize pageIndex, articleIndex, articleCount, pageCount;
@synthesize direction;

@synthesize currentPageViewController;
@synthesize contentDict;

@synthesize tableOfContentsView, menuPanel;

int TOC_WIDTH = 332;
int TOC_HEIGHT = 758;


//*****************************************
#pragma mark - DEALLOC
//*****************************************

- (void)dealloc {
    
    [contentDict release];
    [currentPageViewController release];
    
    [tableOfContentsView release];
    
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
    
    //ADD EVENT LISTENERS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:BUTTON_HOME object:nil];
    
     
    
}


//*****************************************
#pragma mark - GESTURE SUPPORT
//*****************************************


- (void)setupGestureRecognizers {
    
    //NSLog(@"setupGestureRecognizer NEW");
    
    UISwipeGestureRecognizer *swipeRecognizer;
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];
    
    UITapGestureRecognizer *tapRecognizer;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
}


- (void)handleGesture:(UISwipeGestureRecognizer *)sender {
    NSLog(@"DVC ***************************");
    NSLog(@"DVC handleGesture sender.direction:%i", sender.direction);
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
            NSLog(@"DVC handleGesture NOT BEING IDENTIFIED CORRECTLY");
            break;
    }
    
    [self createPage];

}


- (void)handleTap:(UITapGestureRecognizer *)sender 
{
    NSLog(@"DVC handleTap");
    [self displayMenuPanel];
    
}




//*****************************************
#pragma mark - PAGE NAVIGATION
//*****************************************

-(void)setArticleByIndex:(int)newIndex
{
    NSLog(@"DVC setArticleByIndex:%i",newIndex);
    
    direction = 1;
    pageIndex = 0;
    articleIndex = newIndex;
    [self calculatePageCount];
    [self createPage];
    [self displayTableOfContents];
}

-(void)createPage
{
    NSLog(@"DVC createPage");
    
    PageData *pageData = [[PageData alloc] init ];
    pageData.pageDictionary = [self getMediaItem];
    
    NSString *mediaType = [pageData getMediaType];
    NSLog(@"DVC mediaType: %@", mediaType);
    
    if ([mediaType isEqualToString:@"jpg"]){
        currentPageViewController = [[ImagePVC alloc] init ];
    }else if ([mediaType isEqualToString:@"mov"]){
        currentPageViewController = [[MoviePVC alloc] init ];
    }
    
    [currentPageViewController initWithPageData:pageData];
    [currentPageViewController pageWillDisplay];
    [self displayPage];
    [currentPageViewController pageDidDisplay];
    
    [pageData release];
}







-(void)displayPage
{
    NSLog(@"DVC displayPage");
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    CALayer *layer;
    layer = currentPageViewController.view.layer;
    [transition setDuration:0.2f];
    
    transition.delegate = self;
    
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

    [self pushViewController:currentPageViewController animated:NO];
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSLog(@"DVC animationDidStop");
    
    [self pageHasDisplayed];
}


-(void)pageHasDisplayed
{
    int numControllers = [self.viewControllers count];
    NSLog(@"numViewControllers:%i", numControllers);
    
    PageViewController *pageInstance;
    //PageData *pageData;
    for (int i=0; i<numControllers-1; i++) {
        NSLog(@"i:%i", i);
        pageInstance = (PageViewController *)[self.viewControllers objectAtIndex:i];
        //pageData = pageInstance.pageData;
        [pageInstance logLifetime];
        
        [pageInstance removeFromParentViewController];
    }
    
    numControllers = [self.viewControllers count];
    NSLog(@"numViewControllers after release:%i", numControllers);
}


//*****************************************
#pragma mark - TABLE OF CONTENTS / ARTICLE NAVIGATION
//*****************************************


- (void)displayTableOfContents{
    
    if (!tableOfContentsView)
    {
        NSLog(@"DVC displayTableOfContents");
        
        tableOfContentsView = [[TableOfContents alloc] initWithFrame:CGRectMake(-TOC_WIDTH, 10.0f, TOC_WIDTH, TOC_HEIGHT)];
        [tableOfContentsView createTableOfContents:contentDict];
        
        [self.view addSubview:tableOfContentsView];
        
        [UIView beginAnimations:nil context:nil];  
        
        //find nice bouncy easing
        //reference: http://stackoverflow.com/questions/5161465/how-to-create-custom-easing-function-with-core-animation
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [UIView animateWithDuration:0.2
                         animations:^{tableOfContentsView.frame = CGRectMake(0, 10.0f, TOC_WIDTH, TOC_HEIGHT);}
                         completion:^(BOOL finished){ [self tableOfContentsHasAppeared]; }];
        
        [UIView commitAnimations];
    }
    else
    {
        NSLog(@"DVC displayTableOfContents DELETE");
        
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [UIView animateWithDuration:0.2
                         animations:^{tableOfContentsView.frame = CGRectMake(-TOC_WIDTH, 10.0f, TOC_WIDTH, TOC_HEIGHT);}
                         completion:^(BOOL finished){ [self removeTableOfContentsView]; }];
        
        [UIView commitAnimations];
        
    }
    
}


-(void)tableOfContentsHasAppeared
{
    NSLog(@"DVC tableOfContentsHasAppeared");
}


-(void)removeTableOfContentsView
{
    [tableOfContentsView removeFromSuperview];
    [tableOfContentsView release];
    tableOfContentsView = nil;
}


- (void)displayMenuPanel{
    
    if (!menuPanel)
    {
        NSLog(@"DVC displayMenuPanel");
        
        menuPanel = [[MenuPanel alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [menuPanel createMenuPanel];
        menuPanel.alpha = 0;
        
        [self.view addSubview:menuPanel];
        
        [UIView beginAnimations:nil context:nil];  
        
        //find nice bouncy easing
        //reference: http://stackoverflow.com/questions/5161465/how-to-create-custom-easing-function-with-core-animation
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [UIView animateWithDuration:5.0
                         animations:^{menuPanel.alpha = 1;}
                         completion:^(BOOL finished){ [self menuPanelHasAppeared]; }];
        
        [UIView commitAnimations];
    }
    else
    {
        NSLog(@"DVC displayMenuPanel DELETE");
        
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [UIView animateWithDuration:5.0
                         animations:^{menuPanel.alpha = 0;}
                         completion:^(BOOL finished){ [self removeMenuPanelView]; }];
        
        [UIView commitAnimations];
        
    }
    
}

-(void)menuPanelHasAppeared
{
    NSLog(@"DVC menuPanelHasAppeared");
}


-(void)removeMenuPanelView
{
    [menuPanel removeFromSuperview];
    [menuPanel release];
    menuPanel = nil;
}


//*****************************************
#pragma mark - EVENTS
//*****************************************

-(void)handleEvent:(NSNotification *)aNotification {
    NSLog(@"DVC handleEvent %@", aNotification);
}

-(void)showHome {
    
}

//*****************************************
#pragma mark - UTILITIES
//*****************************************



- (void)logPageInfo {
    //NSLog(@"Title: %@ Page: %i", [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Title"], pageIndex);
    
    NSLog(@"DVC logPageInfo");
    NSLog(@"DVC     mediaType:, %@", [currentPageViewController.pageData getMediaType]);
    NSLog(@"DVC     mediaPath:, %@", [currentPageViewController.pageData getMediaPath]);
    
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
