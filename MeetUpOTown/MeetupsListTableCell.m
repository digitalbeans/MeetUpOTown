//
//  MeetupsListTableCell.m
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "MeetupsListTableCell.h"

// Custom UITableViewCell to accomodate all meetup data.
@implementation MeetupsListTableCell
@synthesize dateLabel, timeLabel, groupNameLabel, meetupNameLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// workaround to get table cells to resize correctly
- (void)adjustSizeToMatchWidth:(CGFloat)width
{
    // Workaround for visible cells not laid out properly since their layout was
    // based on a different (initial) width from the tableView.

    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;

    // Workaround for initial cell height less than auto layout required height.

    rect = self.contentView.bounds;
    rect.size.height = 99999.0;
    rect.size.width = 99999.0;
    self.contentView.bounds = rect;
}
@end
