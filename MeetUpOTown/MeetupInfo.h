//
//  MeetupInfo.h
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetupInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *time;
@property (strong, nonatomic) NSString *group;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *key;

@end
