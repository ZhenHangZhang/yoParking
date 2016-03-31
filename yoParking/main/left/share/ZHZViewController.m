//
//  ZHZViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/22.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZViewController.h"
#import "ZHZTViewController.h"

@interface ZHZViewController ()

@end

@implementation ZHZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regis)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
-(void)regis{
    ZHZTViewController *vc = [[ZHZTViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
