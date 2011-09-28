//
//  PageViewController.m
//  Defrag
//
//  Created by Steve Warren on 9/27/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import "PageViewController.h"

@implementation PageViewController

@synthesize pageData;


-(void)setPageDataWithDictionary:(NSDictionary *)pageDict
{
    pageData = [[PageData alloc] init];
    pageData.data = pageDict;

}

-(NSString *)getMediaType
{
    return [pageData.data objectForKey:@"Type"];
}

-(NSString *)getMediaPath
{
    return [pageData.data objectForKey:@"Media"];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
