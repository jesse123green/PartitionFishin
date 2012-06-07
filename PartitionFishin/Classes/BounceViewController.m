//
//  BounceViewController.m
//  Bounce
//
//  Created by David Hoelzer on 3/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BounceViewController.h"
#import "levelData.h"
#import "aFish.h"

@implementation BounceViewController

@synthesize bg1,bg2,myButton;

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


//- (id)initWithFrame:(CGRect)frame {
//    if (self == [super initWithFrame:frame]) {
//        // Initialization code
//        NSLog(@"code started");
//    }
//    return self;
//}

-(void) addBGScroll:(UIView *) bg:(int)time
{
    UIViewAnimationOptions animationOptions =  UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:time
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         bg.frame = CGRectMake(0., -480., 320., 480.);
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             bg.frame = CGRectMake(0., 0., 320., 480.);
                             [self addBGScroll:bg:time];
                         }
                     }];
}

-(void)addFishes:(int)numFishToAdd{
    levelData *data = [levelData sharedData];
    for(uint i = 0; i  < numFishToAdd; i++){
        
        aFish *tempFish = [[aFish alloc] init];
        
        
        [customView addSubview:tempFish.fishImage];
        [data.arrayOfFish addObject:tempFish];
        [tempFish release];
    }
}

-(void) startGame{
    [self addFishes:4];
    [myButton removeFromSuperview];
//    UIViewAnimationOptions animationOptions =  UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction;
//    [UIView animateWithDuration:20.0
//                          delay: 0.0
//                        options: animationOptions
//                     animations:^{
//                         bg1.frame = CGRectMake(0., -480., 320., 480.);
//                     }
//                     completion:^(BOOL finished){
//                         if (finished) {
//                             bg1.frame = CGRectMake(0., 0., 320., 480.);
//                             [self addBGScroll:bg1];
//                         }
//                     }];
    [self addBGScroll:bg1:40];
    [self addBGScroll:bg2 :15];
    [NSTimer scheduledTimerWithTimeInterval:.075 target:self selector:@selector(moveScreen) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)moveScreen{
    customView.center = CGPointMake(customView.center.x, customView.center.y-1);
    if (customView.center.y < 0) {
        
        NSLog(@"shifted");
        [customView performSelector:@selector(reset)];

        customView.frame = CGRectMake(0, 0, 320, 960);
        [self addFishes:4];
    }
    
}



// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
//    self.view.frame = CGRectMake(0, 0, 320, 960);
//    CGRect  viewRect = CGRectMake(0, 10, 320, 410);
//    pathView = [[UIView alloc] initWithFrame:viewRect];
//    [pathView setBackgroundColor:[UIColor greenColor]];
//    self.view = pathView;
////    [self.view  addSubview:pathView];
//
//    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10,80,20)];
//    myLabel.text = @"testing";
//    [pathView addSubview:myLabel];
    


//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueUpebbles.jpg"]];
    
    myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(0, 0, 70, 37);
    [myButton setTitle:@"Start!" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIImageView *chest = [[UIImageView alloc] initWithFrame:CGRectMake(220, 0, 100, 100)];
//    chest.image  = [UIImage imageNamed:[NSString stringWithFormat:@"treasure_chest.png"]];
//    [self.view addSubview:chest];
    

    


    
	

    bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 960)];
    bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 960)];
    UIImageView *startBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    startBG.image = [UIImage imageNamed:[NSString stringWithFormat:@"gradbg.jpg"]];
    UIImageView *startBG2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 480, 320, 480)];
    startBG2.image = [UIImage imageNamed:[NSString stringWithFormat:@"gradbg.jpg"]];
    
    [bg1 addSubview:startBG];
    [bg1 addSubview:startBG2];
    [self.view addSubview:bg1];
    [startBG release];
    [startBG2 release];
    
    CGRect  viewRect = CGRectMake(0, 0, 320, 960);
    customView = [[CustomView alloc] initWithFrame:viewRect];
    UIImageView *netedge = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 480)];
    netedge.image = [UIImage imageNamed:[NSString stringWithFormat:@"netedge.png"]];
    UIImageView *netedge2 = [[UIImageView alloc] initWithFrame:CGRectMake(289, 0, 31, 480)];
    netedge2.image = [UIImage imageNamed:[NSString stringWithFormat:@"netedge.png"]];
    UIImageView *netedge3 = [[UIImageView alloc] initWithFrame:CGRectMake(289, 480, 31, 480)];
    netedge3.image = [UIImage imageNamed:[NSString stringWithFormat:@"netedge.png"]];
    UIImageView *netedge4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 480, 31, 480)];
    netedge4.image = [UIImage imageNamed:[NSString stringWithFormat:@"netedge.png"]];
    
    [bg2 addSubview:netedge];
    [bg2 addSubview:netedge2];
    [bg2 addSubview:netedge3];
    [bg2 addSubview:netedge4];
    
    [netedge release];
    [netedge2 release];
    [netedge3 release];
    [netedge4 release];
    
    [self.view addSubview:customView];
    [self.view addSubview:myButton];
    

    [self.view addSubview:bg2];
        
    

    
    
}




    

