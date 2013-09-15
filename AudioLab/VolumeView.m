//
//  VolumeView.m
//  AudioLab
//
//  Created by Javier Sanchez on 11/13/11.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

// VolumeView is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// VolumeView is distributed in the hope that it will be useful,
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

#import "VolumeView.h"

@interface VolumeView ()



@end

@implementation VolumeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initView];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Initialization code
        [self initView];
    }
    return self;
}



-(void) initView
{
    //set number of bars
    _numberOfBars=7;
    
    //bar colors
    _barsColorMin=[UIColor colorWithWhite:0.7 alpha:1.0];
    _barsColorMax=[UIColor colorWithWhite:0.4 alpha:1.0];

    // Set background color to transparent
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    //Create MPVolumeViewInstance to get the volumen value and slider action
    _mpVolumeView = [ [MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 0,0)] ;
    for (id object in _mpVolumeView.subviews)
    {
        if ([object isKindOfClass:[UISlider class]])
        {
            [ (UISlider*)object addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
            _volumenValue=[(UISlider*)object value];
        }
    }
    [_mpVolumeView setShowsVolumeSlider:YES];
    [self addSubview:_mpVolumeView];
}

- (void) showNativeVolumeControl:(BOOL)showNativeVolume
{
    
    [_mpVolumeView setShowsVolumeSlider:!showNativeVolume];
    
}

#pragma mark - VolumenControl

- (void)volumeChanged:(float )newVolume
{
    //Get volume value from MPVolumenView
    for (id object in _mpVolumeView.subviews)
        if ([object isKindOfClass:[UISlider class]])
        {
             [self setVolumenValue: [ (UISlider*) object value]];
            [self setNeedsDisplay];
            
        }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    
    //Set value of gap between bars. 20 means that the gap is 20% width of the bar.
    float gapPercentage=20;
    //Calculate barwidth according to view size
    float barWidth =    self.bounds.size.width/  (_numberOfBars * (1+ gapPercentage/100.)   );

    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Crear context
    CGContextClearRect(context, self.bounds);
    
    //// ColorSpace Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    
    float posX=0;
    float firstBarHeightPercentaje=10;

    //calculate barheight for first bar
    float barHeight=firstBarHeightPercentaje*self.bounds.size.height/100.;
    
    //calculate height step between consecutive bars
    float barHeightStep=  (1-firstBarHeightPercentaje/100)* self.bounds.size.height / (_numberOfBars-1);
    
    CGContextSaveGState(context);

    for (int i=0; i<_numberOfBars; i++)
    {
        //Draw Slider Center Axis
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(posX , self.bounds.size.height-barHeight, barWidth, barHeight) cornerRadius: 2];

        //set fill color depending of volume value
        if ((float)i/(float)_numberOfBars < _volumenValue)
            [_barsColorMin setFill];
        else
            [_barsColorMax setFill];

        //Fill path
        [rectanglePath fill];
        
        //calculate barheight and postion of  next bar
        barHeight=barHeight+barHeightStep;
        posX=posX+barWidth*(1.+gapPercentage/100.);
        
    }
    
    CGContextRestoreGState(context);

    //// Release
    CGColorSpaceRelease(colorSpace);
    
}


-(void) setBarsColorMin:(UIColor *)barsColorMin
{
    _barsColorMin=barsColorMin;
    [self setNeedsDisplay];

}

-(void) setBarsColorMax:(UIColor *)barsColorMax
{
    _barsColorMax=barsColorMax;
    [self setNeedsDisplay];
    
}

-(void) setNumberOfBars:(NSInteger)numberOfBars
{
    _numberOfBars=numberOfBars;
    [self setNeedsDisplay];
}

@end
