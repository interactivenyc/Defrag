//
//  DefragViewController.m
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "DefragViewController.h"
#import "DefragAppDelegate.h"
#import "APICallsViewController.h"
//#import "TWTweetComposeViewController.h"


NSString *MENUPANEL_BTN_CLICKED = @"MENUPANEL_BTN_CLICKED";

@implementation DefragViewController

//Integers don't need to be dealloc'ed
@synthesize pageIndex, articleIndex, articleCount, pageCount;
@synthesize direction;
@synthesize tapRecognizer;

@synthesize currentPageViewController;
@synthesize contentDict;
@synthesize menuPanel;

@synthesize permissions;


//*****************************************
#pragma mark - DEALLOC
//*****************************************

- (void)dealloc {
    
    [tapRecognizer release];
    [currentPageViewController release];
    [contentDict release];
    [menuPanel release];
    [permissions release];
    [super dealloc];
}

//*****************************************
#pragma mark - VIEW DID LOAD
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");
    NSLog(@"INITIALIZE");
    
    contentDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"plist"]];
    articleCount = [[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] count];
    articleIndex = 0;
    pageIndex = 0;
    direction = 1;
    
    [self calculatePageCount];
    [self setupGestureRecognizers];    
    [self setNavigationBarHidden:YES];   
    
    //ADD EVENT LISTENERS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuPanelButtonClicked:) name:MENUPANEL_BTN_CLICKED object:nil];
    
    [self createPage];
    
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:gr];
    [gr release]; 
    
}


//*****************************************
#pragma mark - LONG PRESS MENU FOR TESTING
//*****************************************

- (void) longPress:(UILongPressGestureRecognizer *) gestureRecognizer {
        NSLog(@"longPress state:%i", gestureRecognizer.state);
}

/*
- (void) longPress:(UILongPressGestureRecognizer *) gestureRecognizer {
    
    NSLog(@"longPress state:%i", gestureRecognizer.state);

    
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"1" action:@selector(menuItemClicked:)];
        
        NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
        [menuController setMenuItems:[NSArray arrayWithObjects:resetMenuItem, resetMenuItem, nil]];
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
        
        [resetMenuItem release];
    }
}

- (void) copy:(id) sender {
    // called when copy clicked in menu
}

- (void) menuItemClicked:(id) sender {
    // called when Item clicked in menu
}

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(menuItemClicked:) || selector == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}
*/

//*****************************************
#pragma mark - GESTURE SUPPORT
//*****************************************


- (void)setupGestureRecognizers {
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    tapRecognizer.delegate = self;
    [tapRecognizer release];
    
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
    
    
}


- (void)handleTap:(UITapGestureRecognizer *)sender 
{
    //NSLog(@"DVC handleTap %@", sender);
    [self displayMenuPanel];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //ignore any touches from a UIToolbar
    
    if ([touch.view.superview isKindOfClass:[UIToolbar class]]) {      //change it to your condition
        return NO;
    }
    return YES;
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
    //[self displayTableOfContents];
    
    if (menuPanel != nil){
        [self displayMenuPanel];
    }
}

