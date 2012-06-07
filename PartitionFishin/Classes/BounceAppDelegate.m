//
//  BounceAppDelegate.m
//  Bounce
//
//  Created by David Hoelzer on 3/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BounceAppDelegate.h"
#import "BounceViewController.h"

@implementation BounceAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
