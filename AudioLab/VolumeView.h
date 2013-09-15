//
//  VolumeView.h
//  AudioLab
//
//  Created by Javier Sanchez on 11/13/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

// VolumenView is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// VolumenView is distributed in the hope that it will be useful,
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

//https://github.com/jsanchezsierra/VolumeView

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VolumeView : UIView

#pragma mark - Properties

/**
 Number of volumen Bars
 */
@property (nonatomic,assign) NSInteger numberOfBars;


/**
 Volume value
 */
@property (nonatomic,assign) float volumenValue;


/**
 MPVolumenView
 */
@property (strong, nonatomic) MPVolumeView *mpVolumeView;
@property (strong, nonatomic) UIColor *barsColorMin;
@property (strong, nonatomic) UIColor *barsColorMax;


#pragma mark - Custom Methods
/**
 Init the VolumeView with a given number of bars and volume value
 @param frame CGRect
 @param newNumberOfBars NSInteger
 @param newVolume float
 */
- (id)initWithFrame:(CGRect)frame numberOfBars:(NSInteger)newNumberOfBars;
- (void) showNativeVolumeControl:(BOOL)showNativeVolume;

@end
