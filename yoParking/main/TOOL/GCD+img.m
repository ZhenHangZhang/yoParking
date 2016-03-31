//
//  GCD+img.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "GCD+img.h"

@implementation GCD (img)
+(void)downloadImgWithUrl:(NSString *)URLStr andCallBack:(Backs)callBack{
    [GCD downloadWithUrlStr:URLStr andCallBack:^(NSData *data, NSError *error) {
        if (error) {
            callBack(nil);
        }else{
        
            UIImage *img = [UIImage imageWithData:data];
            callBack(img);
        }
    }];
}
@end
