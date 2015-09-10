//
//  Favorites.h
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "MeetupInfo.h"

@interface Favorites : NSObject

+ (void) loadSettings;
+ (void) saveSettings;
+ (BOOL) isFavorite:(MeetupInfo *) key;
+ (void) removeFavorite:(MeetupInfo *) key;
+ (void) addFavorite:(MeetupInfo *) key;
+ (void)setFavories:(NSArray *)favs;
+ (NSMutableArray *)getFavorites;

@end
