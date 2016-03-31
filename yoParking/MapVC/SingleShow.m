//
//  SingleShow.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/29.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "SingleShow.h"

@implementation SingleShow

 
+(instancetype)show{
     static SingleShow *show = nil;
    if (show == nil) {
        show = [[SingleShow alloc]init];
    }return show;
}
 
 @end
