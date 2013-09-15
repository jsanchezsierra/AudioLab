//
//  AVAudioPlayerVC.h
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface AVAudioPlayerVC : UIViewController <AVAudioPlayerDelegate, AVAudioSessionDelegate>
{
    AVAudioPlayer	*track1;
	AVAudioPlayer	*track2;
    
    IBOutlet UISlider *track1RateSlider;
    IBOutlet UISlider *track1VolumenSlider;
    IBOutlet UISlider *track1PanSlider;

    IBOutlet UISlider *track2RateSlider;
    IBOutlet UISlider *track2VolumenSlider;
    IBOutlet UISlider *track2PanSlider;

    IBOutlet UIButton *track1PlayPauseButton;
    IBOutlet UIButton *track2PlayPauseButton;

    IBOutlet UIView  *track1View;
    IBOutlet UIView  *track2View;
}

- (void) setupApplicationAudio;

-(IBAction)changeRate:(UISlider*)sender;
-(IBAction)changePan:(UISlider*)sender;
-(IBAction)changeVolumen:(UISlider*)sender;
-(IBAction)playStopTrack:(UIButton*)sender;
-(float) convertSliderToRate:(float)sliderValue;


@end
