//
//  CustomView.m
//  PathAnimation
//
//  Created by Dominique d'Argent on 19.04.11.
//  Copyright 2011 Nicky Nubbel. All rights reserved.
//

#import "CustomView.h"
#import "levelData.h"
#import "aFish.h"



@implementation CustomView

@synthesize path,writingPath,justZeros,nearEdge;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    segments = [[NSMutableArray alloc] init];
    myPaths = [[NSMutableArray alloc] init];
    justZeros = [[NSMutableArray alloc] init];
    writingPath = CGPathCreateMutable();
    nearEdge = 0;
    [self setBackgroundColor:[UIColor clearColor]];
    for(int i=0; i < (320); i++) [justZeros addObject: [NSNumber numberWithInt: 0]];
    NSLog(@"size of just zeros %d",[justZeros count]);
    
    return self;
}


- (void)dealloc
{
    
    [super dealloc];
}

#pragma mark - Custom drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef g = UIGraphicsGetCurrentContext();
//    CGFloat bgColor[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    CGContextClearRect(g, rect);
//    CGContextSetFillColor(g, bgColor);
//    CGContextFillRect(g, self.frame);
    CGFloat color[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(g, color);
    
    [[UIColor colorWithPatternImage:[UIImage imageNamed:@"fish-net.png"]] setStroke];
//    [[UIColor blackColor] setStroke];
    
    for ( UIBezierPath * bpath in myPaths ) {
        bpath.lineWidth = 15;
        //[bpath fill];
        [bpath stroke];
    }
    
    CGContextAddPath(g,path);

    
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(g, kCGPathStroke);
    
//    position = CGPathGetCurrentPoint(path);
//    CGContextAddArc(g, position.x, position.y, 5.0f, 0.0f, 2 * M_PI, 0);
//    CGContextSetFillColor(g, color);
    CGContextDrawPath(g, kCGPathFill);
    
}


-(void)reset{
    levelData *data = [levelData sharedData];
    NSMutableIndexSet *pathToDelete = [[NSMutableIndexSet alloc] init];
    for ( int i=0; i<[myPaths count]; i++) {
        UIBezierPath * bpath = [myPaths objectAtIndex:i];
//        pathBound = CGPathGetBoundingBox(bpath.CGPath);
        
        NSLog(@"path bound: %f",bpath.bounds.origin.y + bpath.bounds.size.height);
        if (bpath.bounds.origin.y + bpath.bounds.size.height < 480) {
            [pathToDelete addIndex:i];
        }
        else{
            [bpath applyTransform:CGAffineTransformMakeTranslation(0., -480.)];
        }

    }
    
    NSMutableIndexSet *fishToDelete = [[NSMutableIndexSet alloc] init];
    for (int i=0; i<[data.arrayOfFish count]; i++) {
        
        aFish *thisFish = [data.arrayOfFish objectAtIndex:i];
        thisFish.fishImage.center = CGPointMake(thisFish.fishImage.center.x, thisFish.fishImage.center.y - 480);
        thisFish.destination = CGPointMake(thisFish.destination.x,thisFish.destination.y - 480);
        if (thisFish.fishImage.center.y < -thisFish.frontDist) {
            [thisFish.fishImage removeFromSuperview];
            [fishToDelete addIndex:i];
        }

    }
    [self performSelectorInBackground:@selector(removeFish:) withObject:(fishToDelete)];
    [self performSelectorInBackground:@selector(removePath:) withObject:(pathToDelete)];
    [self setNeedsDisplay];
    [fishToDelete release];
    [pathToDelete release];
}

-(void)removeFish:(NSIndexSet *)fish{
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    levelData *data = [levelData sharedData];
    
    [data.arrayOfFish removeObjectsAtIndexes:fish];
    NSLog(@"data.arrayOfFish size: %d",[data.arrayOfFish count]);
    [apool release];
}

-(void)removePath:(NSIndexSet *)aPath{
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    [myPaths removeObjectsAtIndexes:aPath];

    [apool release];
}


#pragma mark - Path creation
- (void)createPath {
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, position.x, position.y);
}


