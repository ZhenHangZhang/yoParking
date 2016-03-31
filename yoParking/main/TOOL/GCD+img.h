//
//  GCD+img.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "GCD.h"

typedef void (^Backs)(UIImage *);

@interface GCD (img)

+(void)downloadImgWithUrl:(NSString *)URLStr andCallBack:(Backs)callBack;

@end
