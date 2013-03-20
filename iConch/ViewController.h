//
//  ViewController.h
//  iConch
//
//  Created by Omkar on 02/03/13.
//  Copyright (c) 2013 Omkar Nisal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>



@interface ViewController : UIViewController {
	AVAudioRecorder *recorder;
	NSTimer *levelTimer;
	double lowPassResults;
    BOOL isPlaying;
    NSInteger playingtimeCount;
    NSTimer *PlayerTimer;
}
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign)    NSInteger playingtimeCount;
@property (nonatomic, retain) NSTimer *PlayerTimer;
- (void)levelTimerCallback:(NSTimer *)timer;
-(void) waveplaySound ;
-(void) finishConchSound;
-(void) startConchSound;

@end
