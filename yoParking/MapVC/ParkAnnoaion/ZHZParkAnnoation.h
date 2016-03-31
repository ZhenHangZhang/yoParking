//
//  ZHZParkAnnoation.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/MAMapKit.h>
@interface ZHZParkAnnoation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *subTitle;
@property (nonatomic, assign) NSInteger tag;


@end