- (void)checkIntersection{
    
    CGPathAddLineToPoint(path, NULL, position.x, position.y);
    
    [self setNeedsDisplay];
    /*
    for (int i=0; i < ([segments count] - 2); i++) {
        NSValue *val1 = [segments objectAtIndex:(i)];
        CGPoint p1 = [val1 CGPointValue];
        if( abs(position.x - p1.x) < 2 || abs(position.y - p1.y) < 2){
            
            NSLog(@"Intersection!!!!!!")
        }
        
    }
    */
    int numSegs = [segments count];
    if (numSegs < 3)
        return;
    for (int i=0; i < (numSegs - 3); i++) {//([segments count] - 1)
        //NSLog(@"IN HERE");
        int crossing = 0;
        int parallel = 0;



        NSValue *val1 = [segments objectAtIndex:(i)];
        NSValue *val2 = [segments objectAtIndex:(i+1)];

        
        CGPoint p11 = [val1 CGPointValue];
        CGPoint p12t = [val2 CGPointValue];
        
        CGPoint p12;
        p12.x = p12t.x - p11.x;
        p12.y = p12t.y - p11.y;
        

        
        
        //NSLog(@"i = %d, u = %f, t=%f",i,u,t);
        
        if (p12t.x == p11.x || position.y == lastPosition.y) {
            parallel = 1;
            if((lastPosition.y >= p12t.y && lastPosition.y <= p11.y) || (lastPosition.y <= p12t.y && lastPosition.y >= p11.y)){
                if ((p11.x >= lastPosition.x && p11.x <= position.x) || (p11.x <= lastPosition.x && p11.x >= position.x)) { 
                        NSLog(@"parallel crossing");
                    crossing = 1;
                }
            }
        }
        if (p12t.y == p11.y || position.x == lastPosition.x) {
            parallel = 1;
            if((lastPosition.x >= p12t.x && lastPosition.x <= p11.x) || (lastPosition.x <= p12t.x && lastPosition.x >= p11.x)){
                if ((p11.y >= lastPosition.y && p11.y <= position.y) || (p11.y <= lastPosition.y && p11.y >= position.y)) { 
                    NSLog(@"parallel crossing");
                    crossing = 1;
                }
            }
        }
        
        if (parallel == 0) {
            float t = 0;
            float u = 0;
            
            
            
            CGPoint p22 = CGPointMake(position.x - lastPosition.x, position.y - lastPosition.y);
            
            
            t = (((lastPosition.x - p11.x)*p22.y - (lastPosition.y - p11.y)*p22.x)/(p12.x*p22.y - p12.y*p22.x));
            u = (((lastPosition.x - p11.x)*p12.y - (lastPosition.y - p11.y)*p12.x)/(p12.x*p22.y - p12.y*p22.x));
        

            if((t < 1.0f && t > 0.0f && u < 1.0f && u > 0.0f) || (position.x == p11.x && position.y == p11.y)) {//0<t<1 && 0<u<1
            //NSLog(@"Intersection on %d", i);
                crossing = 1;

            }
        }
        
        if (crossing == 1) {
            NSLog(@"start");
            CGMutablePathRef trimPath = CGPathCreateMutable();
            int flag = 0;
            p12.x = p12.x + p11.x;
            p12.y = p12.y + p11.y;
            
            for (int i=0; i < ([segments count] - 1); i++) {
                NSValue *checkval = [segments objectAtIndex:(i)];
                CGPoint pcheck = [checkval CGPointValue];
                if (flag == 1) {
                    CGPathAddLineToPoint (
                                          trimPath,
                                          NULL,
                                          pcheck.x,
                                          pcheck.y
                                          );
                }
                if (p12.x == pcheck.x && p12.y == pcheck.y) {
                    flag = 1;
                    CGPathMoveToPoint(trimPath, NULL, pcheck.x, pcheck.y);
                }
            }
            
            CGPathCloseSubpath (trimPath);
            [myPaths addObject:[UIBezierPath bezierPathWithCGPath:trimPath]];
            NSLog(@"Number of current paths: %d",[myPaths count]);
            writingPath = CGPathCreateMutableCopy(trimPath);
            levelData *data = [levelData sharedData];
            [data.myPaths addObject:[UIBezierPath bezierPathWithCGPath:trimPath]];
            [self performSelectorInBackground:@selector(fillOnePath) withObject:nil];
            for (int i=0; i < [data.arrayOfFish count]; i++) {
                aFish *thisFish = [data.arrayOfFish objectAtIndex:i];
                if (CGPathContainsPoint(trimPath, nil, CGPointMake(thisFish.fishImage.center.x,thisFish.fishImage.center.y), false)){
                    
                    NSLog(@"caught a fish!");
                    thisFish.caught = 1;
                    [self performSelectorInBackground:@selector(fillAllPaths:) withObject:thisFish];
                    [data.arrayOfFish replaceObjectAtIndex:i withObject:thisFish];
                }
            }
            
//            int testit[480][320];
//            for (int i=0; i < 480; i++) {
//                for (int j=0; j < 320; j++) {
//                    
//                    if (CGPathContainsPoint(trimPath, nil, CGPointMake(j, i), false)) {
//                        testit[i][j] = 1;
//                    }
//                    
//                }}
            
            
            
//            NSArray* foo = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:bounding.origin.x], [NSNumber numberWithInt:bounding.origin.y],[NSNumber numberWithInt:bounding.size.width],[NSNumber numberWithInt:bounding.size.height], nil];
            
            
            

            
            

            NSLog(@"finished");
            numPath++;
            
            //[self createPath];
            upDown = 0;
            break;
        }    
    }

    
}
- (void)fillOnePath{
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    levelData *data = [levelData sharedData];
    
    CGRect bounding = CGPathGetPathBoundingBox (writingPath);
    NSLog(@"%d",MAX((int)bounding.origin.y, 0));
    for (int i=MAX((int)bounding.origin.y,0); i < MIN((int)(bounding.origin.y+bounding.size.height),959); i++) {
        NSMutableArray * temp = [[NSMutableArray alloc] initWithArray:[data.allPaths objectAtIndex:i]];
        for (int j=MAX((int)bounding.origin.x,0); j < MIN((int)(bounding.origin.x + bounding.size.width),319); j++) {
//            NSLog(@"%d",j);
            if (CGPathContainsPoint(writingPath, nil, CGPointMake(j, i), false)) {
                [temp replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:1]];
                
            }
        }
        
        [data.allPaths replaceObjectAtIndex:i withObject:temp];
        
        
    }
    
    [apool release];
}
- (void)fillAllPaths:(aFish*)thisFish{
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
//    levelData *data = [levelData sharedData];
//    int x = 0;
    

//    NSLog(@"array: %@",temp);
//    [temp replaceObjectsInRange:NSMakeRange(0, 319) withObjectsFromArray:[data.allPaths objectAtIndex:1]];
    
//    NSLog(@"array: %@",temp);

    CGRect bounding = CGPathGetPathBoundingBox (writingPath);
    for (int i=MAX((int)bounding.origin.y,0); i < MIN((int)(bounding.origin.y+bounding.size.height),959); i++) {
//        NSMutableArray * temp = [[NSMutableArray alloc] initWithArray:[data.allPaths objectAtIndex:i]];
        NSMutableArray * temp2 = [[NSMutableArray alloc] initWithArray:justZeros];
//        [temp replaceObjectsInRange:NSMakeRange(0, 320) withObjectsFromArray:[data.allPaths objectAtIndex:i]];
        for (int j=MAX((int)bounding.origin.x,0); j < MIN((int)(bounding.origin.x + bounding.size.width),319); j++) {
            if (CGPathContainsPoint(writingPath, nil, CGPointMake(j, i), false)) {
//                [temp replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:1]];
                [temp2 replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:1]];
                
//                x++;
            }
        }
        
//        [data.allPaths replaceObjectAtIndex:i withObject:temp];
        [thisFish.net replaceObjectAtIndex:i withObject:temp2];
        
        
    }
