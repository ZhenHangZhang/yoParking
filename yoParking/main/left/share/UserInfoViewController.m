
//
//  UserInfoViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"yonghu";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(regis)];
    self.navigationItem.rightBarButtonItem = rightBtn;

}
-(void)regis{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:user_phone];
    [defaults removeObjectForKey:user_id];
    [defaults removeObjectForKey:user_code];
    [defaults removeObjectForKey:user_car];
    //    [defaults removeObjectForKey:user_name];
    [defaults removeObjectForKey:user_info];
    [defaults setObject:@"0" forKey:IS_LOGIN];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HEADERIMG object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
 
@end
