//
//  ImagePVC.m
//  Defrag
//
//  Created by Steve Warren on 10/9/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "ImagePVC.h"


@implementation ImagePVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)displayPage
{
    [super displayPage];
     NSLog(@"ImagePVC displayPage");
    //THIS METHOD MUST BE OVERRIDEN IN IMPLEMENTATION CLASSES
    
    NSLog(@"ImagePVC MEDIA TYPE: JPG");
    
    UIImage *myImage;
    UIView *myView;
    
    myImage = [UIImage imageNamed:[pageData getMediaPath]];
    myView = [[UIImageView alloc] initWithImage:myImage];
    self.view = myView;
    
    [myImage release];
    [myView release];
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"ImagePVC loadView");
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ImagePVC viewDidLoad");
    
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

@end
