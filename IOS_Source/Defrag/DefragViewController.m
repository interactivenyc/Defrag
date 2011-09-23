//
//  DefragViewController.m
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "DefragViewController.h"
#import "FirstViewController.h"
#import "Animator.h"
#import "DefragAppDelegate.h"
#import <QuartzCore/CoreAnimation.h>


#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4

@implementation DefragViewController


@synthesize swipeRightRecognizer, swipeLeftRecognizer, swipeUpRecognizer, swipeDownRecognizer;

@synthesize pageIndex, articleIndex, pageCount, articleCount;
@synthesize contentDict;
@synthesize moviePlayer;


- (void)dealloc {
    [swipeRightRecognizer release];
    [swipeLeftRecognizer release];
    [swipeUpRecognizer release];
    [swipeDownRecognizer release];


    [contentDict release];


    [super dealloc];
}

//*****************************************
#pragma mark - VIEW DID LOAD
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");

    //NSLog(@"DefragViewController PARSE PLIST");
    contentDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"plist"]];

    articleCount = 9;
    articleIndex = 0;
    pageCount = 1;
    pageIndex = 0;

    [self turnPage:1];

    [self setupGestureRecognizer];

    [self setNavigationBarHidden:YES];

    //[self pushViewController:[[[FirstViewController alloc] init] autorelease] animated:TRUE];


    /*
     
     //PARSING XML CODE LEFT HERE FOR FUTURE REFERENCE
     
    NSLog(@"DefragViewController PARSE XML");
    contentData = [[NSMutableData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"xml"]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:contentData];
    [parser setDelegate:self];
    [parser parse];
    */

    //[NSXMLParser *contentXML] = [NSXMLParser initialize




}

//*****************************************
#pragma mark - PAGE NAVIGATION
//*****************************************


-(void)turnPage: (char)whichDirection
{
    NSLog(@"turnPage");
    [self logPageInfo];


    

    if ([[[self getMediaItem] objectForKey:@"Type"] isEqualToString:@"jpg"]){
        NSLog(@"MEDIA TYPE: JPG");

        UIImage *nextImage;
        UIView *nextView;
        UIViewController *nextController;

        nextImage = [UIImage imageNamed:[[self getMediaItem] objectForKey:@"Media"]];
        nextView = [[UIImageView alloc] initWithImage:nextImage];
        nextController = [[UIViewController alloc] init];
        nextController.view = nextView;


        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionPush];


        switch (whichDirection)
        {
            case 1:   //left
                [transition setSubtype:kCATransitionFromRight];
                break;
            case 2:       //right
                [transition setSubtype:kCATransitionFromLeft];
                break;
            case 3:      //up
                [transition setSubtype:kCATransitionFromTop];
                break;
            case 4:     //down
                [transition setSubtype:kCATransitionFromBottom];
                break;
            default:
                [transition setSubtype:kCATransitionFromRight];

        }

        [transition setDuration:0.2f];

        CALayer *layer;
        layer = nextController.view.layer;
        [layer addAnimation:transition forKey:@"Transition"];

        [self pushViewController:nextController animated:NO];


        [nextView release];
        [nextImage release];
        [nextController release];


    } else if ([[[self getMediaItem] objectForKey:@"Type"] isEqualToString:@"mov"]){
        NSLog(@"MEDIA TYPE: MOV");
        NSLog(@"createMoviePlayer");

        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] init];
        [player.view setFrame: self.view.bounds];  // player's frame must match parent's
        [self.view addSubview: player.view];

        self.moviePlayer = player;
        [player release];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];


        NSLog(@"initAndPlayMovie: %@", [[self getMediaItem] objectForKey:@"Media"]);

        NSString *rootPath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [rootPath stringByAppendingPathComponent:[[self getMediaItem] objectForKey:@"Media"]];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];

        [self.moviePlayer setContentURL:fileURL];
        [self.moviePlayer play];



    }


    

}






