//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

@interface UUBarChart ()
{
    UIView *myScrollView;
}
@end

@implementation UUBarChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
  //      [myScrollView setBackgroundColor:UUGreen];
//        myScrollView.layer.shouldRasterize = YES;
//        myScrollView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        UIColor *lightG = [UIColor colorWithRed:173.0/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:1.0f];
        UIColor *darkG = [UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:235.0/255.0 alpha:1.0f];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
        self.layer.cornerRadius = 6;
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
  
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat level;
    CGFloat levelHeight;
    if (max<10) {
        level = 1;
        levelHeight = chartCavanHeight/max;
    }else{
        level = _yValueMax/4.0;
        levelHeight = chartCavanHeight/4.0;
    }
    
    for (int i=0; i<=max; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight+10)];
		label.text = [NSString stringWithFormat:@"%.f",level * i+_yValueMin];
    //    label.backgroundColor = UUGreen;
		[self addSubview:label];
    }
	
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    NSInteger num;

    num = xLabels.count;
    _xLabelWidth = myScrollView.frame.size.width/num;
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        if (xLabels.count <8) {
            if ([label.text isEqualToString: @"1"]) {
                label.text = @"月";
            }else if([label.text isEqualToString: @"2"]){
                label.text = @"火";
            }else if([label.text isEqualToString: @"3"]){
                label.text = @"水";
            }else if([label.text isEqualToString: @"4"]){
                label.text = @"木";
            }else if([label.text isEqualToString: @"5"]){
                label.text = @"金";
            }else if([label.text isEqualToString: @"6"]){
                label.text = @"土";
            }else if([label.text isEqualToString: @"7"]){
                label.text = @"日";
            }

        }
        [myScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
    }
    

}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
	
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            //显示柱状的位置
            UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.46, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight)];
            bar.barColor = [_colors objectAtIndex:i];
            //!!!!!!!!
           //bar.barColor = UUGreen;
            bar.grade = grade;
            [myScrollView addSubview:bar];
        }
    }
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
