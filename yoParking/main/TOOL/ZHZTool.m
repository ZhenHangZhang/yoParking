//
//  ZHZTool.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/22.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZTool.h"

@implementation ZHZTool

+(BOOL)isPhoneNumber:(NSString *)num{

    NSString * MOBILE = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:num] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(BOOL)isCarNumber:(NSString *)num{
    NSString * MOBILE = @"^[蒙|冀|黑|宁|云|皖|苏|桂|琼|湘|吉|闽|贵|辽|沪|粤|浙|青|鲁|津|京|藏|甘|川|新|赣|豫|晋|陕|鄂|渝]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{5}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:num] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr {
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t/1000];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //转化为 时间字符串
    return [df stringFromDate:date];
}

+(BOOL)isEnglishNum:(NSString *)num
{
    NSString *emailRegex = @"[A-Z]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:num];
}

+(BOOL)isEmailNumber:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:email]){
        
        NSLog(@"恭喜！您输入的邮箱验证合法");
        return YES;
        
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
    }
    return NO;
}
+(BOOL)IsIdentityCardNo:(NSString*)cardNo

{
    if (cardNo.length != 18) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起!省份证的位数不够或过多" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        NSLog(@"输入的省份证号码不对");
        return NO;
    }
    int sumValue = 0;
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        NSLog(@"验证省份证号码可用");
        return YES;
        
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"省份证份证号码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    return  NO;
}
+ (UIImage*)CreatCode:(NSString*)word {
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
    NSData *data=[word dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
   return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
    
    
    
    //    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    //
    //    _imgView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
    //
    //    _imgView.layer.shadowRadius=1;//设置阴影的半径
    //
    //    _imgView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    //
    //    _imgView.layer.shadowOpacity=0.3;
}
//改变二维码大小

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


@end
