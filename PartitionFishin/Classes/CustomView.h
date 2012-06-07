//
//  CustomView.h
//  PathAnimation
//
//  Created by Dominique d'Argent on 19.04.11.
//  Copyright 2011 Nicky Nubbel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BounceViewController.h"


@interface CustomView : UIView {

    CGMutablePathRef path;
    CGMutablePathRef writingPath;
    NSMutableArray *segments;
    NSMutableArray *myPaths;
    int numPath;
    BOOL upDown;
    BOOL nearEdge;
    CGPoint position;
    CGPoint lastPosition;
    CGPoint firstPosition;
    NSMutableArray *justZeros;

}


- (void)createPath;
- (void)reset;


@property(nonatomic,assign) CGMutablePathRef path;
@property(nonatomic,assign) BOOL nearEdge;
@property(nonatomic,assign) CGMutablePathRef writingPath;
@property(nonatomic,retain) NSMutableArray *justZeros;
@end
