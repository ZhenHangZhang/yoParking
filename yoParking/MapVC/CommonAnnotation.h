//
//  CommonAnnotation.h
//  Park
//
//  Created by  apple on 15/7/22.
//  Copyright (c) 2015年  apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/MAMapKit.h>

@interface CommonAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger tag;

@end
