//
//  MeetupDetailViewController.m
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "MeetupDetailViewController.h"
#import "Favorites.h"
@interface MeetupDetailViewController ()

@end

@implementation MeetupDetailViewController
@synthesize meetupInfo, dateLabel, meetupNameLabel, groupNameLabel, descriptionTextView;
@synthesize favorite, favoriteButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// If meetup info available, update the view.
	if (meetupInfo) {
    	meetupNameLabel.text = meetupInfo.name;
		groupNameLabel.text = meetupInfo.group;
		descriptionTextView.text = meetupInfo.description;
		[descriptionTextView scrollRangeToVisible:NSMakeRange(0, 1)];
		
		long long timeLong = [meetupInfo.time longLongValue];
		NSTimeInterval time = timeLong/1000;
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

		[dateFormatter setDateFormat:@"EEE MMM dd hh:mm aaa"];
		NSString *dateStr =[dateFormatter stringFromDate:date];
		dateLabel.text = dateStr;
		[dateLabel sizeToFit];
	
		// if current meetup is a favorite, update the favorite button image
        favorite = [Favorites isFavorite:meetupInfo];
		[self setFavoriteButtonImage];
	}

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Update favorite setting when button pressed.
- (IBAction)changeFavoriteButton:(id)sender {
    favorite = !favorite;
    if (favorite) {
        [Favorites addFavorite:meetupInfo];
    } else {
        [Favorites removeFavorite:meetupInfo];
    }
    [self setFavoriteButtonImage];
}

// update button view based on current setting
- (void)setFavoriteButtonImage {
    if (favorite) {
        [favoriteButton setImage:[UIImage imageNamed:@"blue-heart"] forState:UIControlStateNormal];
    } else {
        [favoriteButton setImage:[UIImage imageNamed:@"gray-heart"] forState:UIControlStateNormal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
