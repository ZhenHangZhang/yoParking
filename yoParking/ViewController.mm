//
//  ViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ViewController.h"
#import "IndoorDataManger.h"
#import "IndoorMapView.h"
#import "IndoorRouteRequest.h"
#import "IndoorSearchEngine.h"
#import "IndoorFloorHBar.h"
#import "SearchListViewController.h"
#import "SelectPoiViewController.h"
#import "InMapView.h"
#define AMKEY @"4fb0cc587a308791908fe01e225d1ed3"
@interface ViewController ()<IndoorMapViewDelegate,IndoorDataMangerProtocol,UIActionSheetDelegate,UITextFieldDelegate,IndoorFloorHBarDelegate>
@property(nonatomic,strong)  IndoorMapView    *mapView;
@property(nonatomic,strong)  IndoorMarkerView *markView;

@property(nonatomic,strong)  NSMutableDictionary *markViews;

@property(nonatomic,strong)  NSMutableArray   *floorsAry;
@property(nonatomic,strong)  UIButton         *addBtn;
@property(nonatomic,strong)  UIButton         *subBtn;
@property(nonatomic,strong)  UIButton         *locBtn;
@property(nonatomic,strong)  UIView           *poiView;
@property(nonatomic,strong)  UILabel          *nameLabel;
@property(nonatomic,strong)  UILabel          *floorLabel;
@property(nonatomic,strong)  UIButton         *goBtn;

@property(nonatomic,strong)  IndoorBuilding   *indoorBuilding;

@property(nonatomic,strong)  IndoorFloorHBar  *floorBarView;

@property(nonatomic,strong)  PointD           *userLocation;

@property(nonatomic,strong)  IndoorMarkerView *selMarkView;

@property(nonatomic,strong)  UIView           *routeView;
@property(nonatomic,strong)  UIButton         *backBtn;

@property(nonatomic,strong)  UIView           *showWayView;
@property(nonatomic,strong)  UILabel          *showWayLabel;
@property(nonatomic,strong)  UIButton         *showWayBtn;

@property(nonatomic,strong)  IndoorRouteResponse *indoorRR;

@property(nonatomic,assign)  BOOL             isRoute;

@property(nonatomic,assign)  int              selFloorIndex;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = self.name;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
    backItem.title = @"";
    
    self.navigationController.navigationItem.backBarButtonItem = backItem;
    
    
    self.floorsAry =[[NSMutableArray alloc]initWithCapacity:0];
    
    self.mapView = [InMapView sharedMapView].mapView;
    
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.mapView.isPlottingScale = YES;
    self.mapView.iscompassView   = YES;
    
    
    
    
    [IndoorDataManger getInstance].delegate = self;
    [[IndoorDataManger getInstance] downloadMapData:AMKEY
                                            buildid:self.spoiid
                                       checkNewData:YES];
    
    
    
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(20, 15, self.view.frame.size.width- 2 *20, 40) ];
    searchView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField =  [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 32)];
    textField.text = @"输入门店、品牌、设施";
    textField.textColor = [UIColor darkGrayColor];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    
    [self.view addSubview:searchView];
    [searchView addSubview:textField];
    
    
    self.navigationItem.titleView = searchView;
    
    self.locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locBtn setBackgroundImage:[UIImage imageNamed:@"loc_normal"] forState:UIControlStateNormal];
    [self.locBtn setBackgroundImage:[UIImage imageNamed:@"loc_clicked"] forState:UIControlStateSelected];
    
    [self.locBtn addTarget:self action:@selector(onTapLocation) forControlEvents:UIControlEventTouchUpInside];
    self.locBtn.frame =CGRectMake(10, self.view.frame.size.height- 130, 50, 50);
    [self.view addSubview:self.locBtn];
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(onTapZoomIn) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.frame =CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height- 180, 50, 50);
    [self.view addSubview:self.addBtn];
    
    self.subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subBtn setBackgroundImage:[UIImage imageNamed:@"subtraction"] forState:UIControlStateNormal];
    [self.subBtn addTarget:self action:@selector(onTapZoomOut) forControlEvents:UIControlEventTouchUpInside];
    self.subBtn.frame =CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height- 130, 50, 50);
    [self.view addSubview:self.subBtn];
    
    
    [self.view addSubview:self.poiView];
    [self.poiView addSubview:self.nameLabel];
    [self.poiView addSubview:self.floorLabel];
    [self.poiView addSubview:self.goBtn];
    
    self.markView = nil;
    self.markViews = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    self.userLocation = [[PointD alloc]init];
    self.userLocation.lon = @"116.518539";
    self.userLocation.lat = @"39.9242401";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.mapView.delegate = self;
    self.mapView.isPlottingScale = YES;
    self.mapView.iscompassView = YES;
    [self.view insertSubview:self.mapView atIndex:0];
    CGPoint point;
    point.x =116.518539;
    point.y =39.9242401;
    [self.mapView updateUserLoc:point withFloorNum:1];
}