-(void)createPage
{
    //NSLog(@"DVC createPage");
    
    PageData *pageData = [[PageData alloc] init ];
    pageData.pageDictionary = [self getMediaItem];
    
    NSString *mediaType = [pageData getMediaType];
    //NSLog(@"DVC mediaType: %@", mediaType);
    
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
    //NSLog(@"DVC displayPage");
    
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



//*****************************************
#pragma mark - TABLE OF CONTENTS / ARTICLE NAVIGATION
//*****************************************


- (void)displayMenuPanel{
    
    if (!menuPanel)
    {
        //NSLog(@"DVC displayMenuPanel");
        
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
        //NSLog(@"DVC displayMenuPanel DELETE");
        
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
    //NSLog(@"DVC menuPanelHasAppeared");
}


-(void)removeMenuPanelView
{
    [menuPanel removeFromSuperview];
    [menuPanel release];
    menuPanel = nil;
}


//*****************************************
#pragma mark - MENU PANEL EVENTS
//*****************************************

-(void)menuPanelButtonClicked:(NSNotification *)aNotification {
    NSLog(@"DVC menuPanelButtonClicked name: %@ object: %@ ", aNotification.name, aNotification.object);
    
    NSString *buttonName = (NSString *)[aNotification object];
    
    
    if ([buttonName isEqualToString:@"homeButton"]){
        [self setArticleByIndex:0];
        
    }else if ([buttonName isEqualToString:@"menuButton"]){
        [menuPanel displayTableOfContents];
        
    }else if ([buttonName isEqualToString:@"facebookButton"]){
        NSLog(@"facebookButton CLICKED");
                
        DefragAppDelegate *delegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
        
        if (![[delegate facebook] isSessionValid]) {
            NSLog(@"DVC tell facebook to login");
            [self login];
        } else {
            NSLog(@"DVC facebook is logged in");
            [self fbPostToWall];
        }
        
    }else if ([buttonName isEqualToString:@"twitterButton"]){
        NSLog(@"twitterButton CLICKED");
        [self tweetAbout];
        
    }else if ([buttonName isEqualToString:@"infoButton"]){
            NSLog(@"infoButton CLICKED");
            
            UIViewController *infoViewController = [[UIViewController alloc] init];
            infoViewController.view.backgroundColor = [UIColor whiteColor];
            
            UIPopoverController *info = [[UIPopoverController alloc] initWithContentViewController:infoViewController];
            info.popoverContentSize = CGSizeMake(300, 300);
            [info presentPopoverFromRect:CGRectMake(952, 24, 24, 24) inView:menuPanel permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }else if ([buttonName isEqualToString:@"prefsButton"]){
        NSLog(@"prefsButton CLICKED");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Attention" message:@"Do You Like This App?" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Rate It!", @"Upgrade!", nil];
        [alert show];
        [alert release];
    }
    
}


//*****************************************
#pragma mark - Facebook API Calls
//*****************************************


/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void) apiFQLIMe {
    NSLog(@"DVC apiFQLIMe");

    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    
    
    DefragAppDelegate *appDelegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
    [[appDelegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void) apiGraphUserPermissions {
    NSLog(@"DVC apiGraphUserPermissions");

    DefragAppDelegate *appDelegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate]; 
    [[appDelegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}


#pragma - Private Helper Methods

/**
 * Show the logged in menu
 */

- (void) showLoggedIn {
    NSLog(@"DVC showLoggedIn");
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //self.backgroundImageView.hidden = YES;
    //loginButton.hidden = YES;
    //self.menuTableView.hidden = NO;
    
    [self apiFQLIMe];
}

/**
 * Show the logged in menu
 */

- (void) showLoggedOut:(BOOL)clearInfo {
    NSLog(@"DVC showLoggedOut");

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (clearInfo && [defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        
        // Nil out the session variables to prevent
        // the app from thinking there is a valid session
        DefragAppDelegate *appDelegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
        if (nil != [[appDelegate facebook] accessToken]) {
            [appDelegate facebook].accessToken = nil;
        }
        if (nil != [[appDelegate facebook] expirationDate]) {
            [appDelegate facebook].expirationDate = nil;
        }
    }
    
    //self.menuTableView.hidden = YES;
    //self.backgroundImageView.hidden = NO;
    //loginButton.hidden = NO;
    
    // Clear personal info
    //nameLabel.text = @"";
    // Get the profile image
   // [profilePhotoImageView setImage:nil];
}



//*****************************************
#pragma mark - FACEBOOK FUNCTIONS
//*****************************************


/**
 * Show the authorization dialog.
 */
- (void)login {
    NSLog(@"DVC login");

    DefragAppDelegate *delegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![[delegate facebook] isSessionValid]) {
        NSLog(@"DVC login facebook session is not valid");
        [delegate facebook].sessionDelegate = self;
        
        permissions = [[NSArray alloc] initWithObjects:
                                @"user_photos",
                                @"user_about_me",
                                @"user_location",
                                @"email",
                                @"publish_stream",
                                @"read_insights",
                                nil];
        
        [[delegate facebook] authorize:permissions];
    } else {
        NSLog(@"DVC login facebook session is valid");
        [self showLoggedIn];
    }
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    DefragAppDelegate *delegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout:self];
}

/**
 * Helper method called when a menu button is clicked
 */
- (void)menuButtonClicked:(id) sender
{
    // Each menu button in the UITableViewController is initialized
    // with a tag representing the table cell row. When the button
    // is clicked the button is passed along in the sender object.
    // From this object we can then read the tag property to determine
    // which menu button was clicked.
    APICallsViewController *controller = [[APICallsViewController alloc] 
                                          initWithIndex:[sender tag]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)fbPostToWall{
    NSLog(@"DVC fbPostToWall");
    
    
    
    
    /*
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
     
    NSString *defragURL = @"http://www.kickstarter.com/projects/1642957716/defrag-the-interactive-ipad-magazine-of-global-cul";
     
    NSDictionary *actionLinks = [NSArray arrayWithObjects:[NSDictionary 
                                                           dictionaryWithObjectsAndKeys: @"Defrag Magazine", @"text", defragURL,
                                                           @"href", nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSDictionary *attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Defrag Magazine", @"name",
                                @"The Digital Magazine of Global Culture", @"caption",
                                @"Check out Defrag in the App Store", @"description",
                                @"Share on Facebook", @"link", 
                                @"image", @"user_message_prompt", 
                                @"http://s3.amazonaws.com/ksr/avatars/546922/Picture_10.large.jpg", @"picture", nil];
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjectsAndKeys:
                                   @"Share on Facebook",  @"user_message_prompt",
                                   actionLinksStr, @"action_links",
                                   attachmentStr, @"attachment",
                                   nil];
     
     DefragAppDelegate *appDelegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
     [[appDelegate facebook] dialog:@"stream.publish" andParams:params andDelegate:self];
     
     */
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"The Digital Magazine of Global Culture", @"caption",
                            @"Check out Defrag in the App Store", @"description",
                            @"Share on Facebook",  @"user_message_prompt",
                            @"http://www.kickstarter.com/projects/1642957716/defrag-the-interactive-ipad-magazine-of-global-cul", @"link",
                            @"http://s3.amazonaws.com/ksr/avatars/546922/Picture_10.large.jpg", @"picture",
                            nil];
    
    NSLog(@"DVC params: %@", params);
    
    DefragAppDelegate *appDelegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
    [[appDelegate facebook] dialog:@"feed" andParams:params andDelegate:self];
}


-(void)tweetAbout{
    NSLog(@"DVC tweetAbout");
    /*
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"Initial Tweet Text!"];
        [self presentModalViewController:tweetSheet animated:YES];
    }
     */
}

//*****************************************
#pragma mark - FACEBOOK DELEGATE FUNCTIONS
//*****************************************


- (void)fbDidLogin{
    NSLog(@"DVC fbDidLogin");
    DefragAppDelegate *appDelegate = (DefragAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSLog(@"DVC requestWithGraphPath me");
    [[appDelegate facebook] requestWithGraphPath:@"me" andDelegate:self];
    
    //NSLog(@"DVC requestWithGraphPath platform/insights");
    //[[appDelegate facebook] requestWithGraphPath:@"152832481487502/insights" andDelegate:self];
    
    [self apiFQLIMe];

    
    [self fbPostToWall];
   

}

- (void)fbDidNotLogin:(BOOL)cancelled{
    //the boolean cancelled if true, means the user cancelled the login attempt
    NSLog(@"DVC fbDidNotLogin");
    
}
- (void)fbDidLogout{
    NSLog(@"DVC fbDidLogout");

}

//*****************************************
#pragma mark - FACEBOOK REQUEST DELEGATE FUNCTIONS
//*****************************************

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request{
    NSLog(@"DVC requestLoading");

}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request json:(NSURLResponse *)response{
    NSLog(@"DVC request didReceiveResponse");
    

}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"DVC request didFailWithError:%@", error.description);

}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result{
    NSLog(@"DVC request didLoad");
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    NSLog(@"DVC response:%@", result);


}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data{
    NSLog(@"DVC request didLoadRawResponse");

}

//*****************************************
#pragma mark - FACEBOOK DIALOG DELEGATE FUNCTIONS
//*****************************************


/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog{
    NSLog(@"DVC dialogDelegate dialogDidComplete");
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url{
    NSLog(@"DVC dialogDelegate dialogCompleteWithUrl");

}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url{
    NSLog(@"DVC dialogDelegate dialogDidNotCompleteWithUrl");

}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog{
    NSLog(@"DVC dialogDelegate dialogDidNotComplete");

}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
    NSLog(@"DVC dialogDelegate didFailWithError");

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


-(void)displayTableViewPopup{
    FacebookMenuTVC *facebookMenu = [[FacebookMenuTVC alloc] init];
    
    UIPopoverController *info = [[UIPopoverController alloc] initWithContentViewController:facebookMenu];
    info.popoverContentSize = CGSizeMake(300, 300);
    [info presentPopoverFromRect:CGRectMake(952, 24, 24, 24) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [facebookMenu release];
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