-(void)playerPlaybackDidFinish:(NSNotification *)notification
{
    NSLog(@"playerPlaybackDidFinish");

    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: moviePlayer];

    [moviePlayer.view removeFromSuperview];

    // Release the movie instance created in playMovieAtURL:
    [moviePlayer release];

    articleIndex = articleIndex + 1;
    [self turnPage:1];

}


//*****************************************
#pragma mark - SWIPE GESTURE HANDLING
//*****************************************


- (void)setupGestureRecognizer {

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
}


- (void)handleGesture:(UISwipeGestureRecognizer *)sender {
    //NSLog(@"handleGesture");

    char direction;


    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
           // NSLog(@"handleGesture Left");
            articleIndex = articleIndex + 1;
            pageIndex = 0;
            direction = 1;

            break;

        case UISwipeGestureRecognizerDirectionRight:
           // NSLog(@"handleGesture Right");

            if (articleIndex == 0) return;

            articleIndex = articleIndex - 1;
            pageIndex = 0;
            direction = 2;

            break;

        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"handleGesture Up");
            pageIndex = pageIndex + 1;
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

    [self turnPage:direction];
}



//*****************************************
#pragma mark - UTILITIES AND GETTER/SETTER
//*****************************************

- (void)logPageInfo {
    //NSLog(@"Title: %@ Page: %i", [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Title"], pageIndex);

    NSLog(@"Media: %@", [[self getMediaItem] objectForKey:@"Media"]);

}


- (NSDictionary *)getMediaItem {
    return [[[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:articleIndex] objectForKey:@"Media"] objectAtIndex:pageIndex];
}



    //*****************************************
    //#pragma mark - VIDEO PLAYER EVENT HANDLING
    //*****************************************

/*
//- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
//
//    NSLog(@"remoteControlReceivedWithEvent");
//
//
//    if (receivedEvent.type == UIEventTypeRemoteControl) {
//
//        switch (receivedEvent.subtype) {
//
//            case UIEventSubtypeRemoteControlTogglePlayPause:
//                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
//                break;
//            case UIEventSubtypeRemoteControlPlay:
//                NSLog(@"UIEventSubtypeRemoteControlPlay");
//                break;
//            case UIEventSubtypeRemoteControlPause:
//                NSLog(@"UIEventSubtypeRemoteControlPause");
//                break;
//            case UIEventSubtypeRemoteControlStop:
//                NSLog(@"UIEventSubtypeRemoteControlStop");
//                break;
//
//
//            default:
//                break;
//        }
//    }
//}
*/


//*****************************************
//#pragma mark - SWIPE GESTURE HANDLING
//*****************************************

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    // startTouchPosition is an instance variable
    startTouchPosition = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    // To be a swipe, direction of touch must be horizontal and long enough.
    if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
    {
        // It appears to be a swipe.
        if (startTouchPosition.x < currentTouchPosition.x)
            [self myProcessRightSwipe:touches withEvent:event];
        else
            [self myProcessLeftSwipe:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    startTouchPosition = CGPointZero;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    startTouchPosition = CGPointZero;
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            //[self.superview bringSubviewToFront:self];
            // A DOUBLE TAP OCCURRED
        }
    }
}

*/


//*****************************************
//#pragma mark NSXMLParser delegate methods
//*****************************************

