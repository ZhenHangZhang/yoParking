//
//  AdViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/24.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "AdViewController.h"
#import "ZHZViewController.h"
@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem = rightBtn;

}
-(void)pop{
    
    ZHZViewController *vc = [[ZHZViewController alloc]init];
    vc.title = @"测试1";
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
