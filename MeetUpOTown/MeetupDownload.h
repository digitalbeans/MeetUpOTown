//
//  MeetupDownload.h
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MeetupDelegate.h"

@interface MeetupDownload : NSObject

//@property (strong, nonatomic) NSMutabledic *meetupArray;
@property (weak, nonatomic) id<MeetupDelegate> delegate;
@property (nonatomic) NSInteger pageOffset;

- (void) searchMeetupsInCity:(NSString *)city andState:(NSString *)state offset:(NSInteger) offset;
- (void)receivedMeetupsJSON:(NSData *)data;
- (void)fetchingMeetupsFailedWithError:(NSError *)error;
@end
