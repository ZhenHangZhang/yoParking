//
//  RouteViewController.m
//  testIndoorLibDemo
//
//  Created by auto on 15/11/20.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import "RouteViewController.h"
#import "IndoorRouteRequest.h"
#import "IndoorMapView.h"
#import "InMapView.h"

@interface RouteViewController ()<IndoorRouteRequestDelegate,IndoorMapViewDelegate>
@property(nonatomic,strong)  IndoorMapView    *mapView;
@property(nonatomic,strong)  IndoorRouteResponse *indoorRR;
@property(nonatomic,assign)  BOOL             isRoute;
@property(nonatomic,strong)  UIView           *routeView;
@property(nonatomic,strong)  UIButton         *backBtn;
@property(nonatomic,strong)  UIButton         *perBtn;
@property(nonatomic,strong)  UIButton         *nextBtn;

@property(nonatomic,strong)  UIView           *showWayView;
@property(nonatomic,strong)  UILabel          *showWayLabel;
@property(nonatomic,strong)  UIButton         *showWayBtn;
@property(nonatomic,strong)  NSMutableArray   *floorsAry;

@property(nonatomic,assign)  int               index;


@property(nonatomic,strong)  UILabel          *floorLabel;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"路算结果";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.mapView = [InMapView sharedMapView].mapView;
    self.mapView.delegate = self;
    self.mapView.isPlottingScale = NO;
    self.mapView.iscompassView = NO;
    [self.view addSubview:self.mapView];
    
    self.floorsAry = [[NSMutableArray alloc]initWithCapacity:0];
    NSArray *ary = [self.mapView getFloorInfos];
    [self.floorsAry addObjectsFromArray:ary];
    
    
    IndoorFloorInfo *info = (IndoorFloorInfo *)ary[1];
    [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%@",self.endFloorNo ]];
    
    [self routeCalc:self.startPointD startFloorNo:self.startFloor endPoint:self.endPointD endFloorNo:self.endFloorNo];
    
    self.index = 0;
    
    [self.mapView setUserEnable:NO];
    
    [self.mapView removeMarkers];
    
    [self.view addSubview:self.floorLabel];
    
    for (IndoorFloorInfo *ifi in self.floorsAry) {
        if(ifi.floorIndex == [self.endFloorNo intValue])
        {
            self.floorLabel.text =ifi.namecode;
            break;
        }
    }
    
    self.floorLabel.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView removePathsData:self.indoorRR];
    [self.showWayView removeFromSuperview];
    [self.routeView removeFromSuperview];
    self.isRoute = NO;
    [self.mapView removeMarkers];
    [self.floorLabel removeFromSuperview];
     [self.mapView setUserEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark route

- (void)routeCalc:(PointD *)startPoint
     startFloorNo:(NSString *)startFloorNo
         endPoint:(PointD *)endPoint
       endFloorNo:(NSString *)endFloorNo
{
    //
    IndoorRouteRequest *irr = [[IndoorRouteRequest alloc]init];
    irr.buildID =self.spoiid;
    irr.startPointD = startPoint;
    irr.endPointD = endPoint;
    irr.startFloorNo = startFloorNo;
    irr.endFloorNo = endFloorNo;
    
    
    
    IndoorRouteCalc *irc = [[IndoorRouteCalc alloc]init];
    irc.deleteRoute = self;
    [irc IndoorRouteRequest:irr
                        key:@"4fb0cc587a308791908fe01e225d1ed3"];
    
    
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    UIAlertView *aView = [[UIAlertView alloc]initWithTitle:@"路算" message:[error domain] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [aView show];
}

- (void)onRouteRequestDone:(IndoorRouteRequest *)request response:(IndoorRouteResponse *)response
{
    if(response == NULL)
        return ;
    NSLog(@"response:%@",response);
    [self.view addSubview:self.routeView];
    [self.view addSubview:self.showWayView];
    [self.showWayView addSubview:self.showWayBtn];
    [self.showWayView addSubview:self.showWayLabel];
    
    int time = (int) (response.distance * 1.2 / 60);
    if (time == 0) {
        time = 1;
    }
    self.showWayLabel.text = [NSString stringWithFormat:@"大约%d分钟,步行%d米",time,response.distance];

    [self.routeView addSubview:self.backBtn];
    [self.mapView setPathsData:response];
    self.indoorRR = response;
    //self.poiView.hidden = YES;
    self.isRoute = YES;

   
    [self addRouteIcon:response];
    

    IndoorFullPath *ip =self.indoorRR.fullPath[[self.indoorRR.fullPath count]-1];
    PointD *pd = ip.pathPointLst[[ip.pathPointLst count]/2];
    if (pd) {
        [self.mapView setViewPortToLocationX:[pd.lon floatValue] withY:[pd.lat floatValue]];
    }
    
}

- (void)addRouteIcon:(IndoorRouteResponse *)response
{
    if ([response.fullPath count] == 0)
        return ;
     NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"bundle"];
    
    int i = 0;
    for (IndoorFullPath *ifp in response.fullPath) {
        NSString *imgName;
        if (ifp.sAction) {
            if([ifp.sAction isEqualToString:@"起点"]){
                imgName = [NSString stringWithFormat:@"%@/Indoor_path_Start",bundlePath];
            }
            if([ifp.sAction isEqualToString:@"楼梯"]){
                imgName = [NSString stringWithFormat:@"%@/Indoor_path_Escalator",bundlePath];
            }
            if([ifp.sAction isEqualToString:@"扶梯"]){
                imgName = [NSString stringWithFormat:@"%@/Indoor_path_Stair",bundlePath];
            }
            if([ifp.sAction isEqualToString:@"电梯"]){
                imgName = [NSString stringWithFormat:@"%@/Indoor_path_Lift",bundlePath];
            }
            
            PointD *po =  (PointD *)(ifp.pathPointLst[0]);
            if (po) {
                IndoorPoiInfo *info = [[IndoorPoiInfo alloc]init];
                info.x = [po.lon floatValue];
                info.y = [po.lat floatValue];
                [self.mapView addMarker:CGPointMake([po.lon floatValue], [po.lat floatValue]) withFloorNum:[ifp.floorNumber intValue] withPoiInfo:info withImageName:imgName];
            }

        }
      
        BOOL isInfo = NO;
        if([ifp.eAction isEqualToString:@"终点"]){
            imgName = [NSString stringWithFormat:@"%@/Indoor_path_End",bundlePath];
            isInfo = NO;
        }
        if([ifp.eAction isEqualToString:@"楼梯"]){
            imgName = [NSString stringWithFormat:@"%@/Indoor_path_Escalator",bundlePath];
            isInfo = YES;
            
        }
        if([ifp.eAction isEqualToString:@"扶梯"]){
            imgName = [NSString stringWithFormat:@"%@/Indoor_path_Stair",bundlePath];
            isInfo = YES;
        }
        if([ifp.eAction isEqualToString:@"电梯"]){
            imgName = [NSString stringWithFormat:@"%@/Indoor_path_Lift",bundlePath];
            isInfo = YES;
        }
        PointD *epo =  (PointD *)(ifp.pathPointLst[[ifp.pathPointLst count]-1]);
        if (epo) {
            IndoorPoiInfo *einfo = [[IndoorPoiInfo alloc]init];
            einfo.x = [epo.lon floatValue];
            einfo.y = [epo.lat floatValue];
            IndoorMarkerView *eMarkView = [self.mapView addMarker:CGPointMake([epo.lon floatValue], [epo.lat floatValue]) withFloorNum:[ifp.floorNumber intValue] withPoiInfo:einfo withImageName:imgName];
            
            if (isInfo) {
                IndoorFullPath *ifpnext  =  response.fullPath[i+1];
                UIImageView *imv = [self.mapView generatePromptBubble:[NSString stringWithFormat:@"坐%@到%@层",ifp.eAction,ifpnext.floorName]];
                imv.frame = CGRectMake(-20, -55, imv.image.size.width, imv.image.size.height);
                [eMarkView addSubview:imv];
            }
           
        }

        i++;
    }
}



- (void)floorBtnAction:(int)floorIndex
{
    [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",floorIndex]];
    [self.mapView updateScale:(0.1f)];
    if (floorIndex == 1) {
//        CGPoint point;
//        point.x =116.518539;
//        point.y =39.9242401;
//        [self.mapView updateUserLoc:point withFloorNum:1];
    }
}


#pragma mark action
- (void)onTapShowWay
{
    [self.mapView loadFloorWithIndex:self.startFloor];
    
    if([self.indoorRR.fullPath count]>0)
    {
        IndoorFullPath *ifp = self.indoorRR.fullPath[0];
        self.showWayLabel.text = [NSString stringWithFormat:@"步行%d米",ifp.segDistance];
        self.showWayBtn.hidden = YES;
        if([self.indoorRR.fullPath count] > 1)
            [self.showWayView addSubview:self.perBtn];
        [self.showWayView addSubview:self.nextBtn];
        
        IndoorFullPath *ip =self.indoorRR.fullPath[0];
        PointD *pd = ip.pathPointLst[0];
        if (pd) {
            [self.mapView setViewPortToLocationX:[pd.lon floatValue] withY:[pd.lat floatValue]];
        }
        
        self.floorLabel.text    =ip.floorName;
        self.floorLabel.hidden  =NO;
        
        [self.mapView setUserEnable:NO];
        
    }
}

- (void)onTapPer
{
    self.index--;
    if (self.index >= 0) {
        IndoorFullPath *ifp = self.indoorRR.fullPath[self.index];
        [self.mapView loadFloorWithIndex:ifp.floorNumber];
        if (ifp) {
            PointD *pd = ifp.pathPointLst[0];
            if (pd) {
                [self.mapView setViewPortToLocationX:[pd.lon floatValue] withY:[pd.lat floatValue]];
            }

        }
        self.showWayLabel.text = [NSString stringWithFormat:@"步行%d米",ifp.segDistance];
        self.floorLabel.text =ifp.floorName;
        
    }else
      self.index++;
    
    [self.mapView setUserEnable:NO];
}

- (void)onTapNext
{
    self.index++;
    if (self.index <= [self.indoorRR.fullPath count]-1) {
        IndoorFullPath *ifp = self.indoorRR.fullPath[self.index];
        [self.mapView loadFloorWithIndex:ifp.floorNumber];
        if (ifp) {
            PointD *pd = ifp.pathPointLst[0];
            if (pd) {
                [self.mapView setViewPortToLocationX:[pd.lon floatValue] withY:[pd.lat floatValue]];
            }
            
        }
        self.showWayLabel.text = [NSString stringWithFormat:@"步行%d米",ifp.segDistance];
        
        
        self.floorLabel.text =ifp.floorName;
    }else
       self.index--;
    [self.mapView setUserEnable:NO];
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
        _showWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10, self.showWayView.frame.size.width, 20)];
        _showWayLabel.backgroundColor = [UIColor clearColor];
        _showWayLabel.textColor = [UIColor blackColor];
        _showWayLabel.font = [UIFont systemFontOfSize:15];
        _showWayLabel.textAlignment = NSTextAlignmentCenter;
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

- (UIButton *)perBtn
{
    if (!_perBtn) {
        _perBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _perBtn.frame = CGRectMake(10,5, 40, 30);
        [_perBtn setTitle:@"<" forState:UIControlStateNormal];
        _perBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        [_perBtn addTarget:self action:@selector(onTapPer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _perBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(self.showWayView.frame.size.width-60,5, 40, 30);
        [_nextBtn setTitle:@">" forState:UIControlStateNormal];
        _nextBtn.backgroundColor = [UIColor colorWithRed:(float)76/255 green:(float)145/255 blue:(float)249/255 alpha:1.0];
        [_nextBtn addTarget:self action:@selector(onTapNext) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}


- (UILabel *)floorLabel
{
    if (!_floorLabel) {
        _floorLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60,100, 40, 30)];
        _floorLabel.backgroundColor = [UIColor grayColor];
        _floorLabel.textColor = [UIColor whiteColor];
        _floorLabel.font = [UIFont systemFontOfSize:15];
        _floorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _floorLabel;
}

@end
