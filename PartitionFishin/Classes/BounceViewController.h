//
//  BounceViewController.h
//  Bounce
//
//  Created by David Hoelzer on 3/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomView.h"

@interface BounceViewController : UIViewController {




//    NSMutableArray *imageArray;

    UIView *bg1;
    UIView *bg2;
    UIButton *myButton;
    UIView *customView;
    
    


}


@property (nonatomic,retain) UIView *bg1;
@property (nonatomic,retain) UIView *bg2;
@property (nonatomic,retain) UIButton *myButton;

@end

