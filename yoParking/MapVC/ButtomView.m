//
//  ButtomView.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ButtomView.h"
#import "AppDelegate.h"
#import "NavViewController.h"
#import "LoginViewController.h"

@implementation ButtomView

- (IBAction)tap:(id)sender {
    NSLog(@"点击");
}
 -(void)setViewWithDic:(NSDictionary *)dic{
    self.nameL.text = dic[@"name"];
     self.nameL.adjustsFontSizeToFitWidth = YES;
    NSString *url = [NSString stringWithFormat:@"http://pic.ezparking.com.cn/rtpi-service/parking?key=P01890EQ52678RTX&type=photo&id=%@&file=%@&thumbnail=1",dic[@"id"],dic[@"photo"]];
    [GCD downloadImgWithUrl:url andCallBack:^(UIImage *img) {
        self.imgV.image = img;
    }];
    self.priceL.text = [NSString stringWithFormat:@"标准价:%@",dic[@"feeText"]];
    self.accountL.text = [NSString stringWithFormat:@"优惠价:%@",@"无"];
    self.totalNumL.text = [NSString stringWithFormat:@"车位数:%@个",dic[@"totalPlaces"]];
    self.statusL.text = [NSString stringWithFormat:@"状态:%@",dic[@"status"]];
}

- (IBAction)navigationBtn:(id)sender {
    
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    UIViewController *vc = nil;
    NSString *title = nil;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:@"1"]) {
         if ([self.delegate respondsToSelector:@selector(nav)]) {
            [self.delegate nav];
        }
      }else{
         vc = [[LoginViewController alloc]init];
        title = @"登陆";
     }
       vc.title = title;
    [self animationView];
    [dele.mainNavigationController pushViewController:vc animated:YES];
 }

- (IBAction)appointmentBtnclick:(id)sender {
}

-(void)animationView{
    /*
     pageCurl            向上翻一页
     pageUnCurl          向下翻一页
     rippleEffect        滴水效果
     suckEffect          收缩效果，如一块布被抽走
     cube                立方体效果
     oglFlip             上下翻转效果
     rotate              左右旋转
     */
    
    AppDelegate *dele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    CATransition * anima = [CATransition animation];
    [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    anima.duration = 0.8;
    anima.type = @"rippleEffect";
    anima.subtype = @"90ccw";
    [dele.mainNavigationController.view.layer addAnimation:anima forKey:nil];
}

 
@end