#pragma mark textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //搜索
    SearchListViewController* controller = [[SearchListViewController alloc] init];
    controller.indoorPath =self.indoorBuilding.path;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:controller animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action
- (void)onTapLocation
{
    
}

- (void)onTapZoomIn
{
    [self.mapView zoomIn];
    // [self.mapView updateRotationZ:180];
}

- (void)onTapZoomOut
{
    [self.mapView zoomOut];
}

- (void)showPoiInfo:(IndoorMarkerView *)idoorMView
{
    if (idoorMView) {
        NSLog(@":%f",idoorMView.info.x);
        self.poiView.hidden = NO;
        self.nameLabel.text =idoorMView.info.name;
        for (IndoorFloorInfo *info in self.floorsAry) {
            if(info.floorIndex  == idoorMView.info.floorNum)
            {
                self.floorLabel.text =info.namecode;
                break;
            }
        }
        //_nameLabel.center = CGPointMake(self.view.frame.size.width/2, 5);
        self.selMarkView =idoorMView;
    }
    
}

- (void)animationCtrl
{
    [UIView animateWithDuration: 0.3 animations:^{
        self.addBtn.frame =CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height- 190, 50, 50);
        self.subBtn.frame =CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height- 140, 50, 50);
        self.locBtn.frame =CGRectMake(10, self.view.frame.size.height- 140, 50, 50);
    } completion:^(BOOL finish){
        
    }];
    
    
}

- (void)removeAnimationCtrl
{
    [UIView animateWithDuration:0.3 animations:^{
        self.addBtn.frame =CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height- 180, 50, 50);
        self.subBtn.frame =CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height- 130, 50, 50);
        self.locBtn.frame =CGRectMake(10, self.view.frame.size.height- 130, 50, 50);
    } completion:^(BOOL finish){
        
    }];
    
    
}

#pragma mark floor

#pragma mark - mapviewDelegate
- (void)didTapPoint:(CGPoint)point withFloorNum:(int)num withPoiArray:(NSArray *)array
{
    NSLog(@"didTapPoint:%@",array);
    if (self.isRoute) {
        return ;
    }
    
    if([array count]<=0)
    {
        self.poiView.hidden = YES;
        return ;
    }
    
    IndoorPoiInfo *poi= (IndoorPoiInfo *)array[0];
    
    
    NSLog(@"%d",poi.type);
    if (poi.type == 900 || poi.type == 100 || poi.type == 300) {
        return ;
    }
    if(self.markView == nil){
        self.markView= [self.mapView addMarker:CGPointMake(poi.x, poi.y) withFloorNum:num withPoiInfo:poi withImageName:@"default_map_select_point_normal"];
    }
    else{
        [self.mapView removeMarkers];
        self.markView = nil;
        //self.poiView.hidden = YES;
        self.markView= [self.mapView addMarker:CGPointMake(poi.x, poi.y) withFloorNum:num withPoiInfo:poi withImageName:@"default_map_select_point_normal"];
    }
    
    [self showPoiInfo:self.markView];
    [self animationCtrl];
    [self.mapView setViewPortToLocationX:point.x withY:point.y];
}


