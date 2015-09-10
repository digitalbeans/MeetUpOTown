//
//  MeetupDetailViewController.h
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetupInfo.h"

@interface MeetupDetailViewController : UIViewController

@property (strong, nonatomic) MeetupInfo *meetupInfo;
@property (nonatomic) BOOL favorite;
@property (strong, nonatomic) IBOutlet UILabel *meetupNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)changeFavoriteButton:(id)sender;

@end
