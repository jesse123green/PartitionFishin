//
//  aFish.h
//  Bounce
//
//  Created by Jesse Green on 3/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface aFish : NSObject {
    CGPoint pPosition;
    CGPoint destination;
    int length;
    int width;
    int speed;
    NSMutableArray *net;
    UIImageView *fishImage;
    BOOL caught;
    int waitCount;
    int frontDist;
    
    
}

@property(nonatomic,retain) NSMutableArray *net;
@property(nonatomic,retain) UIImageView *fishImage;
@property(nonatomic,assign) int length;
@property(nonatomic,assign) int frontDist;
@property(nonatomic,assign) int width;
@property(nonatomic,assign) int speed;
@property(nonatomic,assign) int waitCount;
@property(nonatomic,assign) CGPoint pPosition;
@property(nonatomic,assign) CGPoint destination;
@property(nonatomic,assign) BOOL caught;


@end