- (void)didLongPressPoint:(CGPoint)point withFloorNum:(int)num withPoiArray:(NSArray *)array
{
    NSLog(@"%@",array);
    
    if([array count]==0)
        return ;
    //IndoorPoiInfo *poi= (IndoorPoiInfo *)array[0];
    
    NSLog(@"%@",self.markView);
    
}

- (void)didScaleChanged:(float)scale withScaleState:(kFEGLScaleState)state
{
    
    
    NSLog(@"%f",scale);
    
    
}

#pragma mark poi click
- (void)didTapClick:(IndoorMarkerView *)idoorMView
{
    if (idoorMView) {
        //[self.mapView removeMarker:idoorMView];
        [self.mapView removeMarkers];
        self.markView = nil;
        self.poiView.hidden = YES;
        [self removeAnimationCtrl];
    }
    
}

- (void)onTapBack
{
    [self.mapView removePathsData:self.indoorRR];
    [self.showWayView removeFromSuperview];
    [self.routeView removeFromSuperview];
    self.poiView.hidden = NO;
    self.isRoute = NO;
}

- (void)onTapShowWay
{
    [self.mapView loadFloorWithIndex:self.startFloor];
}

- (void)onTapGo
{
    SelectPoiViewController *spc = [[SelectPoiViewController alloc]init];
    spc.selMarkView = self.selMarkView;
    spc.userLocation = self.userLocation;
    spc.spoid = self.spoiid;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:spc animated:YES];
}


