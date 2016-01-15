//
//  UUBar.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBar.h"
#import "UUColor.h"

@implementation UUBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapSquare;
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
		_chartLine.lineWidth   = self.frame.size.width;
		_chartLine.strokeEnd   = 0.0;
		self.clipsToBounds = YES;
       // self.backgroundColor =UUGreen;
		[self.layer addSublayer:_chartLine];
       // _chartLine.backgroundColor =(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1]);

		
    }
    return self;
}

-(void)setGrade:(float)grade
{
    if (grade==0)
        
        return;
    
	_grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height+15)];
	
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;

	if (_barColor) {
		_chartLine.strokeColor = [_barColor CGColor];
	}else{
		_chartLine.strokeColor = [UUGreen CGColor];
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 2.0;
}

- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    //!!!!
//    //设置颜色数组
//    UIColor *darkOp =
//    [UIColor colorWithRed:0.62f green:0.4f blue:0.42f alpha:1.0];
//    UIColor *lightOp =
//    [UIColor colorWithRed:0.43f green:0.76f blue:0.07f alpha:1.0];
//    //创建CAGradientLayer实例
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    //设置颜色
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)lightOp.CGColor,
//                       (id)darkOp.CGColor,
//                       nil];
    //设置渐变的frame
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:200/255.0 green:255/255 blue:200/255 alpha:1].CGColor);
	CGContextFillRect(context, rect);
    
}


@end
