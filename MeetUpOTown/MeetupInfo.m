//
//  MeetupInfo.m
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "MeetupInfo.h"

@implementation MeetupInfo
@synthesize name, time, group, description, key;

// Decode the property values by key, and assign them to the correct variables
- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super init]))
    {
		name = [coder decodeObjectForKey:@"name"];
		time = [coder decodeObjectForKey:@"time"];
		group = [coder decodeObjectForKey:@"group"];
		description = [coder decodeObjectForKey:@"description"];
		key = [coder decodeObjectForKey:@"key"];
    }
    return self;
}

// Encode the variables using string keys
- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:time forKey:@"time"];
	[coder encodeObject:group forKey:@"group"];
	[coder encodeObject:description forKey:@"description"];
	[coder encodeObject:key forKey:@"key"];
}

@end
