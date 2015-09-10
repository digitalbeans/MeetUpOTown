//
//  MeetupsListTableViewController.m
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "MeetupsListTableViewController.h"
#import "MeetupInfo.h"
#import "MeetupsListTableCell.h"
#import "MeetupDetailViewController.h"
#import "Favorites.h"

@interface MeetupsListTableViewController ()

@end

@implementation MeetupsListTableViewController
@synthesize meetupDownloader, meetups, favorites, selectedEvent;
@synthesize activityIndicator, showFavorites, favoritesButton, refreshControl, pageOffset;

- (void)viewDidLoad {
    [super viewDidLoad];

	// set default to show all meetups
	self.showFavorites = NO;
	self.pageOffset = 0;
	
	// Add a refresh control to allow reloading meetup info
	refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

	// set table display settigns
	self.tableView.estimatedRowHeight = 44.0;
	self.tableView.rowHeight = UITableViewAutomaticDimension;

	meetups = [NSMutableArray array];
	// request meetup info from meetup.com
	[self startFetchingMeetups];
	// load favorites info from disk
	favorites = [Favorites getFavorites];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}

- (void) viewDidLayoutSubviews
{
	self.tableView.estimatedRowHeight = 44.0;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
	// reload meetup info
	pageOffset = 0;
	[self startFetchingMeetups];
}


// Download the meetup information for Orlando
- (void)startFetchingMeetups
{
	// If nil, instantiate new MeetupDownload
	if (!meetupDownloader) {
		meetupDownloader = [[MeetupDownload alloc] init];
		meetupDownloader.delegate = self;
	}
	// Retrieve meetups for Orlando, FL 
	[meetupDownloader searchMeetupsInCity:@"Orlando" andState:@"FL" offset:pageOffset];
}

// Required for MeetupDelegate protocol. Called on successful load of meetup info
- (void)didReceiveMeetups:(NSMutableArray *)theMeetups
{
	pageOffset = pageOffset + 1;
	[self.activityIndicator stopAnimating];
    [refreshControl endRefreshing];
	if (!meetups) {
	    meetups = [NSMutableArray array];
	}
	[self.meetups addObjectsFromArray:theMeetups];
//	self.meetups = theMeetups;
	[self.tableView reloadData];
}

// Required for MeetupDelegate protocol. Called on failure to load of meetup info
- (void)fetchingMeetupsFailedWithError:(NSError *)error
{
	[self.activityIndicator stopAnimating];
    [refreshControl endRefreshing];
	
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occurred", nil) message: error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
	
	
	UIAlertAction *cancelAction = [UIAlertAction
            actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                      style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction *action)
                    {
                      NSLog(@"Cancel action");
                    }];
	[alertController addAction:cancelAction];
	

	[self presentViewController:alertController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Set number of rows based on full list or favorites
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (showFavorites) {
    	return favorites.count;
	} else {
    	return meetups.count;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetupsListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetupTableCell" forIndexPath:indexPath];
	
	MeetupInfo *event = nil;
	if (showFavorites) {
	    event = [favorites objectAtIndex:indexPath.row];
	} else {
	    event = [meetups objectAtIndex:indexPath.row];
	}
	if (event) {

		cell.meetupNameLabel.text = event.name;
		[cell.meetupNameLabel sizeToFit];
		cell.groupNameLabel.text = event.group;
		
		long long timeLong = [event.time longLongValue];
		NSTimeInterval time = timeLong/1000;
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

		[dateFormatter setDateFormat:@"EEE MMM dd"];
		NSString *dateStr =[dateFormatter stringFromDate:date];
		cell.dateLabel.text = dateStr;
		[cell.dateLabel sizeToFit];
		
		[dateFormatter setDateFormat:@"hh:mm aaa"];
		NSString *timeStr =[dateFormatter stringFromDate:date];
		cell.timeLabel.text = timeStr;
		[cell.timeLabel sizeToFit];
		
		// to get the cells to set correct width so labels will size correctly
		[cell adjustSizeToMatchWidth:CGRectGetWidth(self.tableView.frame)];
		

	}
	
	
    return cell;
}

// Display meetup details view
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (showFavorites) {
    	self.selectedEvent = [self.favorites objectAtIndex:indexPath.row];
	} else {
		self.selectedEvent = [meetups objectAtIndex:indexPath.row];
	}
	[self performSegueWithIdentifier:@"ShowDetailSegue" sender:self];
}

// Called on Favorites/All button press to switch view between all meetups and just favorites
- (IBAction)doShowFavorites:(id)sender
{
	showFavorites =  !showFavorites;
	[self setFavoriteButtonTitle];
	if (showFavorites) {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(handleEditPress:)];
	} else {
		self.navigationItem.leftBarButtonItem = nil;
	}
	self.tableView.editing = NO;

	[self.tableView reloadData];
}

// Set the table for editing and update the Edit/Done button
- (IBAction)handleEditPress:(id)sender
{
	if (showFavorites) {
		if (self.tableView.editing) {
    		self.tableView.editing = NO;
			self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(handleEditPress:)];
		} else {
			self.tableView.editing = YES;
			self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleEditPress:)];
		}
	}
}

// Alternate the right site button title between All/Favorites based on current setting
- (void)setFavoriteButtonTitle {
    if (showFavorites) {
		[favoritesButton setTitle:@"All"];
    } else {
        [favoritesButton setTitle:@"Favorites"];
    }
}


// Override to support conditional editing of the table view.
// Table editing only available when viewing favorites
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if (showFavorites) {
		return YES;
	} else {
		return NO;
	}
}



// Override to support editing the table view.
// Delete selected meetup from favorites
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		MeetupInfo *event = [self.favorites objectAtIndex:indexPath.row];
		[self.favorites removeObjectAtIndex:indexPath.row];
		[Favorites removeFavorite:event];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
// Move the selected meetup and save settings.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	MeetupInfo *meetup = [self.favorites objectAtIndex:fromIndexPath.row];
	[favorites removeObjectAtIndex:fromIndexPath.row];
	[favorites insertObject:meetup atIndex:toIndexPath.row];
	[Favorites saveSettings];
}



// Override to support conditional rearranging of the table view.
// Allow rearrange of cells only when viewing favorites
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
	if (showFavorites) {
	    return YES;
	} else {
		return NO;
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;

    float reload_distance = 50;
    if(y > h + reload_distance) {
        NSLog(@"load more rows");
		[self.activityIndicator startAnimating];
		[self startFetchingMeetups];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
// Set selected meetup in Detail view before segue.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
	UINavigationController *nav = (UINavigationController *)[segue destinationViewController];
	MeetupDetailViewController *mvc =  (MeetupDetailViewController *)nav.topViewController;
	mvc.meetupInfo = selectedEvent;
}


@end
