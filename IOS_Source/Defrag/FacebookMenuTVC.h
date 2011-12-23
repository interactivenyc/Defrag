//
//  FacebookMenuTVC.h
//  Defrag
//
//  Created by Steve Warren on 12/16/11.
//  Copyright (c) 2011 Funny Garbage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookMenuTVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
        NSArray *data;
}

@property (nonatomic, retain) NSArray *data;


@end
