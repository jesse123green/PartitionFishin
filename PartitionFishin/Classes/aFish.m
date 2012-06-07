//
//  aFish.m
//  Bounce
//
//  Created by Jesse Green on 3/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "aFish.h"


@implementation aFish
@synthesize length,width,pPosition,destination,net,fishImage,speed,caught,waitCount,frontDist;


- (id)init {
	if (self == [super init]) {
        caught = 0;
        waitCount = 0;
        float multiplier = ((arc4random() % 101))/100. + 1;
        length = round(21*multiplier);
        width = round(8*multiplier);
        frontDist = round(length*.5+4);
        
        
        fishImage = [[UIImageView alloc] initWithFrame:CGRectMake((arc4random() % (320 - length)), (arc4random() % (480-width) + 479), length, width)];
        NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:2];
        
        //    for (int i = 0; i < 2; i++){
        //        [imageArray addObject:[UIImage imageNamed:
        //                               [NSString stringWithFormat:@"fish%d.png", i]]];
        //        NSLog(@"fish%d.png", i);
        //    }
        [imageArray addObject:[UIImage imageNamed:
                               [NSString stringWithFormat:@"fishright.png"]]];
        [imageArray addObject:[UIImage imageNamed:
                               [NSString stringWithFormat:@"fishleft.png"]]];
        fishImage.animationImages = [NSArray arrayWithArray:imageArray];
        [imageArray release];

        fishImage.animationRepeatCount = 0;
//        destination = CGPointMake((int)(arc4random() % (320-length))+(length*.5), (int)(arc4random() % (480 - length))+(length*.5));
        destination = CGPointMake(arc4random() % 320, arc4random() % 960);
//        destination = CGPointMake(319, arc4random() % 480);


//        NSLog(@"%f,%f",destination.x,destination.y);
        speed =(arc4random() % 3)+1;
        double angle = atan2((destination.y - fishImage.center.y),(destination.x - fishImage.center.x));
        fishImage.animationDuration = 1./(2*speed);
        CGAffineTransform rotate = CGAffineTransformMakeRotation(angle);
        [fishImage setTransform:rotate];
        [fishImage startAnimating];

        
        NSMutableArray *row = [[NSMutableArray alloc] init];
        net = [[NSMutableArray alloc] init];
        for(int i=0; i < (320); i++) [row addObject: [NSNumber numberWithInt: 0]];
        for(int i=0; i < (960); i++) [net addObject: row];
        
        [row release];
//        [net autorelease];
//        [fishImage autorelease];
        
        
        
    }
    return self;
}

@end