/*
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    //NSLog(@"parser didStartElement: %@", elementName);
    //NSLog(@"attributes: %@", [attributeDict objectEnumerator]);
    
    
    // If the number of parsed earthquakes is greater than kMaximumNumberOfEarthquakesToParse, abort the parse.
    if (parsedEarthquakesCounter >= kMaximumNumberOfEarthquakesToParse) {
        // Use the flag didAbortParsing to distinguish between this deliberate stop and other parser errors.
        didAbortParsing = YES;
        [parser abortParsing];
    }
    if ([elementName isEqualToString:kEntryElementName]) {
        Earthquake *earthquake = [[Earthquake alloc] init];
        self.currentEarthquakeObject = earthquake;
        [earthquake release];
    } else if ([elementName isEqualToString:kLinkElementName]) {
        NSString *relAttribute = [attributeDict valueForKey:@"rel"];
        if ([relAttribute isEqualToString:@"alternate"]) {
            NSString *USGSWebLink = [attributeDict valueForKey:@"href"];
            static NSString * const kUSGSBaseURL = @"http://earthquake.usgs.gov/";
            self.currentEarthquakeObject.USGSWebLink = [kUSGSBaseURL stringByAppendingString:USGSWebLink];
        }
    } else if ([elementName isEqualToString:kTitleElementName] || [elementName isEqualToString:kUpdatedElementName] || [elementName isEqualToString:kGeoRSSPointElementName]) {
        // For the 'title', 'updated', or 'georss:point' element, begin accumulating parsed character data.
        // The contents are collected in parser:foundCharacters:.
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        [currentParsedCharacterData setString:@""];
    }
     
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    
    //NSLog(@"parser didEndElement: ");
    
    
    if ([elementName isEqualToString:kEntryElementName]) {
        [self.currentParseBatch addObject:self.currentEarthquakeObject];
        parsedEarthquakesCounter++;
        if (parsedEarthquakesCounter % kSizeOfEarthquakeBatch == 0) {
            [self performSelectorOnMainThread:@selector(addEarthquakesToList:) withObject:self.currentParseBatch waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
        }
    } else if ([elementName isEqualToString:kTitleElementName]) {
        // The title element contains the magnitude and location in the following format:
        // <title>M 3.6, Virgin Islands region<title/>
        // Extract the magnitude and the location using a scanner:
        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
        // Scan past the "M " before the magnitude.
        [scanner scanString:@"M " intoString:NULL];
        CGFloat magnitude;
        [scanner scanFloat:&magnitude];
        self.currentEarthquakeObject.magnitude = magnitude;
        // Scan past the ", " before the title.
        [scanner scanString:@", " intoString:NULL];
        NSString *location = nil;
        // Scan the remainer of the string.
        [scanner scanUpToCharactersFromSet:[NSCharacterSet illegalCharacterSet]  intoString:&location];
        self.currentEarthquakeObject.location = location;
    } else if ([elementName isEqualToString:kUpdatedElementName]) {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        self.currentEarthquakeObject.date = [dateFormatter dateFromString:self.currentParsedCharacterData];
    } else if ([elementName isEqualToString:kGeoRSSPointElementName]) {
        // The georss:point element contains the latitude and longitude of the earthquake epicenter.
        // 18.6477 -66.7452
        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
        double latitude, longitude;
        [scanner scanDouble:&latitude];
        [scanner scanDouble:&longitude];
        self.currentEarthquakeObject.latitude = latitude;
        self.currentEarthquakeObject.longitude = longitude;
    }
     
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
     
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not
// guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to
// accumulate character data until the end of the element is reached.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"parser foundCharacters: %@", string);
    
    
    //if (accumulatingParsedCharacterData) {
    //    // If the current element is one whose content we care about, append 'string'
    //    // to the property that holds the content of the current element.
    //    [self.currentParsedCharacterData appendString:string];
    //}
     
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //NSLog(@"parser parseErrorOccurred: %@", parseError);
    
    // If the number of earthquake records received is greater than kMaximumNumberOfEarthquakesToParse, we abort parsing.
    // The parser will report this as an error, but we don't want to treat it as an error. The flag didAbortParsing is
    // how we distinguish real errors encountered by the parser.
    
    
    //if (didAbortParsing == NO) {
    //    // Pass the error to the main thread for handling.
    //    [self performSelectorOnMainThread:@selector(handleError:) withObject:parseError waitUntilDone:NO];
    //}
     
}
*/






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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

@end
