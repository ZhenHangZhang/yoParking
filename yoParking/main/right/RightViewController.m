//
//  RightViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "RightViewController.h"
#import "CustomeView.h"
#import "customV.h"

@interface RightViewController ()

@property (nonatomic,strong)CustomeView *v;
@property (nonatomic,strong)customV *vvvvvvv;


@end

@implementation RightViewController
 - (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.v = [[CustomeView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 60)];
    [self.view addSubview:self.v];
     self.vvvvvvv = [[customV alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
     [self.view addSubview:self.vvvvvvv];
     
}
 - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
