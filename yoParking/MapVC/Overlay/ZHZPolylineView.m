//
//  ZHZPolylineView.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/29.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZPolylineView.h"

@implementation ZHZPolylineView

 -(void)srtOverLay:(double)zoom totalPlaces:(NSString *)totalPlaces distanceArr:(NSString*)distanceArr{
    self.lineWidth = 5.f;
    self.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
    self.lineCapType = kCGLineCapButt;
    self.lineJoinType = kCGLineJoinBevel;
    self.lineDash = YES;
//    self.lineDashPattern = nil;
    int num = [totalPlaces intValue]*2;
    float longNum = [distanceArr floatValue];
    NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:(longNum/num)+4] , [NSNumber numberWithFloat:(longNum/num)-4], nil];
     if ( zoom >= 17&&zoom <= 18) {
         
         self.lineDash = YES;

         
         self.lineDashPhase = 10;
         self.strokeColor = [UIColor colorWithRed:0.096 green:0.110 blue:1.000 alpha:1.000];
        self.lineWidth = 8.f;
     }else  if (zoom  > 18 && zoom <= 19) {
         self.lineDash = YES;

         self.strokeColor = [UIColor colorWithRed:0.986 green:0.354 blue:1.000 alpha:1.000];
         self.lineDashPhase = 12;
         self.lineWidth = 10.f;
     }else  if (zoom >= 19) {
         self.lineDash = YES;

         self.strokeColor = [UIColor colorWithRed:1.000 green:0.164 blue:0.111 alpha:1.000];
         self.lineDashPhase = 13;
         self.lineWidth = 12.f;
     }else{
         self.lineDash = NO;

          array = nil;
     }
    self.lineDashPattern = array;
}














/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
