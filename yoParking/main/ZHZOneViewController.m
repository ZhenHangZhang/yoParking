
//
//  ZHZOneViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZOneViewController.h"

@interface ZHZOneViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ZHZOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(friendSearch)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"＋" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem = rightBtn;
     self.navigationController.delegate = self;
    
 }

-(void)friendSearch{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pop{

    
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
