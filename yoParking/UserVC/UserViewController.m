//
//  UserViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "UserViewController.h"
#import "ShareViewController.h"
#import "AppDelegate.h"
#import "ZHZNavitationVC.h"
#import "LoginViewController.h"
#import "PreferentialViewController.h"
#import "MsgViewController.h"
#import "AboutViewController.h"
#import "AccounViewController.h"
#import "OrderViewController.h"
#import "UserInfoViewController.h"
#import "BackViewController.h"
#import "RightViewController.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_headView;
    NSUserDefaults *defaults;
    
    
    UIImageView *imgV;
    UILabel *nameL;
}

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation UserViewController

-(NSMutableArray *)dataArr{
    
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
        [_dataArr addObject:@"订单"];
        [_dataArr addObject:@"账户"];
        
        [_dataArr addObject:@"优惠"];
        
        [_dataArr addObject:@"分享"];
        
        [_dataArr addObject:@"消息"];
        
        [_dataArr addObject:@"关于"];
        
        [_dataArr addObject:@"反馈"];

        
    }return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    defaults = [NSUserDefaults standardUserDefaults];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(leftView)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(rightView)];
    self.navigationItem.rightBarButtonItem = rightBtn;

    

    [self setTableView];
    [self setheadView];
    
}
-(void)rightView{
    
     RightViewController *vc = [[RightViewController alloc]init];
     [self.navigationController pushViewController:vc animated:YES];
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
-(void)setTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
}
-(void)setheadView{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,100)];
    //    _headView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _headView;
    
    //点击的手势：
    // 我们需要定义一个方法，当手势识别检测到的时候，运行
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    // setNumberOfTapsRequired 点按次数
    [tap setNumberOfTapsRequired:1];
    // setNumberOfTouchesRequired 点按的手指数量
    [tap setNumberOfTouchesRequired:1];
    // 把手势识别增加到视图上
    [_headView addGestureRecognizer:tap];
    
    imgV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width)/2 - 30, 200/2 - 30, 60, 60)];
    imgV.layer.cornerRadius = 30;
    imgV.layer.masksToBounds = YES;
    nameL = [[UILabel alloc]initWithFrame:CGRectMake(imgV.frame.origin.x - 20, imgV.frame.origin.y + imgV.frame.size.height +2, 100, 15)];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.center = CGPointMake(imgV.center.x , imgV.center.y+40);
    nameL.font = [UIFont systemFontOfSize:14];
    [_headView addSubview:imgV];
    [_headView addSubview:nameL];
    [self setHeadeImg];
}
#pragma mark - 点按手势
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    AppDelegate *apdele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *vc = nil;
    if ([[defaults objectForKey:IS_LOGIN] integerValue]==1) {
        
         vc = [[UserInfoViewController alloc]init];
        vc.title = @"用户信息";
    }else{
         vc = [[LoginViewController alloc]init];
        vc.title = @"登陆";
    }
    [apdele.LeftSlideVC closeLeftView];//关闭左侧抽屉
    [self animationView];
    [apdele.mainNavigationController pushViewController:vc animated:YES];
}
-(void)setHeadeImg{
    if ([[defaults objectForKey:IS_LOGIN] integerValue] == 1 ) {
        nameL.text = @"13323819717";
        [GCD downloadImgWithUrl:@"http://b2c.ezparking.com.cn/rtpi-service/member/getIcon.do?key=b236ea0ecbfb130d1bf83c7b805f73f&id=s4dymBKb&rnd=1458711045.215144" andCallBack:^(UIImage *img) {
            imgV.image = img;
        }];
    }else{
        imgV.image = [UIImage imageNamed:@"user_head"];
        nameL.text = @"登陆/注册";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self rightView];
    return;
    
    
    
    
    AppDelegate *apdele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [apdele.LeftSlideVC closeLeftView];//关闭左侧抽屉
    UIViewController *vc = nil;
    NSString *title = nil;
    if ([[defaults objectForKey:IS_LOGIN] integerValue]!=1){
        vc = [[LoginViewController alloc]init];
        title = @"登陆";
     }else{
     switch (indexPath.row) {
        case 0:
        {
            vc = [[OrderViewController alloc]init];
            title = @"订单";
        }
            break;
        case 1:
        {
            vc = [[AccounViewController alloc]init];
            title = @"账户";
        }
            break;
        case 2:
        {
            vc = [[PreferentialViewController alloc]init];
            title = @"优惠";
        }
            break;
        case 3:
        {
            vc = [[ShareViewController alloc]init];
            title = @"分享";
        }
            break;
        case 4:
        {
            vc = [[MsgViewController alloc]init];
            title = @"消息";
        }
            break;
        case 5:
        {
            vc = [[RightViewController alloc]init];
            title = @"关于";
        }
            break;
        case 6:
        {
            vc = [[BackViewController alloc]init];
            title = @"意见反馈";
            
        }break;

        default:
            break;
    }
    }
    vc.title = title;
    [self animationView];
    [apdele.mainNavigationController pushViewController:vc animated:YES];
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
    AppDelegate *apdele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CATransition * anima = [CATransition animation];
    [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    anima.duration = 1.0;
    anima.type = @"rippleEffect";
    anima.subtype = @"90ccw";
    [apdele.mainNavigationController.view.layer addAnimation:anima forKey:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setHeadeImg];
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
