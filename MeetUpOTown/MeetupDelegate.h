//
//  MeetupDelegate.h
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetupDelegate
- (void)didReceiveMeetups:(NSMutableArray *)meetups;
- (void)fetchingMeetupsFailedWithError:(NSError *)error;
@end