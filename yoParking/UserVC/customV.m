
//
//  customV.m
//  yoParking
//
//  Created by zhanghangzhen on 16/4/13.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "customV.h"

@implementation customV
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return  self;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //类似于画布！
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 1.0, 0.5);
    CGContextMoveToPoint(context, 64, 64);
        CGContextSetLineWidth(context, 3.0);
    CGContextAddLineToPoint(context, 200, 64);
    CGContextStrokePath(context);
    /**
     //文字
     CGContextSetLineWidth(context, 1.0);
     CGContextSetRGBFillColor (context, 0.5, 1.5, 0.5, 0.5);
     UIFont  *font = [UIFont boldSystemFontOfSize:18.0];
     [@"公司：北京中软科技股份有限公司\n部门：ERP事业部\n姓名：McLiang" drawInRect:CGRectMake(20, 40, 280, 300) withFont:font];
     
     */
   
    
        /**  画一个正方形图形 没有边框
         CGContextSetRGBFillColor(context, 0, 0.25, 0, 0.5);
         CGContextFillRect(context, CGRectMake(2, 2, 270, 270));
         CGContextStrokePath(context);
      */
    
    
    /** 画正方形边框
     CGContextSetRGBStrokeColor(context, 2.0, 0.5, 0.5, 0.5);//线条颜色
     CGContextSetLineWidth(context, 2.0);
     CGContextAddRect(context, CGRectMake(2, 2, 270, 270));
     CGContextStrokePath(context);
     */
    /**画方形背景颜色
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context,320);
    CGContextSetRGBStrokeColor(context, 250.0/255, 250.0/255, 210.0/255, 1.0);
    CGContextStrokeRect(context, CGRectMake(0, 0, 50, 50));
    UIGraphicsPopContext();
     */
    
       /**
        椭圆
        CGRect aRect= CGRectMake(80, 80, 160, 100);
        CGContextSetRGBStrokeColor(context, 0.6, 0.9, 0, 1.0);
        CGContextSetLineWidth(context, 3.0);
        CGContextAddEllipseInRect(context, aRect); //椭圆
        CGContextDrawPath(context, kCGPathStroke);

     */
    
    /*
    //渐变
    CGContextClip(context);
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
        29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
        0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
    */
    
    
    CGContextSetLineWidth(context, 5.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGFloat dashArray[] = {2,6,4,2};
    
    CGContextSetLineDash(context, 3, dashArray, 4);//跳过3个再画虚线，所以刚开始有6-（3-2）=5个虚点
    
    CGContextMoveToPoint(context, 10, 20);
    
//    CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);
    
    CGContextAddLineToPoint(context, 10, 100);
    
    CGContextStrokePath(context);
    
    
    
}


@end
