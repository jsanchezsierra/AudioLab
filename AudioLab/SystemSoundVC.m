//
//  SystemSoundVC.m
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

#import "SystemSoundVC.h"

#define SHOW_CUSTOM_MPVOLUMEVIEW YES

@implementation SystemSoundVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"System Sound", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
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
    [self setupApplicationAudio];
    
    //Declara variable
    
    for (int i=1; i<=6; i++)
       [self gradientForButton:[self valueForKey: [NSString stringWithFormat:@"_soundButton%d",i ]]];

    
    AudioServicesCreateSystemSoundID([self pathWithName:@"Sound2" andType:@"caf"], &_systemSound1);
    AudioServicesCreateSystemSoundID([self pathWithName:@"Sound2" andType:@"caf"], &_systemSound2);
    AudioServicesCreateSystemSoundID([self pathWithName:@"Sound3" andType:@"caf"], &_systemSound3);
    AudioServicesCreateSystemSoundID([self pathWithName:@"Sound4" andType:@"caf"], &_systemSound4);
    AudioServicesCreateSystemSoundID([self pathWithName:@"Sound5" andType:@"caf"], &_systemSound5);
    AudioServicesCreateSystemSoundID([self pathWithName:@"Sound6" andType:@"caf"], &_systemSound6);
    
    [self createMPVolumeView];
    
    [super viewDidLoad];
 }

-(void) createMPVolumeView
{
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame: CGRectMake(20, 350, 280, 20)];
    
    if (SHOW_CUSTOM_MPVOLUMEVIEW)
    {
        UIImage* knobImage = [UIImage imageNamed:@"mpSpeakerSliderKnob.png"];
        UIImage* volumeViewMinImage = [[UIImage imageNamed:@"volumeSliderMin.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
        UIImage* volumeViewMaxImage = [[UIImage imageNamed:@"volumeSliderMax.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
        
        [myVolumeView setVolumeThumbImage:knobImage forState:UIControlStateNormal];
        [myVolumeView setMinimumVolumeSliderImage:volumeViewMinImage forState:UIControlStateNormal];
        [myVolumeView setMaximumVolumeSliderImage:volumeViewMaxImage forState:UIControlStateNormal];
    }
    

    
    [self.view addSubview: myVolumeView];

}

 -(void) gradientForButton:(UIButton*)myButton
{
    
    myButton.layer.cornerRadius = 5.0f; 
	myButton.layer.masksToBounds = YES;
	myButton.layer.borderWidth = 1.0f; 

    CAGradientLayer *buttonGradientLayer = [CAGradientLayer layer];
    buttonGradientLayer.frame = myButton.bounds;
    buttonGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1.0] CGColor], (id)[[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0] CGColor], nil];
    [myButton.layer insertSublayer:buttonGradientLayer atIndex:0];
    
    UIImageView *buttonImageView= [[ UIImageView alloc] initWithFrame:CGRectMake(43, 10, 24, 24)];
    buttonImageView.image = [UIImage imageNamed:@"sound.png"];
    [buttonImageView setContentMode:UIViewContentModeScaleAspectFit];
    [myButton addSubview:buttonImageView];

}

-(IBAction)playSystemSound:(UIButton*)sender
{

    //AudioServicesPlaySystemSound([self valueForKey: [NSString stringWithFormat:@"_systemSound%d",[sender tag] ]]);

    if ([sender tag]==1) AudioServicesPlaySystemSound(_systemSound1);
    if ([sender tag]==2) AudioServicesPlaySystemSound(_systemSound2);
    if ([sender tag]==3) AudioServicesPlaySystemSound(_systemSound3);
    if ([sender tag]==4) AudioServicesPlaySystemSound(_systemSound4);
    if ([sender tag]==5) AudioServicesPlaySystemSound(_systemSound5);
    if ([sender tag]==6) AudioServicesPlaySystemSound(_systemSound6);
    
}

-(CFURLRef) pathWithName:(NSString*)name andType:(NSString*)type
{
    NSString *soundPath = [[NSBundle mainBundle]
                           pathForResource:name
                           ofType:type
                           inDirectory:@"/"];
    CFURLRef soundPathURL = (__bridge_retained CFURLRef)[[NSURL alloc]  initFileURLWithPath:soundPath];
    
    return soundPathURL;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

 
#pragma mark - Audio Session
- (void) setupApplicationAudio
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
	// Registers this class as the delegate of the audio session.
	[ session setDelegate: self];
	
    //[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    
    //set the playback category to the sesision
    [session setCategory: AVAudioSessionCategoryPlayback error: nil];
    
	// Registers the audio route change listener callback function
	//AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback,(__bridge void *)self);
    
	// Activates the audio session.
	NSError *activationError = nil;
	[session setActive: YES error: &activationError];
    
}

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