#pragma mark download
- (void)downloadMapDataSuccess:(IndoorBuilding *)indoorBuilding
{
    NSLog(@"downloadMapDataSuccess:%@",indoorBuilding.buildid);
    //
    [self.mapView LoadDataFile:indoorBuilding.path];
    self.indoorBuilding = indoorBuilding;
    
    NSArray *ary = [self.mapView getFloorInfos];
    [self.floorsAry addObjectsFromArray:ary];
    
    _floorBarView = [[IndoorFloorHBar alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height- 220, 50, 80 )];
    _floorBarView.delegate = self;
    [_floorBarView setData:ary startIndex:(int)1];
    // [self.view insertSubview:_floorBarView aboveSubview:self.view];
    [self.view addSubview:_floorBarView];
    
    IndoorFloorInfo *info = (IndoorFloorInfo *)ary[1];
    [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",info.floorIndex ]];
    
    self.selFloorIndex = info.floorIndex;
    
    [self.mapView updateScale:(0.6f)];
    CGPoint point;
    point.x =116.518539;
    point.y =39.9242401;
    [self.mapView updateUserLoc:point withFloorNum:info.floorIndex];
}

/*!
 *  下载地图数据失败
 *
 */
- (void)downloadMapDataFailed:(NSString *)poiid
                        error:(NSError *)error
{
    NSLog(@"downloadMapDataFailed:%@",error);
    UIAlertView *aView = [[UIAlertView alloc]initWithTitle:@"地图请求" message:[error domain] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [aView show];
}


#pragma mark floor click
-(void)setFloorIndex:(int)floorIndex
{
    NSLog(@"%d",floorIndex);
    self.selFloorIndex = floorIndex;
    [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",floorIndex]];
    [self.mapView updateScale:(0.1f)];
    if (floorIndex == 1) {
        CGPoint point;
        point.x =116.518539;
        point.y =39.9242401;
        [self.mapView updateUserLoc:point withFloorNum:1];
    }
    
}

#pragma mark action
- (void)loadSearchPoi:(IndoorEn *)en
{
    [self.mapView removeMarkers];
    [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",en.floorIndex ]];
    
    IndoorPoiInfo *poi = [[IndoorPoiInfo alloc]init];
    poi.name = en.name_dp;
    poi.x = en.centerX;
    poi.y = en.CenterY;
    poi.type = en.typeCode;
    poi.floorNum = en.floorIndex;
    
    IndoorMarkerView * imv = [self.mapView addMarker:CGPointMake(poi.x, poi.y) withFloorNum:en.floorIndex withPoiInfo:poi withImageName:@"default_map_select_point_normal"];
    
    [self.mapView setViewPortToLocationX:poi.x withY:poi.y];
    
    //[self.floorView selviewByIndex:en.floorIndex];
    [self.floorBarView gotoPageByIndex:poi.floorNum];
    
    [self showPoiInfo:imv];
}

- (void)loadSearchAllPoi:(NSArray *)pois
{
    [self.mapView removeMarkers];
    BOOL isHave = false;
    for (IndoorEn *en in pois) {
        IndoorPoiInfo *poi = [[IndoorPoiInfo alloc]init];
        poi.name = en.name_dp;
        poi.x = en.centerX;
        poi.y = en.CenterY;
        poi.type = en.typeCode;
        poi.floorNum = en.floorIndex;
        
        [self.mapView addMarker:CGPointMake(poi.x, poi.y) withFloorNum:en.floorIndex withPoiInfo:poi withImageName:@"default_map_select_point_normal"];
        
        if (self.selFloorIndex == poi.floorNum) {
            isHave = YES;
        }
    }
    
    if (isHave) {
        [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",self.selFloorIndex ]];
        [self.floorBarView gotoPageByIndex:self.selFloorIndex];
    }else{
        IndoorEn *en = (IndoorEn *)pois[0];
        [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",en.floorIndex ]];
        
        [self.floorBarView gotoPageByIndex:en.floorIndex];
    }
    
    
    
    self.poiView.hidden = YES;
}

#pragma mark getter or setter
- (UIView *)routeView
{
    if (!_routeView) {
        _routeView = [[UIView alloc]initWithFrame:CGRectMake(20, 15, self.view.frame.size.width- 2 *20, 40)];
        _routeView.backgroundColor = [UIColor whiteColor];
    }
    return _routeView;
}

- (UIView *)poiView
{
    if (!_poiView) {
        _poiView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-80.0f, self.view.frame.size.width, 80)];
        _poiView.backgroundColor = [UIColor whiteColor];
        _poiView.hidden = YES;
    }
    return _poiView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10, self.view.frame.size.width, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}


- (UILabel *)floorLabel
{
    if (!_floorLabel) {
        _floorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,28, self.view.frame.size.width, 20)];
        _floorLabel.backgroundColor = [UIColor clearColor];
        _floorLabel.textColor = [UIColor grayColor];
        _floorLabel.font = [UIFont systemFontOfSize:12];
    }
    return _floorLabel;
}


- (UIButton *)goBtn
{
    if (!_goBtn) {
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goBtn.frame = CGRectMake(10,50, self.view.frame.size.width-2*10, 30);
        [_goBtn setTitle:@"去这里" forState:UIControlStateNormal];
        _goBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        //[UIColor blueColor];
        [_goBtn addTarget:self action:@selector(onTapGo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBtn;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(10,2, self.routeView.frame.size.width- 2 *10, 30);
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        _backBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        [_backBtn addTarget:self action:@selector(onTapBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


- (UIView *)showWayView
{
    if (!_showWayView) {
        _showWayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
        _showWayView.backgroundColor = [UIColor whiteColor];
    }
    return _showWayView;
}

- (UILabel *)showWayLabel
{
    if (!_showWayLabel) {
        _showWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,5, self.showWayView.frame.size.width-60, 20)];
        _showWayLabel.backgroundColor = [UIColor clearColor];
        _showWayLabel.textColor = [UIColor blackColor];
        _showWayLabel.font = [UIFont systemFontOfSize:14];
    }
    return _showWayLabel;
}

- (UIButton *)showWayBtn
{
    if (!_showWayBtn) {
        _showWayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showWayBtn.frame = CGRectMake(self.showWayView.frame.size.width-60,5, 40, 30);
        [_showWayBtn setTitle:@"指路" forState:UIControlStateNormal];
        _showWayBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        [_showWayBtn addTarget:self action:@selector(onTapShowWay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showWayBtn;
}


@end

