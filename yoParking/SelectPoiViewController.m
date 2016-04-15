//
//  SelectPoiViewController.m
//  testIndoorLibDemo
//
//  Created by auto on 15/11/10.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import "SelectPoiViewController.h"
#import "ViewController.h"
#import "IndoorMapView.h"
#import "IndoorRouteRequest.h"
#import "SelectPoiMapViewController.h"
#import "RouteViewController.h"

@interface SelectPoiViewController ()
@property(nonatomic,strong)  UIButton  *startBtn;
@property(nonatomic,strong)  UIButton  *endBtn;

@property(nonatomic,strong)  UIButton  *myfBtn;
@property(nonatomic,strong)  UIButton  *mysBtn;

@property(nonatomic,strong)  PointD *startLocation;

@property(nonatomic,strong)  NSString *startFloor;
@property(nonatomic,strong)  NSString *endFloor;

@end

@implementation SelectPoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择终点，起点";
    
    UIBarButtonItem* btnListItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onSearch)];
    self.navigationItem.rightBarButtonItem = btnListItem;
    
    
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.endBtn];
    [self.view addSubview:self.myfBtn];
    [self.view addSubview:self.mysBtn];
    
    [self.endBtn setTitle:self.selMarkView.info.name forState:UIControlStateNormal];
    [self.startBtn setTitle:@"我的位置" forState:UIControlStateNormal];
    
    self.startLocation = [[PointD alloc]init];
    self.endLocation   = [[PointD alloc]init];
    
    self.endLocation.lon =[NSString stringWithFormat:@"%lf",self.selMarkView.info.x];
    self.endLocation.lat =[NSString stringWithFormat:@"%lf",self.selMarkView.info.y];
    
    self.startLocation.lon = self.userLocation.lon;
    self.startLocation.lat = self.userLocation.lat;
    
    self.startFloor = @"1";
    self.endFloor =[NSString stringWithFormat:@"%0f",self.selMarkView.info.floorNum];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([_type isEqualToString:@"0"]) {
        [self.startBtn setTitle:self.poi.name forState:UIControlStateNormal];
        self.startLocation.lon =[NSString stringWithFormat:@"%lf",self.poi.x];
        self.startLocation.lat =[NSString stringWithFormat:@"%lf",self.poi.y];
        self.startFloor = [NSString stringWithFormat:@"%0f",self.poi.floorNum ];
    }
    if ([_type isEqualToString:@"1"]) {
        [self.endBtn setTitle:self.poi.name forState:UIControlStateNormal];
        self.endLocation.lon =[NSString stringWithFormat:@"%lf",self.poi.x];
        self.endLocation.lat =[NSString stringWithFormat:@"%lf",self.poi.y];
        self.endFloor = [NSString stringWithFormat:@"%0f",self.poi.floorNum ];
    }
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

#pragma mark action
- (void)onTapStart
{
    SelectPoiMapViewController *spc = [[SelectPoiMapViewController alloc]init];
    spc.type = @"0";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:spc animated:YES];
}

- (void)onTapEnd
{
    SelectPoiMapViewController *spc = [[SelectPoiMapViewController alloc]init];
    spc.type = @"1";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:spc animated:YES];
}

- (void)onSearch
{
    RouteViewController *rvc = [[RouteViewController alloc]init];
    rvc.spoiid = self.spoid;
    rvc.startFloor = self.startFloor;
    rvc.startPointD =self.startLocation;
    rvc.endPointD = self.endLocation;
    rvc.endFloorNo =self.endFloor;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)onTapMy:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self.startBtn setTitle:@"我的位置" forState:UIControlStateNormal];
        self.startLocation.lon = self.userLocation.lon;
        self.startLocation.lat = self.userLocation.lat;
        self.startFloor = @"1";
    }else{
        [self.endBtn setTitle:@"我的位置" forState:UIControlStateNormal];
        self.endLocation = self.userLocation;
        self.endLocation.lon = self.userLocation.lon;
        self.endLocation.lat = self.userLocation.lat;
        self.endFloor = @"1";
    }
}

#pragma makr getter or setter
- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(20,100, 190, 30);
        [_startBtn setTitle:@"起点" forState:UIControlStateNormal];
        _startBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        [_startBtn addTarget:self action:@selector(onTapStart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)myfBtn
{
    if (!_myfBtn) {
        _myfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myfBtn.frame = CGRectMake(240,100, 60, 30);
        [_myfBtn setTitle:@"我的位置" forState:UIControlStateNormal];
        _myfBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        _myfBtn.tag = 1;
        _myfBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_myfBtn addTarget:self action:@selector(onTapMy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myfBtn;
}


- (UIButton *)endBtn
{
    if (!_endBtn) {
        _endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _endBtn.frame = CGRectMake(20,150, 190, 30);
        [_endBtn setTitle:@"终点" forState:UIControlStateNormal];
        _endBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        [_endBtn addTarget:self action:@selector(onTapEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBtn;
}

- (UIButton *)mysBtn
{
    if (!_mysBtn) {
        _mysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mysBtn.frame = CGRectMake(240,150, 60, 30);
        [_mysBtn setTitle:@"我的位置" forState:UIControlStateNormal];
        _mysBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        _mysBtn.tag = 2;
        _mysBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_mysBtn addTarget:self action:@selector(onTapMy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mysBtn;
}


@end
