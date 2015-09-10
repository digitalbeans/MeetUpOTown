//
//  MeetupDownload.m
//  MeetUpOTown
//
//  Created by Dean Thibault on 8/27/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "MeetupDownload.h"
#import "MeetupInfo.h"


// You need to create your own api key, here: https://secure.meetup.com/meetup_api/key/
// and specify it here:
#define API_KEY @"1f5f2c641f6136425c53536f4223257"

@implementation MeetupDownload
//@synthesize meetupArray;
@synthesize pageOffset;

// Process the request for meetup info from meetup.com. Called externally.
- (void) searchMeetupsInCity:(NSString *)city andState:(NSString *)state offset:(NSInteger) offset
{
	// Generate the url for the request. City and state are variable based on input parameters.
	// JSON format, plain description text, order, and country are hard coded.
	self.pageOffset = offset;
	NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/open_events?format=json&text_format=plain&order=time&country=us&city=%@&state=%@&time=,1m&page=20&offset=%d&key=%@", city, state, (int)pageOffset, API_KEY];
	NSLog(@"URL: %@", urlString);
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	
	// Create the request.
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	// Send the request asynchronously, callback block will be executed on completion.
	[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			if (connectionError) {
				[self fetchingMeetupsFailedWithError:connectionError];
    		} else {
				[self receivedMeetupsJSON:data];
			}

	}];
}

// Called on successfull completion of the request.
- (void)receivedMeetupsJSON:(NSData *)data
{
	NSError *error = nil;
	NSDictionary *meetupInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	NSArray *meetupsArray = [meetupInfo objectForKey:@"results"];
	NSMutableArray *meetups = [NSMutableArray array];
	
	// Create MeetupInfo object for each meetup in the data
	for (NSDictionary *event in meetupsArray) {
		MeetupInfo *meetup = [[MeetupInfo alloc] init];
		meetup.name = [event objectForKey:@"name"];
		meetup.time = [event objectForKey:@"time"];
		NSDictionary *group = [event objectForKey:@"group"];
		meetup.group = [group objectForKey:@"name"];
		meetup.description = [event objectForKey:@"description"];
		meetup.key = [event objectForKey:@"id"];
		
		[meetups addObject:meetup];
	}
	// call the MeetupDelegate to inform of successful completion
	if (meetups.count > 0) {
		// pass the retrieved meetup array.
    	[self.delegate didReceiveMeetups:meetups];
	}
}

// Called on request failure.
- (void)fetchingMeetupsFailedWithError:(NSError *)error
{
	NSLog(@"Error: %@", error.localizedDescription);
	// inform the delegate of failed request.
	[self.delegate fetchingMeetupsFailedWithError:error];
}


@end