-(void)onTimer {

    
//    bg1.center = CGPointMake(bg1.center.x, bg1.center.y-5);
//    bg2.center = CGPointMake(bg2.center.x, bg2.center.y-5);
    

    if (arc4random() % 30 == 0) {
//        NSLog(@"Frame posish: %f",bg1.center.y);
    UIImageView *bubble = [[UIImageView alloc] initWithFrame:CGRectMake((arc4random() % (300)), (arc4random() % (460)), 5, 5)];
    bubble.image  = [UIImage imageNamed:[NSString stringWithFormat:@"bubble.png"]];
        
    
    [self.view addSubview:bubble];

    float sc = ((arc4random() % 250)+100)/100.;
    CGAffineTransform toScale = CGAffineTransformMakeScale(sc,sc);
    CGAffineTransform toTranslate = CGAffineTransformMakeTranslation(arc4random() % (41)-20., -bubble.center.y-5);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:bubble];
    [UIView setAnimationDuration:.01f*bubble.center.y];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    bubble.transform = CGAffineTransformConcat(toScale, toTranslate);
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
    [bubble autorelease];
        
//    [UIView animateWithDuration:1.2
//                        animations:^{
//                            bubble.bounds = CGRectMake(bubble.center.x, bubble.center.y, 20, 20);
//                            bubble.center = CGPointMake(bubble.center.x + arc4random() % 21 - 10, bubble.center.y + arc4random() % 21 - 10);
//                            }
//                        completion:^(BOOL finished){ [bubble removeFromSuperview]; }];    
        

    }
    
    
    
    
    
    levelData *data = [levelData sharedData];

    int i;
    
	for (i=0; i<[data.arrayOfFish count]; i++) {
        
        aFish *thisFish = [data.arrayOfFish objectAtIndex:i];

        if (thisFish.waitCount > 1) {
            thisFish.waitCount--;
            continue;
        }


//        NSLog(@"final loc %i,%f,%f",i,finalLoc.x,finalLoc.y);
//        NSLog(@"locations %i,%f,%f",i,myImageView.center.x,myImageView.center.y);
//        NSLog(@"in");
//        NSLog(@"%d",thisFish.length);

        double angle = atan2((thisFish.destination.y - thisFish.fishImage.center.y),(thisFish.destination.x - thisFish.fishImage.center.x));
//        NSLog(@"%f",angle);
        int inside = 1;
        int outside = 0;
        
        
        if (thisFish.caught){
            
            
            if (thisFish.waitCount == 1) {
                thisFish.waitCount--;
            }
            else{
//                NSLog(@"%f %f",thisFish.fishImage.center.x,thisFish.fishImage.center.y);
//                NSLog(@"fishedge: %f %f",round(thisFish.length*.5*cos(angle)+thisFish.fishImage.center.x),round(thisFish.length*.5*sin(angle)+thisFish.fishImage.center.y));
                inside = [((NSNumber*)[[thisFish.net objectAtIndex:round(thisFish.frontDist*sin(angle)+thisFish.fishImage.center.y)] objectAtIndex:round(thisFish.frontDist*cos(angle)+thisFish.fishImage.center.x)]) intValue];
//            NSLog(@"in for some reason,%d",inside);
            }
            
        }
        else {
            if (thisFish.waitCount == 1) {
                thisFish.waitCount--;
            }
            else{
            outside = [((NSNumber*)[[data.allPaths objectAtIndex:round(thisFish.frontDist*sin(angle)+thisFish.fishImage.center.y)] objectAtIndex:round(thisFish.frontDist*cos(angle)+thisFish.fishImage.center.x)]) intValue];
            }
        }
        
        if (inside == 0){
//            NSLog(@"outside");
//            thisFish.destination = CGPointMake(round(thisFish.fishImage.center.x-10*thisFish.speed*cos(angle)), round(thisFish.fishImage.center.y-10*thisFish.speed*sin(angle)));
//            angle = atan2((thisFish.destination.y - thisFish.fishImage.center.y),(thisFish.destination.x - thisFish.fishImage.center.x));
            thisFish.destination = thisFish.pPosition;
            angle = atan2(thisFish.destination.y-thisFish.fishImage.center.y,thisFish.destination.x - thisFish.fishImage.center.x);
            thisFish.waitCount = 10;
//            NSLog(@"angle %f",angle);
        }
        else if (outside == 1){
            
            thisFish.destination = CGPointMake(round(thisFish.fishImage.center.x-thisFish.speed*cos(angle)), round(thisFish.fishImage.center.y-thisFish.speed*sin(angle)));
            angle = atan2((thisFish.destination.y - thisFish.fishImage.center.y),(thisFish.destination.x - thisFish.fishImage.center.x));
            thisFish.waitCount = 3;
        }
        else if (sqrt(pow(thisFish.destination.x - thisFish.fishImage.center.x,2.0) + pow(thisFish.destination.y - thisFish.fishImage.center.y,2.0)) < thisFish.frontDist+3){
            
//            NSLog(@"reached destination %i",i);
            
//            thisFish.destination = CGPointMake((int)(arc4random() % (320-thisFish.length))+(thisFish.length*.5), (int)(arc4random() % (480 - thisFish.length))+(thisFish.length*.5));
            thisFish.destination = CGPointMake(arc4random() % 320, arc4random() % 960);
//            NSLog(@"%f,%f",thisFish.destination.x,thisFish.destination.y);
            thisFish.speed = (arc4random() % 3)+1;
            thisFish.fishImage.animationDuration = .5/(thisFish.speed);
            [thisFish.fishImage startAnimating];
            angle = atan2((thisFish.destination.y - thisFish.fishImage.center.y),(thisFish.destination.x - thisFish.fishImage.center.x));
            CGAffineTransform rotate = CGAffineTransformMakeRotation(angle);
            [UIImageView beginAnimations:nil context:nil];
            [UIImageView setAnimationDelegate:self];
            [UIImageView setAnimationDuration:.25f];
//            NSLog(@"%f",.4/(thisFish.speed));
            [UIImageView setAnimationCurve:UIViewAnimationCurveEaseOut];
            thisFish.fishImage.transform = rotate;
//            [myImageView setTransform:rotate];
            [UIImageView commitAnimations];
            
        }
        
		
//        NSLog(@"locations %i,%f,%f",i,myImageView.center.x,myImageView.center.y);
        thisFish.pPosition = thisFish.fishImage.center;
		thisFish.fishImage.center = CGPointMake(thisFish.fishImage.center.x+round(thisFish.speed*cos(angle)), thisFish.fishImage.center.y+round(thisFish.speed*sin(angle)));
//        NSLog(@"fishcenter: %f %f",thisFish.fishImage.center.x,thisFish.fishImage.center.y);
		[data.arrayOfFish replaceObjectAtIndex:i withObject:thisFish];
        
        
        
	}
//    [thisFish release];

}








- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    NSLog(@"WARNING!!!! WARNING!!!!");
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [CustomView autorelease];
    [super dealloc];
}

@end
