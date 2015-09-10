//
//  Favorites.m
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//
//

#import "Favorites.h"

static NSMutableArray *favorites;
NSString *FAVORITESKEY = @"favorites";

@implementation Favorites

+(void) initialize
{
    if (! favorites)
    	[self loadSettings];
    

}

+ (void) loadSettings {
    //retrieve settings
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
	NSString *finalPath = [path stringByAppendingPathComponent:@"favorites.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:finalPath];
    if (!success) {
        favorites = [[NSMutableArray alloc] initWithCapacity:1];
    }else {
		favorites = [NSKeyedUnarchiver unarchiveObjectWithFile:finalPath];
    }
}

+ (void)saveToFile {
    //save settings local
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
	NSString *finalPath = [path stringByAppendingPathComponent:@"favorites.plist"];
	[NSKeyedArchiver archiveRootObject:favorites toFile:finalPath];
}

+ (void) saveSettings {
    //save settings local
    [self saveToFile];
}

// check if meetup is in favorites
+ (BOOL) isFavorite:(MeetupInfo *) meetup {
    BOOL retVal = false;
	
	for (MeetupInfo *currMeetup in favorites) {
        if ([currMeetup.key isEqualToString:meetup.key]) {
            return YES;
        }
    }
    return retVal;
}

// remove a meetup
+ (void) removeFavorite:(MeetupInfo *) meetup {
	for (MeetupInfo *currMeetup in favorites) {
        if ([currMeetup.key isEqualToString:meetup.key]) {
            [favorites removeObject:currMeetup];
            return;
        }
    }
    [self saveSettings];
}

// add a meetup to favorites
+ (void) addFavorite:(MeetupInfo *) meetup {
    [favorites addObject:meetup];
    [self saveSettings];
}

+ (void)setFavories:(NSArray *)meetups {
    [favorites removeAllObjects];
    
    for (MeetupInfo *meetup in meetups) {
        [favorites addObject:meetup];
    }
    // save local
    [self saveToFile];
}

// return the favorites array.
+ (NSMutableArray *)getFavorites
{
	return favorites;
}

@end
