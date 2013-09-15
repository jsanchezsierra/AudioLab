//
//  SystemSoundVC.h
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
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface SystemSoundVC : UIViewController <AVAudioSessionDelegate>

@property (nonatomic, assign) SystemSoundID systemSound1;
@property (nonatomic, assign) SystemSoundID systemSound2;
@property (nonatomic, assign) SystemSoundID systemSound3;
@property (nonatomic, assign) SystemSoundID systemSound4;
@property (nonatomic, assign) SystemSoundID systemSound5;
@property (nonatomic, assign) SystemSoundID systemSound6;

@property (nonatomic, weak) IBOutlet UIButton *soundButton1;
@property (nonatomic, weak) IBOutlet UIButton *soundButton2;
@property (nonatomic, weak) IBOutlet UIButton *soundButton3;
@property (nonatomic, weak) IBOutlet UIButton *soundButton4;
@property (nonatomic, weak) IBOutlet UIButton *soundButton5;
@property (nonatomic, weak) IBOutlet UIButton *soundButton6;


-(IBAction) playSystemSound:(UIButton*)sender;
-(CFURLRef) pathWithName:(NSString*)name andType:(NSString*)type;
-(void) gradientForButton:(UIButton*)myButton;

@end

