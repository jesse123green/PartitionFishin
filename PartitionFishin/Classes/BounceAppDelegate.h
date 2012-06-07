//
//  BounceAppDelegate.h
//  Bounce
//
//  Created by David Hoelzer on 3/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BounceViewController;

@interface BounceAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BounceViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BounceViewController *viewController;

@end

