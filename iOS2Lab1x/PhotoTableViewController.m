//
//  PhotoTableViewController.m
//  iOS2Lab1x
//
//  Created by James Derry on 11/4/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "Api500pxFetcher.h"
#import "PhotoTableViewCell.h"
#import "PhotoMapViewController.h"

@interface PhotoTableViewController ()
{
    Api500pxFetcher *fetcher;
}

@end

@implementation PhotoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    fetcher = [[Api500pxFetcher alloc] init];
    fetcher.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [fetcher.gallery count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photoCell";
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if ([fetcher.gallery count] > 0) {
        Photo *thisPhoto = [fetcher.gallery objectAtIndex:indexPath.row];
        cell.photoImageView.image = thisPhoto.image;
        cell.name.text = thisPhoto.name;
        cell.user.text = thisPhoto.user;
    } else {
        cell.user.text = @"loading...";
    }

    return cell;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [fetcher.gallery count] - 3) {
        [fetcher getMorePhotos];
    }
}



#pragma mark Api500pxFetcherDelegate Methods

- (void)didReceiveNewPhotos
{
    NSLog(@"fetcher delegate called.");
    [_tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [self downloadImages];
}

- (void)downloadImages
{
    for (Photo *photo in fetcher.gallery) {
        
        if (photo.image == nil) {
            
            NSUInteger row = [fetcher.gallery indexOfObject:photo];
            
            dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(backgroundQueue, ^{
                photo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.imageURL]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
                
                
            });
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PhotoMapViewController *destinationVC = (PhotoMapViewController *)segue.destinationViewController;
    destinationVC.gallery = [NSArray arrayWithArray:fetcher.gallery];
}

@end
