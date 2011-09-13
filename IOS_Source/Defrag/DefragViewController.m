//
//  DefragViewController.m
//  Defrag
//
//  Created by swarren on 6/21/11.
//  Copyright 2011 Funny Garbage. All rights reserved.
//

#import "DefragViewController.h"
#import "FirstViewController.h"


#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4

@implementation DefragViewController


@synthesize swipeRightRecognizer, swipeLeftRecognizer;

@synthesize pageIndex;
@synthesize contentDict;
@synthesize contentData;

//*****************************************
	#pragma mark - VIEW DID LOAD
//*****************************************


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"DefragViewController viewDidLoad");
    
    pageIndex = 0;
    
    //Load and parse Content.plist
    NSLog(@"DefragViewController PARSE PLIST");
    contentDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"plist"]];
    NSLog(@"Title: %@", [[[[contentDict objectForKey:@"Root"] objectForKey:@"Articles"] objectAtIndex:0] objectForKey:@"Title"]);
    
    
    NSLog(@"DefragViewController PARSE XML");
    contentData = [[NSMutableData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Content" ofType:@"xml"]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:contentData];
    [parser setDelegate:self];
    [parser parse];
    
    
    //[NSXMLParser *contentXML] = [NSXMLParser initialize
    
    [self setupGestureRecognizer];
    
    [self pushViewController:[[FirstViewController alloc] init] animated:TRUE];
    
    
    
}





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



-(void)setupGestureRecognizer
{
    
    NSLog(@"setupGestureRecognizer NEW");
	
	swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipeRightRecognizer];
	
	swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swipeLeftRecognizer];
}


-(void)handleGesture: (UISwipeGestureRecognizer *)sender
{
	NSLog(@"handleGesture");
	
	if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
		NSLog(@"handleGesture Left");
        pageIndex = pageIndex + 1;
    }
    else {
		NSLog(@"handleGesture Right");
        pageIndex = pageIndex - 1;
    }
    
    
    NSLog(@"pageIndex: %@", [NSString stringWithFormat:@"%i", pageIndex]);
	
	
}





//*****************************************
	#pragma mark - SWIPE GESTURE HANDLING
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
    #pragma mark NSXMLParser delegate methods
//*****************************************

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"parser didStartElement: %@", elementName);
    NSLog(@"attributes: %@", [attributeDict objectEnumerator]);
    
    /*
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
     */
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    
    NSLog(@"parser didEndElement: ");
    
    /*
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
     */
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not
// guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to
// accumulate character data until the end of the element is reached.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"parser foundCharacters: %@", string);
    
    /*
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.currentParsedCharacterData appendString:string];
    }
     */
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"parser parseErrorOccurred: %@", parseError);
    
    // If the number of earthquake records received is greater than kMaximumNumberOfEarthquakesToParse, we abort parsing.
    // The parser will report this as an error, but we don't want to treat it as an error. The flag didAbortParsing is
    // how we distinguish real errors encountered by the parser.
    
    /*
    if (didAbortParsing == NO) {
        // Pass the error to the main thread for handling.
        [self performSelectorOnMainThread:@selector(handleError:) withObject:parseError waitUntilDone:NO];
    }
     */
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



//*****************************************
	#pragma mark - MEMORY CLEANUP
//*****************************************

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
