//
//  AVAudioPlayerVC.m
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

#import "AVAudioPlayerVC.h"

@implementation AVAudioPlayerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AVAudio", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [self setupApplicationAudio];
    
    [self setupAudioPlayers];
    
  
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#
#pragma mark - Audio Session
- (void) setupApplicationAudio 
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
	// Registers this class as the delegate of the audio session.
	[session setDelegate: self];
	   
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];

    UInt32 mix = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(mix),&mix);
    //UInt32 duck = 1;
    //AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(duck),&duck);
    
	// Activates the audio session.
	NSError *activationError = nil;
	[session setActive: YES error: &activationError];
    
}

#pragma mark - Setup audio players
-(void) setupAudioPlayers
{
    
    NSURL *track1URL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"track1" ofType:@"mp3"]];
    
    NSURL *track2URL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"track2" ofType:@"mp3"]];
    
    track1 = [[AVAudioPlayer alloc] initWithContentsOfURL: track1URL  error: nil];
    [track1 setEnableRate:YES];
    [track1 prepareToPlay];
    [track1 setVolume: 0.5];
    [track1 setDelegate: self];
    [track1 setNumberOfLoops:-1];
    
    track2 = [[AVAudioPlayer alloc] initWithContentsOfURL: track2URL  error: nil];
    [track2 setEnableRate:YES];
    [track2 prepareToPlay];
    [track2 setVolume: 0.5];
    [track2 setDelegate: self];
    [track2 setNumberOfLoops:-1];
    
    
    [track1VolumenSlider setValue:[track1 volume]];
    [track2VolumenSlider setValue:[track2 volume]];
    
    
    //track1View Background
    track1View.layer.cornerRadius = 10.;
    track1View.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    track1View.layer.borderWidth = 2.0;
    track1View.layer.masksToBounds = YES;
    
    //track2View Background
    track2View.layer.cornerRadius = 10.;
    track2View.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    track2View.layer.borderWidth = 2.0;
    track2View.layer.masksToBounds = YES;
    
}


#pragma mark - UI Actions
-(IBAction)changeRate:(UISlider*)sender
{
    NSLog(@"rate:%f",[self convertSliderToRate:[sender value]]);
    if (sender==track1RateSlider) track1.rate=[self convertSliderToRate:[sender value]];
    if (sender==track2RateSlider) track2.rate=[self convertSliderToRate:[sender value]];
}

-(IBAction)changePan:(UISlider*)sender
{
    if (sender==track1PanSlider) track1.pan=[sender value];
    if (sender==track2PanSlider) track2.pan=[sender value];
    
}


-(float) convertSliderToRate:(float)sliderValue
{    
    if (sliderValue<=0) 
        return 1+ sliderValue/2  ;
    else        
        return 1+ sliderValue;
    
}


-(IBAction)changeVolumen:(UISlider*)sender
{
    if (sender==track1VolumenSlider) track1.volume=[sender value];
    if (sender==track2VolumenSlider) track2.volume=[sender value];
    
}
-(IBAction)playStopTrack:(UIButton*)sender
{
    
    if (sender==track1PlayPauseButton)
    {
        sender.selected = !sender.selected;

        if (sender.selected) 
        {
            [track1 play];
        }else
        {
            [track1 pause];
            
        }

    }
    if (sender==track2PlayPauseButton)  
    {
        sender.selected = !sender.selected;

        if (sender.selected) 
        {
            [track2 play];
        }else
        {
            [track2 pause];
            
        }

    }
}


#pragma mark - AVAudioPlayer interruptions

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //Update UI

}

-(void) audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    
    [player pause];
    
    //Update UI
    if (player==track1)
        [track1PlayPauseButton setSelected:NO];
    if (player==track2)
        [track2PlayPauseButton setSelected:NO];

}

-(void) audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    
    [player play];
    
    //Update UI
    if (player==track1)
        [track1PlayPauseButton setSelected:YES];
    if (player==track2)
        [track2PlayPauseButton setSelected:YES];

  
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

#pragma mark - Autorotate
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