//    NSLog(@"The content of arry is%@",data.allPaths);


    [apool release];
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    upDown = 1;
    UITouch *touch   = [touches anyObject];
    position = [touch locationInView:self];
    path = CGPathCreateMutable();
    


    if(position.x > 313){
        
        position = CGPointMake(320, position.y);
        [segments addObject:[NSValue valueWithCGPoint:position]];
        nearEdge = 1;
        
        
    }
    else if(position.x < 7){
        position = CGPointMake(0, position.y);
        [segments addObject:[NSValue valueWithCGPoint:position]];
        nearEdge = 1;
    }
    
//    else if(position.y < 7){
//        position = CGPointMake(position.x, 0);
//        [segments addObject:[NSValue valueWithCGPoint:position]];
//        nearEdge = 1;
//    }
//    
//    else if(position.y > 473){
//        position = CGPointMake(position.x, 480);
//        [segments addObject:[NSValue valueWithCGPoint:position]];
//        nearEdge = 1;
//    }
    firstPosition = position;
    CGPathMoveToPoint(path, NULL, position.x, position.y);
    [segments addObject:[NSValue valueWithCGPoint:position]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (upDown) {
    
    UITouch *touch   = [touches anyObject];
    position = [touch locationInView:self];
    lastPosition = CGPathGetCurrentPoint(path);
    //only add to array if minimum movement of two pixels
        if ((abs(lastPosition.x - position.x) + abs(lastPosition.y - position.y)) > 1) {
            [segments addObject:[NSValue valueWithCGPoint:position]];
            [self checkIntersection];
        }

    

    
    }
    
    


}

