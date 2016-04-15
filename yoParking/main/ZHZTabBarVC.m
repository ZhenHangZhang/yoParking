//
//  ZHZTabBarVC.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZTabBarVC.h"
#import "ZHZTabBar.h"
#import "AppDelegate.h"
#import "ZHZNavitationVC.h"
#import "UserViewController.h"
#import "RootViewController.h"
#import "ZHZOneViewController.h"
#import "SearchViewController.h"
#import "MapViewController.h"

@interface ZHZTabBarVC ()<ZHZTabBarDelegate>
{

}
@end

@implementation ZHZTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self addItem];
    // 添加所有的子控制器
    [self addAllChildVcs];
    // 创建自定义tabbar
    [self addCustomTabBar];
}

-(void)addItem{
    self.automaticallyAdjustsScrollViewInsets = YES;
     self.title = @"约停车";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(leftView)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
-(void)leftView{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}
-(void)addCustomTabBar{
    // 创建自定义tabbar
    ZHZTabBar *customTabBar = [[ZHZTabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];

}
-(void)addAllChildVcs{
            UserViewController *discover = [[UserViewController alloc] init];
    [self addOneChlildVc:discover title:@"用户" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    MapViewController *profile = [[MapViewController alloc] init];
    [self addOneChlildVc:profile title:@"地图" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    
//     设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//
//    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    self.title =  title;
    // 添加为tabbar控制器的子控制器
//    ZHZNavitationVC *nav = [[ZHZNavitationVC alloc] initWithRootViewController:childVc];
    [self addChildViewController:childVc];
}

-(void)tabBarDidClickedPlusButton:(ZHZTabBar *)tabBar{
    SearchViewController *oneVC = [[SearchViewController alloc]init];
    ZHZNavitationVC *nav = [[ZHZNavitationVC alloc]initWithRootViewController:oneVC];
    [self presentViewController:nav animated:YES completion:^{
        NSLog(@"zhanghanz ");
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
//    self.navigationController.navigationBarHidden = YES;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

 @end
