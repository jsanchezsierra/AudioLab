//
//  MediaPickerVC.m
//  AudioLab
//
//  Created by Javier Sanchez on 11/13/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

// AudioLab is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// AudioLab is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//https://github.com/jsanchezsierra/AudioLab

#import "MediaPickerVC.h"

@implementation MediaPickerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Music Player", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    _myPlayer =[MPMusicPlayerController applicationMusicPlayer ];  //iPodMusicPlayer

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTrackData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

    UIImageView *buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,23,23)];
    [buttonImage setContentMode:UIViewContentModeScaleAspectFit];
    buttonImage.image=[UIImage imageNamed:@"noteButton.png"];
    [_musicLibraryButton addSubview:buttonImage];
    
    
    //TrackArtWorl Background
    _trackArtwork.layer.cornerRadius = 10.;
    _trackArtwork.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _trackArtwork.layer.borderWidth = 2.0;
    _trackArtwork.layer.masksToBounds = YES;

    _playStopButton.selected =YES;

    //Volume View Control
    _volumeView= [[VolumeView alloc] initWithFrame:CGRectMake(175, 335, 110, 55 )  ];
    [_volumeView setNumberOfBars:7];
    [_volumeView setBarsColorMin:[UIColor greenColor]];
    [_volumeView setBarsColorMax:[UIColor redColor]];
    [self.view addSubview:_volumeView];

    [_volumenSwitch setOn:NO];
    [_volumeView setHidden:YES];
    
    [self setupApplicationAudio];

    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTrackTitle:nil];
    [self setTrackArtist:nil];
    [self setTrackCurrentTime:nil];
    [self setTrackTotalTime:nil];
    [self setTrackArtwork:nil];
    [self setCurrentTrackTimeSlider:nil];
    [self setCurrentTrackVolumenSlider:nil];
    [self setVolumenSwitch:nil];
    [self setPlayStopButton:nil];
    [self setMusicLibraryButton:nil];
    

}





#pragma mark - mediaPicker - popoverController for iPodLibraryAccess
- (IBAction)iPodLibraryAccess
{
    
    MPMediaPickerController *picker =[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    picker.delegate						= self;
    picker.allowsPickingMultipleItems	= YES;
    picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
    
    // Init a Navigation Controller, using the MediaPicker as its root view controller
    UINavigationController *theNavController = [[UINavigationController alloc] initWithRootViewController:picker];
    [theNavController setNavigationBarHidden:YES];
    [theNavController.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self presentModalViewController:theNavController animated:YES];
    
}


#pragma mark - mediaPicker  delegate methods

// Invoked when the user taps the Done button in the media item picker after having chosen
//		one or more media items to play.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	// D ismiss the media item picker.
	[self dismissModalViewControllerAnimated: YES];
    
    if ([mediaItemCollection count]>0) 
    {

        [_myPlayer setQueueWithItemCollection: mediaItemCollection];
        [_myPlayer play];
        [self updateTrackData];
        [_currentTrackVolumenSlider setValue:[_myPlayer volume] ];
        _playStopButton.selected =YES;


    }
    
}


// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[self dismissModalViewControllerAnimated: YES];
    
}
 

#pragma mark - update tracks
-(void) updateTrackData
{
    NSLog(@"updateTrackData");
    _myTrack= [_myPlayer nowPlayingItem];
    if (_myTrack!=nil )
    {
        [_trackTitle setText:[_myTrack valueForProperty: MPMediaItemPropertyTitle]];
        [_trackArtist setText:[_myTrack valueForProperty: MPMediaItemPropertyArtist]];
        UIImage *artworkImage= [[_myTrack valueForProperty: MPMediaItemPropertyArtwork] imageWithSize: CGSizeMake (120, 120) ];
        if (artworkImage!=nil)
            [_trackArtwork setImage:artworkImage];
        
        float currentTime=[_myPlayer currentPlaybackTime];
        NSInteger currentTimeMinutes=currentTime/60;
        NSInteger currentTimeSeconds= (NSInteger)currentTime %60;
        [_trackCurrentTime setText:[NSString stringWithFormat:@"%02d:%02d",currentTimeMinutes,currentTimeSeconds ] ];
        
        float totalTime=[[_myTrack valueForProperty: MPMediaItemPropertyPlaybackDuration] floatValue];
        NSInteger totalTimeMinutes= totalTime/60;
        NSInteger totalTimeSeconds= (NSInteger)totalTime%60;
        [_trackTotalTime setText:[NSString stringWithFormat:@"%02d:%02d",totalTimeMinutes,totalTimeSeconds ] ];
        
        float sliderTime=currentTime/totalTime;
        [_currentTrackTimeSlider setValue: sliderTime ];
        
     }

    
}

- (IBAction) changeTrackTime:(UISlider *)sender
{
    
    double currentTime= [sender value]*[[_myTrack valueForProperty: MPMediaItemPropertyPlaybackDuration] floatValue];

    [_myPlayer setCurrentPlaybackTime:currentTime   ];
    [self updateTrackData];
    
}

- (IBAction) changeTrackVolumen:(UISlider *)sender;
{
    [_myPlayer setVolume:[sender value]   ];

}

#pragma mark - UI Actions
-(IBAction)playStop:(UIButton *)sender{

    //Change selected
    if ( ([_myPlayer playbackState]== MPMusicPlaybackStatePlaying ) || ([_myPlayer playbackState]== MPMusicPlaybackStateStopped ) || ([_myPlayer playbackState]== MPMusicPlaybackStatePaused ) ) {
        sender.selected = !sender.selected;
        if (sender.selected) 
        {
            [_myPlayer play];
        }else
        {
            [_myPlayer pause];
            
        }
        
    }
}

-(IBAction)nextTrack:(UIButton *)sender{

    if ( ([_myPlayer playbackState]== MPMusicPlaybackStatePlaying ) || ([_myPlayer playbackState]== MPMusicPlaybackStateStopped ) || ([_myPlayer playbackState]== MPMusicPlaybackStatePaused ) ) 
        [_myPlayer  skipToNextItem];
}

-(IBAction)previousTrack:(UIButton *)sender{
 
    if ( ([_myPlayer playbackState]== MPMusicPlaybackStatePlaying ) || ([_myPlayer playbackState]== MPMusicPlaybackStateStopped ) || ([_myPlayer playbackState]== MPMusicPlaybackStatePaused ) ) 
        [_myPlayer skipToPreviousItem];
    
}

- (IBAction) switchChanged:(UISwitch *)sender
{
    [_volumeView showNativeVolumeControl:![sender isOn] ];
    [_volumeView setHidden:![sender isOn]];
    
}

#pragma mark - Audio Session
- (void) setupApplicationAudio
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
	// Registers this class as the delegate of the audio session.
	[ session setDelegate: self];
	    
    //set the playback category to the sesision
    [session setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    UInt32 mix = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(mix),&mix);
    //UInt32 duck = 1;
    //AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(duck),&duck);

	// Activates the audio session.
	NSError *activationError = nil;
	[session setActive: YES error: &activationError];
    
}

#pragma mark - AVAudioSession interruptions
// Called after your audio session is interrupted
-(void) beginInterruption
{
    
}

// Called after your audio session interruption ends
// flags indicate the state of the audio session
-(void) endInterruptionWithFlags:(NSUInteger)flags
{
    
}


#pragma mark - autorotate
- (BOOL)shouldAutorotate
{
    //returns true if want to allow orientation change
    return NO;
    
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //from here you Should try to Preferred orientation for ViewController
    return (UIInterfaceOrientationPortrait);
    
}
 

@end
