//
//  levelData.m
//  Bounce
//
//  Created by Jesse Green on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "levelData.h"


@implementation levelData

@synthesize numFish,myPaths,fishPaths,allPaths,arrayOfFish;
static levelData *sharedMyManager = nil;


#pragma mark Singleton Methods
+ (id)sharedData {
	@synchronized(self) {
		if(sharedMyManager == nil)
			[[self alloc] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedMyManager == nil)  {
			sharedMyManager = [super allocWithZone:zone];
			return sharedMyManager;
		}
	}
	return nil;
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}
- (void)release {
	// never release
}
- (id)autorelease {
	return self;
}
- (id)init {
	if (self == [super init]) {
		
        numFish = 4;
        fishPaths = [[NSMutableArray alloc] init];
        for (int i =0; i < numFish; i++) {
            [fishPaths addObject: [NSNumber numberWithInt:-1]];
        }
        NSMutableArray *row = [[NSMutableArray alloc] init];
        allPaths = [[NSMutableArray alloc] init];
        for(int i=0; i < (320); i++) [row addObject: [NSNumber numberWithInt: 0]];
        for(int i=0; i < (960); i++) [allPaths addObject: row];
        
        arrayOfFish = [[NSMutableArray alloc] init];
        
        
        
    }
    return self;
}

- (void)dealloc {
	// Should never be called, but just here for clarity really.

	[super dealloc];
}



@end
