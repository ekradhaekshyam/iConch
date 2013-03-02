//
//  ViewController.m
//  iConch
//
//  Created by Omkar on 02/03/13.
//  Copyright (c) 2013 Omkar Nisal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
	NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
    
	NSError *error;
    
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
	if (recorder) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
		levelTimer = [NSTimer scheduledTimerWithTimeInterval: .03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
	} else
        NSLog(@" error -- ");
    //		NSLog([error description]);
}


- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    lowPassResults = 1;
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
	
    
    
	if (lowPassResults > 0.956)
    {
        
        //        NSLog(@"Mic blow Detected ");
		NSLog(@" BLOW!!!!! %f ",lowPassResults);
        [self playSound];
    }
    
    
    
    
    
}

-(void) playSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Glass" ofType:@"aiff"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //[soundPath release];
}


- (void)dealloc {
 
}

@end
