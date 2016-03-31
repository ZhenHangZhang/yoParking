//
//  ZHZPolylineView.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/29.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <AMapNaviKit/MAMapKit.h>

@interface ZHZPolylineView : MAPolylineView
-(void)srtOverLay:(double)zoom totalPlaces:(NSString *)totalPlaces distanceArr:(NSString*)distanceArr;
@end
