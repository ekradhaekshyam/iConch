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
}

- (void)levelTimerCallback:(NSTimer *)timer;


@end
