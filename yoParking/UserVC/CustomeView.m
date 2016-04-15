//
//  CustomeView.m
//  yoParking
//
//  Created by zhanghangzhen on 16/4/13.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "CustomeView.h"

@implementation CustomeView


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [self setBtns];
    }
    return  self;
    
}


 -(void)setBtns{
      for (int i = 0;i < 4; i++) {
          UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(self.frame.size.width/4 * i, 0, self.frame.size.width/4, self.frame.size.height) target:self sel:@selector(addtargert:) tag:i image:nil title:@"nihao"];
         [self addSubview:btn];
       }
  }
-(void)addtargert:(UIButton*)btn{
    NSLog(@"%ld",(long)btn.tag);

    switch (btn.tag) {
        case 0:
        {
//            NSLog(@"%ld",(long)btn.tag);
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {
        }
            break;
            
        default:
            break;
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //类似于画布！
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边缘样式
    CGContextSetLineCap(context, kCGLineCapRound);
   // 线的宽度
    CGContextSetLineWidth(context, 2);
    
    CGContextSetAllowsAntialiasing(context, true);
    //线的颜色
    CGContextSetRGBStrokeColor(context, 70.0/255.0, 241.0/255.0, 241.0/255.0, 1.0);
    
    CGContextBeginPath(context);
    
    for (int i = 1; i < 4; i++) {
        //起点
        CGContextMoveToPoint(context, rect.size.width/4.0 *i, 0);
        //终点坐标
        CGContextAddLineToPoint(context, rect.size.width/4.0 *i, rect.size.height);
    }
    
    //起点
    CGContextMoveToPoint(context, rect.size.width/4.0, 0);
    //终点坐标
    CGContextAddLineToPoint(context, rect.size.width/4.0, rect.size.height);
   
    CGContextStrokePath(context);
 
}


@end
