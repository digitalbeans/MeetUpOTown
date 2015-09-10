//
//  MeetupsListTableViewController.h
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetupDownload.h"
#import "MeetupDelegate.h"
#import "MeetupInfo.h"

@interface MeetupsListTableViewController : UIViewController <MeetupDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Boolean showFavorites;
@property (nonatomic) NSInteger pageOffset;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoritesButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) MeetupDownload *meetupDownloader;
@property (strong, nonatomic) NSMutableArray *meetups;
@property (strong, nonatomic) NSMutableArray *favorites;
@property (strong, nonatomic) MeetupInfo *selectedEvent;

- (IBAction)doShowFavorites:(id)sender;
- (IBAction)handleEditPress:(id)sender;
- (void)refresh:(UIRefreshControl *)refreshControl;

@end
