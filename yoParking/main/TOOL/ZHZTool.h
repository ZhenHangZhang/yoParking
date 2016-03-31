//
//  ZHZTool.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/22.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHZTool : NSObject


+(BOOL)isPhoneNumber:(NSString*)num;
+(BOOL)isCarNumber:(NSString *)num;
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//是否是英文
+(BOOL)isEnglishNum:(NSString *)num;
+(BOOL)isEmailNumber:(NSString *)email;
+(BOOL)IsIdentityCardNo:(NSString*)cardNo;
+ (UIImage*)CreatCode:(NSString*)word;
@end
