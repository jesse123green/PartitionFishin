//
//  levelData.h
//  Bounce
//
//  Created by Jesse Green on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface levelData : NSObject {
    
    int numFish;
    NSMutableArray *fishPositions;
    NSMutableArray *myPaths;
    NSMutableArray *fishPaths;
    NSMutableArray *allPaths;
    NSMutableArray *arrayOfFish;

}

@property (nonatomic, assign) int numFish;
@property (nonatomic, retain) NSMutableArray *myPaths;
@property (nonatomic, retain) NSMutableArray *fishPaths;
@property (nonatomic, retain) NSMutableArray *allPaths;
@property (nonatomic, retain) NSMutableArray *arrayOfFish;

+ (id)sharedData;

@end