- (void) finishPath{
//    levelData *data = [levelData sharedData];
    [segments addObject:[NSValue valueWithCGPoint:position]];
    CGPathAddLineToPoint(path, NULL, position.x, position.y);
    [myPaths addObject:[UIBezierPath bezierPathWithCGPath:path]];

    
//    if (firstPosition.x == position.x || firstPosition.y == position.y) {
//        CGPathCloseSubpath(path);
//    }
//    
//    [myPaths addObject:[UIBezierPath bezierPathWithCGPath:path]];
//    for (int i=0; i < data.numFish; i++) {
//        aFish *thisFish = [data.arrayOfFish objectAtIndex:i];
//        if (CGPathContainsPoint(path, nil, CGPointMake(thisFish.fishImage.center.x,thisFish.fishImage.center.y), false)){
////            
////            NSLog(@"caught a fish!");
////            thisFish.caught = 1;
////            [self performSelectorInBackground:@selector(fillAllPaths:) withObject:thisFish];
////            [data.arrayOfFish replaceObjectAtIndex:i withObject:thisFish];
//        }
//        else [self performSelectorInBackground:@selector(fillOnePath:) withObject:thisFish];
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint endPosition = [touch locationInView:self];
    if (nearEdge) {

        if(endPosition.x > 313){
            position = CGPointMake(320, endPosition.y);
            [self finishPath];
            
        }
        else if(endPosition.x < 7){
            position = CGPointMake(0, endPosition.y);
            [self finishPath];
        }
        
//        else if(endPosition.y < 7){
//            position = CGPointMake(endPosition.x, 0);
//            [self finishPath];
//        }
//        
//        else if(endPosition.y > 473){
//            position = CGPointMake(endPosition.x, 480);
//            [self finishPath];
//        }
        
        
    }
    nearEdge = 0;
    [segments removeAllObjects];
    CGPathRelease(path);
    path = CGPathCreateMutable();
    [self setNeedsDisplay];
//    NSLog(@"finger raised");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}



//#pragma mark - Animations
//
//- (void) go {
//    NSLog(@"go");
//    
//    object.layer.transform = CATransform3DIdentity;
//    
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
//    animation.path = path;
//    animation.duration = 5.0;
//    animation.rotationMode = kCAAnimationRotateAuto; // object auto rotates to follow the path
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    
//    [object.layer addAnimation:animation forKey:@"position"];
//    object.center = CGPathGetCurrentPoint(path);
//    
//    [self createPath];
//}

@end
