//
//  ViewController.m
//  iConch
//
//  Created by Omkar on 02/03/13.
//  Copyright (c) 2013 Omkar Nisal. All rights reserved.
//  Inspiration: https://github.com/dcgrigsby/MicBlow

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize playingtimeCount;
@synthesize isPlaying;
@synthesize PlayerTimer;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPlaying= FALSE;
    self.playingtimeCount =0;
    lowPassResults = 1;
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
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
   if (lowPassResults > 0.55)
    {
        if (!self.isPlaying) {
            self.isPlaying = TRUE;
            [self startConchSound];
            NSLog(@" Start");
//           self.PlayerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(changeCounterValue) userInfo: nil repeats: NO];

        }
        else{
        //        NSLog(@"Mic blow Detected ");
            if (self.playingtimeCount>8) {
                self.playingtimeCount = 0;
                [self waveplaySound];
                NSLog(@" Wave ");
            }
            else{
                [self playSound];
                NSLog(@" Constant ");
            }
        }
        self.playingtimeCount ++;
    }
    else if (self.isPlaying)
    {
        self.isPlaying = FALSE;
        [self finishConchSound];
        NSLog(@" Fisish");
//        [self.PlayerTimer invalidate];
        self.playingtimeCount = 0;
    }
   
    
}
-(void)changeCounterValue
{
    self.playingtimeCount ++;
}
-(void) startConchSound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"start1" ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    NSString *soundPath1 = [[NSBundle mainBundle] pathForResource:@"start1_2" ofType:@"mp3"];
    SystemSoundID soundID1;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath1], &soundID1);
    AudioServicesPlaySystemSound (soundID1);
}

-(void) finishConchSound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"abouTofinish" ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    
    NSString *soundPath1 = [[NSBundle mainBundle] pathForResource:@"Finish" ofType:@"mp3"];
    SystemSoundID soundID1;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath1], &soundID1);
    AudioServicesPlaySystemSound (soundID1);
}
-(void) playSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"constant" ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //[soundPath release];
}
-(void) waveplaySound {

    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"wave" ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //[soundPath release];
}



- (void)dealloc {
 
}

@end
