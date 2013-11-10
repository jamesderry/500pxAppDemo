//
//  PhotoTableViewController.h
//  iOS2Lab1x
//
//  Created by James Derry on 11/4/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api500pxFetcher.h"

@interface PhotoTableViewController : UITableViewController <Api500pxFetcherDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;


@end
