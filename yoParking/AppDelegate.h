//
//  AppDelegate.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
#import "LeftSlideViewController.h"

#import "ZHZNavitationVC.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)YRSideViewController*YRvc;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
 
@end

