//
//  GCD.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallBacks)(NSData *,NSError *);


@interface GCD : NSObject

+(void)downloadWithUrlStr:(NSString *)URLStr andCallBack:(CallBacks)callBack;

@end
