//
//  GCD.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "GCD.h"

@implementation GCD

+(void)downloadWithUrlStr:(NSString *)URLStr andCallBack:(CallBacks)callBack{
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLStr] options:NSDataReadingUncached error:&error];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        callBack(data,error);
    });
});
    
}

@end
