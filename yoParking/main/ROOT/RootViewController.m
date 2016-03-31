//
//  RootViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "MapViewController.h"
#import "TableViewController.h"




@interface RootViewController ()

@property (nonatomic, strong) MapViewController *firstVC;
@property (nonatomic, strong) TableViewController *secondVC;


@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏按钮
//    self.title = @"地图";
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(leftView1)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height   - 30)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    [self setAllChildVC];
    
    //调整子视图控制器的Frame已适应容器View
    [self fitFrameForChildViewController:_firstVC];
    //设置默认显示在容器View的内容
    [self.contentView addSubview:_firstVC.view];
    self.currentVC = _firstVC;
}
-(void)setAllChildVC{
    
    _firstVC = [[MapViewController alloc]init];
    [self addChildViewController:_firstVC];
    _secondVC = [[TableViewController alloc]init];
    [self addChildViewController:_secondVC];
}

-(void)leftView1{
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
-(void)pop{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"列表"]) {
        [self fitFrameForChildViewController:_secondVC];
        [self transitionFromOldViewController:_currentVC toNewViewController:_secondVC];
        
        self.tabBarController.tabBar.hidden = YES;
        
        self.navigationItem.rightBarButtonItem.title = @"地图";
    }else{
        [self fitFrameForChildViewController:_firstVC];
        [self transitionFromOldViewController:_currentVC toNewViewController:_firstVC];
        self.tabBarController.tabBar.hidden = NO;

        self.navigationItem.rightBarButtonItem.title = @"列表";
    }
}
//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.5 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        //1.创建转场动画对象
        CATransition *transition=[[CATransition alloc]init];
        
        //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
        transition.type=@"cube";
        //设置子类型
        transition.subtype=kCATransitionFromRight;
        //设置动画时常
        transition.duration=1.0f;
        
        //3.设置转场后的新视图添加转场动画
        [newViewController.view.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}
//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

-(void)fitFrameForChildViewController:(UIViewController*)vc{
    CGRect frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    frame.origin.y = 0;
    vc.view.frame = frame;
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
