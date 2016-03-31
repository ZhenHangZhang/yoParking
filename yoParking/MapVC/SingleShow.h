//
//  SingleShow.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/29.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZHZBlock)(CLLocationCoordinate2D coordinate,NSString *address,int tag);

@interface SingleShow : NSObject


@property(nonatomic,copy)ZHZBlock block;
 ;
+(instancetype)show;

@end
