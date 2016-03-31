//
//  BaseViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/21.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//     UIImage *image = [UIImage imageNamed:@"tm_bj"];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                  forBarMetrics:UIBarMetricsDefault];
//
//    
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//     UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:target action:@selector(swipeAction:)];
//    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipeLeft];
//      self.navigationController.interactivePopGestureRecognizer.enabled = NO;
 }
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
     return YES;
}
-(void)swipeAction:(UISwipeGestureRecognizer*)swipeLeft{
     [self.navigationController popViewControllerAnimated:YES];
 }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    self.navigationController.navigationBarHidden = NO;
 }
// -(void)viewDidAppear:(BOOL)animated{
//     [super viewDidAppear:animated];
//
//     AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//      [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////    self.navigationController.navigationBarHidden = YES;
//
//    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
