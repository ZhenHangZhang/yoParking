
#import "AppDelegate.h"
#import "MapViewController.h"
//#import <MAMapKit/MAMapKit.h>
#import "SearchViewController.h"
#import "CommonAnnotation.h"
#import "ZHZParkAnnoation.h"
#import "ZHZParkAnnoationView.h"
#import "WJAdsView.h"
#import "AdViewController.h"
#import "ButtomView.h"
#import "TableViewController.h"
#import "SingleShow.h"
#import "ZHZPolylineView.h"
#import <MapKit/MapKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MapViewController ()<MAMapViewDelegate,CLLocationManagerDelegate,SearchResultDelegate,WJAdsViewDelegate,butomVC,AMapNaviViewControllerDelegate>
{
    NSString    *reqKey;
    NSString    *mapRadius;
    NSString    *mapSize;
    WJAdsView *adsView;
    NSDictionary*seletedDic;
    NSInteger overlarNum;
    //占道划线
    NSMutableArray *overLineArr;
    //占道划线距离
    NSMutableArray *overLineDis;
    //占道划线模型
    NSMutableArray *overLineM;
    
    //终点
    AMapNaviPoint *_endPoint;
 }
@property(nonatomic,strong)ButtomView*buttomV;
@property(nonatomic,strong)CLLocationManager*locationManager;
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,assign)NSInteger updateFlag;
@property(nonatomic,assign)CLLocationCoordinate2D userCoordinate;
@property (nonatomic,assign) MACoordinateRegion userRegion;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) CommonAnnotation *centerAnnotation;
@property (nonatomic, assign) CLLocationCoordinate2D tempCLLocation; // 临时储存中心点的信息
@property(nonatomic,assign)float zoomB;
@property(nonatomic,assign)float zlab;
//停车场
@property(nonatomic,copy)NSMutableArray *arrAnnotations;
//停车场大头针
@property(nonatomic,copy)NSMutableArray *Annotations;


@property (nonatomic, strong) AMapNaviViewController *MapnaviViewController;

@end

@implementation MapViewController
-(ButtomView *)buttomV{
    if (_buttomV == nil) {
        _buttomV = [[[NSBundle mainBundle]loadNibNamed:@"ButtomView" owner:self options:nil] objectAtIndex:0];
        
        _buttomV.delegate = self;
    }return _buttomV;
}
-(NSMutableArray *)arrAnnotations{

    if (_arrAnnotations == nil) {
        _arrAnnotations = [[NSMutableArray alloc]init];
    }return _arrAnnotations;
}
-(NSMutableArray *)Annotations{
    
    if (_Annotations == nil) {
        _Annotations = [[NSMutableArray alloc]init];
    }return _Annotations;
}
- (void)initNaviManager
{
    if (self.naviManager == nil)
    {
        self.naviManager = [[AMapNaviManager alloc] init];
    }
    
    [self.naviManager setDelegate:self];
}

- (void)initNaviViewController
{
    if (self.MapnaviViewController == nil)
    {
        self.MapnaviViewController = [[AMapNaviViewController alloc] initWithDelegate:self];
      }
     [self.MapnaviViewController setDelegate:self];
}

- (void)initIFlySpeech
{
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;

}
-(MAMapView *)mapView{
     if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.mapType = MAMapTypeStandard;
        _mapView.delegate = self;
        _mapView.rotationDegree = 0;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.showsBuildings = NO;
        _mapView.rotateEnabled = NO;
        _mapView.skyModelEnable = NO;
        _mapView.showTraffic = NO;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        _mapView.zoomLevel = 15;
        _mapView.logoCenter = CGPointMake(25, CGRectGetHeight(self.view.bounds)-70-20);
        // 定位管理器
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
     }return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      overLineArr = [[NSMutableArray alloc]init];
     overLineM = [[NSMutableArray alloc]init];
      overLineDis = [[NSMutableArray alloc]init];
    
    //配置用户Key
    [AMapNaviServices sharedServices].apiKey =AMKEY;
    [MAMapServices sharedServices].apiKey = AMKEY;
    [self.view addSubview:self.mapView];

     self .automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"约停车";
     UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
     self.navigationController.navigationItem.rightBarButtonItem = rightBtn;
    _updateFlag = 0;
    [self setMap];
    [self setMapInfo];
    [self setView];
    [self performSelector:@selector(showAdsView)
                withObject:nil
                afterDelay:2];
      [self setBtns];
     self.buttomV.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, 100);
     [self.view addSubview:self.buttomV];
     
     [SingleShow show].block = ^(CLLocationCoordinate2D coord,NSString *address,int tag){
         [self searchWithPoint:coord address:address tag:tag];
      };
    
    [self initNaviManager];
    [self initIFlySpeech];
 }

#pragma mark - 导航 路径规划Actions
- (void)startEmulatorNavi
{
    [self calculateRoute];
}

- (void)calculateRoute
{
    NSArray *endPoints = @[_endPoint];
    
    [self.naviManager calculateDriveRouteWithEndPoints:endPoints wayPoints:nil drivingStrategy:0];
}

#pragma mark -地图搜索回调-
 - (void)searchWithPoint:(CLLocationCoordinate2D)coordinate address:(NSString *)addr tag:(int)flag{
    
    if (flag == 1) {
         self.mapView.zoomLevel = 16.5;
    }else{
        self.mapView.zoomLevel = 13;
     }
     [self.mapView setCenterCoordinate:coordinate];
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
    TableViewController *vc = [[TableViewController alloc]init];
    vc.dataArr = self.arrAnnotations;
     [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -地图功能按钮-
-(void)setBtns{
    UIButton *useBtn = [MyControl creatButtonWithFrame:CGRectMake(10, SCREEN_HEIGHT -100 - 20 - 20, 40, 40) target:self sel:@selector(btnclicks:) tag:1 image:@"user_location.png" title:nil];
    [self.view addSubview:useBtn];
    UIButton *bigBtn = [MyControl creatButtonWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 100 - 20 - 20, 40, 40) target:self sel:@selector(btnclicks:) tag:2 image:@"jia_bj" title:nil];
    [self.view addSubview:bigBtn];
    UIButton *smallBtn = [MyControl creatButtonWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 100 - 20 - 60 - 20, 40, 40) target:self sel:@selector(btnclicks:) tag:3 image:@"jian_bj@2x.png" title:nil];
    [self.view addSubview:smallBtn];
    
    UIButton *monthBtn = [MyControl creatButtonWithFrame:CGRectMake(SCREEN_WIDTH - 50,20 + 64, 40 , 40) target:self sel:@selector(btnclicks:) tag:4 image:@"byicon_n@2x.png" title:nil];
    [self.view addSubview:monthBtn];

    UIButton *planeBtn = [MyControl creatButtonWithFrame:CGRectMake(SCREEN_WIDTH - 50, 64 +60+10, 40, 40) target:self sel:@selector(btnclicks:) tag:5 image:@"aircraft_icon_n@2x.png" title:nil];
    [self.view addSubview:planeBtn];

    UIButton *adBtn = [MyControl creatButtonWithFrame:CGRectMake(SCREEN_WIDTH - 50,  64+120, 40, 40) target:self sel:@selector(btnclicks:) tag:6 image:@"gift_n@2x.png" title:nil];
    [self.view addSubview:adBtn];
}
-(void)btnclicks:(UIButton*)sender{

    switch (sender.tag) {
        case 1:
        {
            //用户位置
            [self.mapView setCenterCoordinate:self.userCoordinate animated:YES];
        }
            break;
        case 2:
        {
            //放大

            [self zoomLevelPlus];
            
        }
            break;

        case 3:
        {
            //缩小

            [self zoomLevelInsert];
        }
            break;

        case 4:
        {
            //包月

        }
            break;

        case 5:
        {
            //机场
         }
            break;

        case 6:
        {
             [self showAdsView];
        }
            break;
            
         default:
            break;
    }
    
    NSLog(@"%ld",(long)sender.tag);
}
-(void)zoomLevelPlus{
    
    self.zlab+=0.5;
    if (self.zlab >=19) {
        self.zlab = 19;
    }
     [UIView animateWithDuration:0.5 animations:^{
         
         [self.mapView setZoomLevel:self.zlab animated:YES];
//        self.mapView.zoomLevel = self.zlab;
    }];
}
-(void)zoomLevelInsert{
     self.zlab-=0.5;
    if (self.zlab <= 3) {
        self.zlab = 3;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.mapView setZoomLevel:self.zlab animated:YES];

//        self.mapView.zoomLevel = self.zlab;
    }];
}
-(void)showAdsView{
     AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.backgroundColor = [UIColor colorWithWhite:20
                                                   alpha:0.3];
    adsView = [[WJAdsView alloc] initWithWindow:app.window];
    adsView.tag = 10;
    adsView.delegate = self;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.width)];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"视图 %d", i+1];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor colorWithRed:0 green:183.0/255.0 blue:238.0/255.0 alpha:1.000];
        label.layer.cornerRadius = adsView.mainContainView.frame.size.width/2;
        label.layer.masksToBounds = YES;
        [array addObject:label];
    }
    [self.view addSubview:adsView];
    adsView.containerSubviews = array;
    [adsView showAnimated:YES];
}
- (void)hide{
    adsView = (WJAdsView *)[self.view viewWithTag:10];
    [adsView hideAnimated:YES];
}
#pragma mark -地图导航-
-(void)nav{
     NSString *strCoord = seletedDic[@"coordinateAmap"];
    NSString *strLongitude = nil;
    NSString *strLatitude = nil;
    NSRange range = [strCoord rangeOfString:@","];
        if (range.location!=NSNotFound) {
             strLongitude = [strCoord substringToIndex:range.location];
             strLatitude = [strCoord substringFromIndex:range.location+1];
            _endPoint = [AMapNaviPoint locationWithLatitude:[strLatitude floatValue]
                                                  longitude:[strLongitude floatValue]];
            [self startEmulatorNavi];
         }
 //    NSArray *mapSchemeArr = @[@"comgooglemaps://",@"iosamap://navi",@"baidumap://map/"];
//    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果地图", nil];
//     for (int i = 0; i < [mapSchemeArr count]; i++) {
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
//            if (i == 0) {
//                [appListArr addObject:@"google地图"];
//            }else if (i == 1){
//                [appListArr addObject:@"高德地图"];
//            }else if (i == 2){
//                [appListArr addObject:@"百度地图"];
//            }
//        }
//    }
//    NSString *sheetTitle = [NSString stringWithFormat:@"导航到 %@",seletedDic[@"name"]];
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:sheetTitle preferredStyle:UIAlertControllerStyleActionSheet];
//    NSString *strCoord = seletedDic[@"coordinateAmap"];
//    NSString *strLongitude = nil;
//    NSString *strLatitude = nil;
//    NSLog(@"%@",seletedDic);
//    NSRange range = [strCoord rangeOfString:@","];
//    if (range.location!=NSNotFound) {
//         strLongitude = [strCoord substringToIndex:range.location];
//         strLatitude = [strCoord substringFromIndex:range.location+1];
//    }
//      if ([appListArr containsObject:@"苹果地图"]) {
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"苹果");
//            CLLocationCoordinate2D to;
//            to.longitude = [[strCoord substringToIndex:range.location] floatValue];
//            to.latitude = [[strCoord substringFromIndex:range.location+1] floatValue];
//            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
//            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
//            }]];
//    }
//    if ([appListArr containsObject:@"google地图"]) {
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"谷歌");
//             NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%@,%@&directionsmode=transit",self.userCoordinate.latitude,self.userCoordinate.longitude,strLatitude,strLongitude];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//          }]];
//    }
//     if ([appListArr containsObject:@"高德地图"]) {
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"高德");
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%@&lon=%@&dev=0&style=2",@"",strLatitude,strLongitude]];
//            // 这才是真正的吊起地图
//            [[UIApplication sharedApplication] openURL:url];
//        }]];
//    }
//    if ([appListArr containsObject:@"百度地图"]) {
//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"百度");
//            
//            NSString *baiduCoor = seletedDic[@"coordinateBaidu"];
//            NSRange bdRange = [baiduCoor rangeOfString:@","];
//            if (bdRange.location != NSNotFound) {
//                NSString* bdstrLongitude = [strCoord substringToIndex:range.location];
//                NSString*bdstrLatitude = [strCoord substringFromIndex:range.location+1];
//                
//                NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%@,%@&&mode=driving",self.userCoordinate.latitude,self.userCoordinate.longitude,bdstrLatitude,bdstrLongitude];
//                NSURL *url = [NSURL URLWithString:stringURL];
//                [[UIApplication sharedApplication] openURL:url];
//            }
//         }]];
//     }
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark -广告-
- (void)wjAdsViewTapMainContainView:(WJAdsView *)view currentSelectIndex:(long)selectIndex{
     AppDelegate *dele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     AdViewController *vc = [[AdViewController alloc]init];
    vc.title = @"优惠";
//    [self animationView];
    [ dele.mainNavigationController pushViewController:vc animated:YES];
    NSLog(@"点击主内容视图:--%ld",selectIndex);
}
#pragma mark -获取数据-
 -(void)getParkAnnoation:(NSDictionary*)dict{
    CGFloat width = self.mapView.bounds.size.width;
    CGFloat height = self.mapView.bounds.size.height;
    CLLocationCoordinate2D topLeft = [self.mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D topRight = [self.mapView convertPoint:CGPointMake(width, 0) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D bottomRight = [self.mapView convertPoint:CGPointMake(width, height) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D bottomLeft = [self.mapView convertPoint:CGPointMake(0, height) toCoordinateFromView:self.mapView];
    NSString *strBounds = [NSString stringWithFormat:@"%f,%f;%f,%f;%f,%f;%f,%f",topLeft.longitude,topLeft.latitude,topRight.longitude,topRight.latitude,bottomRight.longitude,bottomRight.latitude,bottomLeft.longitude,bottomLeft.latitude];
    NSMutableDictionary *dictPara = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [dictPara setObject:strBounds forKey:@"bounds"];
    [DownData getUrl:@"http://b2c.ezparking.com.cn/rtpi-service/parking" params:dictPara success:^(id data) {
        [self.arrAnnotations removeAllObjects];
        [overLineArr removeAllObjects];
        if ([data isKindOfClass:[NSDictionary class]]) {
            [self.arrAnnotations addObject:data];
            NSLog(@"%@",self.arrAnnotations);
            
         }else{
            [self.arrAnnotations addObjectsFromArray:data];
              for (NSDictionary *dic in self.arrAnnotations) {
                 if ([dic[@"name"] containsString:@"占道"]) {
                     [ overLineArr addObject:dic];
                 }
              }
             if ( overLineArr.count > 0) {
                 [self setLine];
             }
        }
        NSLog(@"count====>%ld",(unsigned long)self.arrAnnotations.count);
        [self addParkAnnoation];
    } fail:^(NSError *error) {
}];
}
 #pragma mark -地图初始化-
-(void)setMap{
    }
-(void)setMapInfo{
    // 地图的半径
    mapRadius = [[NSUserDefaults standardUserDefaults] objectForKey:MAP_RADIUS];
    // 请求的Key
    reqKey = [[NSUserDefaults standardUserDefaults] objectForKey:REQ_KEY1];     // 地图的半径
    // 如果为空, 则默认1000
    if (mapRadius==nil) {
        mapRadius = @"1000";
    }
    // 地图的Size
    mapSize = [[NSUserDefaults standardUserDefaults] objectForKey:MAP_SIZE];
    if (mapSize==nil) {
        mapSize = @"20";
    }
}
#pragma mark -地图添加大头针-
 -(void)addParkAnnoation{
    if (self.arrAnnotations.count>0) {
        [self.mapView removeAnnotations:self.Annotations];
    }
    NSMutableArray *annotations = [[NSMutableArray alloc]initWithCapacity:20];
    for (NSInteger i =0;i<self.arrAnnotations.count;i++)
    {
        NSDictionary *park = [self.arrAnnotations objectAtIndex:i];
        NSString *strCoord = park[@"coordinateAmap"];
            NSRange range = [strCoord rangeOfString:@","];
            if (range.location!=NSNotFound)
            {
                CLLocationCoordinate2D coordsss;
                coordsss.longitude = [[strCoord substringToIndex:range.location] floatValue];
                coordsss.latitude = [[strCoord substringFromIndex:range.location+1] floatValue];
                ZHZParkAnnoation *annotation = [[ZHZParkAnnoation alloc] init];
                annotation.coordinate = coordsss;
                annotation.tag = i;
                [annotations addObject:annotation];
            }
    }
if (annotations.count>0) {
    [self.Annotations addObjectsFromArray:annotations];
         [self.mapView addAnnotations:annotations];
    }
}
#pragma mark -地图添加自定义大头针的代理方法-
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[ZHZParkAnnoation class]])
    {
        ZHZParkAnnoation *parkAnnotation = (ZHZParkAnnoation *)annotation;
        static NSString *identifier = @"parkAnnotation";
        // 地图上的小图标
        ZHZParkAnnoationView *pinView = (ZHZParkAnnoationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (pinView==nil) {
            pinView = [[ZHZParkAnnoationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        [pinView annotationWithDic:[NSString stringWithFormat:@"%ld", (long)(long)parkAnnotation.tag]];
        return pinView;
    }
    return nil;
}
#pragma mark -地图自定义大头针的点击方法-
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{

    if ([view isKindOfClass:[ZHZParkAnnoationView class]])
    {
        ZHZParkAnnoation *parkAnnotation = (ZHZParkAnnoation *)view.annotation;
        NSDictionary *dic = [self.arrAnnotations objectAtIndex:parkAnnotation.tag];
        self.tabBarController.tabBar.hidden = YES;
        [self.buttomV setViewWithDic:dic];
        seletedDic = dic;
          [UIView animateWithDuration:0.5 animations:^{
        self.buttomV.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100);
         }];
    }
}
 #pragma mark -地图用户位置更新-
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation)
    {
        self.userCoordinate = userLocation.coordinate;
        if (self.updateFlag==0)
        {
            self.updateFlag++;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dictToken = [defaults objectForKey:TOKEN_INFO];
            id defaultCoord = [dictToken objectForKey:@"defaultCoordinate"];
            if ([defaultCoord isEqual:[NSNull null]]==NO)
            {
                NSString *defaultCoordinate = (NSString *)defaultCoord;
                if (defaultCoordinate.length>0) {
                    NSRange range = [defaultCoordinate rangeOfString:@","];
                    if (range.location!=NSNotFound)
                    {
                        CLLocationCoordinate2D coordsss;
                        coordsss.longitude = [[defaultCoordinate substringToIndex:range.location] floatValue];
                        coordsss.latitude = [[defaultCoordinate substringFromIndex:range.location+1] floatValue];
                        self.mapView.centerCoordinate = coordsss  ;
                    }
                    else
                    {
                        self.mapView.centerCoordinate = self.userCoordinate ;
                    }
                }
                else
                {
                    self.mapView.centerCoordinate = self.userCoordinate ;
                }
            }
            else
            {
                self.mapView.centerCoordinate = self.userCoordinate ;
            }
        }
    }
}
#pragma mark - CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@,%@",manager.location,[error debugDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            [self openGPSTips];
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
}
 -(void)openGPSTips{
    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alet show];
}
#pragma mark -地图增加划线功能-
 -(void)setLine{
      [self.mapView removeOverlays:self.mapView.overlays];
      overlarNum = 0;
      if ( overLineM.count > 0) {
         [ overLineM removeAllObjects];
      }
     if ( overLineDis.count > 0) {
         [ overLineDis removeAllObjects];
     }
      for (int i = 0; i < overLineArr.count; i++) {
         //构造折线数据对象
          if ([(overLineArr[i][@"entranceCoordinatesAmap"])isEqual:[NSNull null]]||[(overLineArr[i][@"exitusCoordinatesAmap"])isEqual:@""]) {
             continue;
         }
         NSArray *arr1 = [overLineArr[i][@"entranceCoordinatesAmap"] componentsSeparatedByString:@","];
         NSArray *arr2 = [overLineArr[i][@"exitusCoordinatesAmap"] componentsSeparatedByString:@","];
          CLLocationCoordinate2D commonPolylineCoords[2];
         commonPolylineCoords[0].latitude = [arr1[1] floatValue];
         commonPolylineCoords[0].longitude = [arr1[0] floatValue];
          commonPolylineCoords[1].latitude = [arr2[1] floatValue];
         commonPolylineCoords[1].longitude = [arr2[0] floatValue];
          //两个点之间的屏幕距离；
         CLLocationCoordinate2D starCoordinate = CLLocationCoordinate2DMake([arr1[1] floatValue], [arr1[0] floatValue]);
         CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([arr2[1] floatValue], [arr2[0] floatValue]);
         float distance = [self fromCLLocationCoordinate2D:starCoordinate toEndCLLocationCoordinate2D:endCoordinate];
         [overLineDis addObject:[NSString stringWithFormat:@"%f",distance]];
         //构造折线对象
         MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
         [ overLineM addObject:commonPolyline];
      }
     //在地图上添加折线对象
     [_mapView addOverlays: overLineM];
 }
/**
 *  两点之间的距离
 */
-(float)fromCLLocationCoordinate2D:(CLLocationCoordinate2D)startCoordinate toEndCLLocationCoordinate2D:(CLLocationCoordinate2D)endCoordinate{
    CGPoint point1 = [self.mapView convertCoordinate:startCoordinate toPointToView:self.view] ;
    CGPoint point2 =[self.mapView convertCoordinate:endCoordinate toPointToView:self.view];
    return [self distanceFromPointX:point1 distanceToPointY:point2];
}
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    //下面就是高中的数学，不详细解释了
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]){
    ZHZPolylineView *polylineView = [[ZHZPolylineView alloc] initWithPolyline:overlay];
        [polylineView srtOverLay:self.mapView.zoomLevel totalPlaces:overLineArr[overlarNum][@"totalPlaces"] distanceArr: overLineDis[overlarNum]];
        return polylineView;
    }
    return nil;
 }
#pragma mark -地图区域发生变化-
-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [UIView animateWithDuration:0.5 animations:^{
        self.buttomV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 100);
    }];
    self.tabBarController.tabBar.hidden = NO;
 }
-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"overlays =====>%ld",(unsigned long)self.mapView.overlays.count);
      if (self.updateFlag == 0){
        return;
    }
    self.updateFlag++;
    self.centerCoordinate = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    
    if (self.centerAnnotation==nil) {
        self.centerAnnotation = [[CommonAnnotation alloc] init];
    }
    // 定位的中心点
    self.centerAnnotation.coordinate = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    // 临时存储中心点位置
    self.tempCLLocation = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    self.zoomB = self.mapView.zoomLevel;
     self.zlab = self.zoomB;
    NSString *strCenter = [NSString  stringWithFormat:@"%f,%f,%@",self.mapView.centerCoordinate.longitude,self.mapView.centerCoordinate.latitude,mapRadius];
    NSDictionary *dictParamas = @{@"key":reqKey,@"type":@"status",@"size":mapSize,@"center":strCenter};
    [self getParkAnnoation:dictParamas];
    if (self.updateFlag>2) {
        [self centerViewAnimation];
    }
}
//中心点
-(void)centerViewAnimation{
    
    
}
#pragma mark - AMapNaviManager Delegate

- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error
{
    NSLog(@"error:{%@}",error.localizedDescription);
}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    NSLog(@"didPresentNaviViewController");
    
    [self.naviManager startGPSNavi];
}
 - (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    NSLog(@"OnCalculateRouteSuccess");
    
    if (self.MapnaviViewController == nil)
    {
        [self initNaviViewController];
    }
    
    [self.naviManager presentNaviViewController:self.MapnaviViewController animated:YES];
}
 - (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager
{
    return YES;
}
 - (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder)
    {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            if (soundStringType ==1) {
                NSString *str = [NSString stringWithFormat:@"上海喜 泊 客 约 停 车 为您导航:%@",soundString];
                [_iFlySpeechSynthesizer startSpeaking:str];
            }else{
                [_iFlySpeechSynthesizer startSpeaking:soundString];

            }
         });
    }
}
 #pragma mark - AManNaviViewController Delegate
 - (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_iFlySpeechSynthesizer stopSpeaking];
    });
    
    [self.naviManager stopNavi];
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.MapnaviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        self.MapnaviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        self.MapnaviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}

- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

#pragma mark - iFlySpeechSynthesizer Delegate

- (void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}
  //滑动侧视图
-(void)setView{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.view.frame.size.height)];
    v.backgroundColor = [UIColor clearColor];
    [self.view addSubview:v];
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
    
    AppDelegate *dele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
     CATransition * anima = [CATransition animation];
    [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    anima.duration = 0.8;
    anima.type = @"rippleEffect";
    anima.subtype = @"90ccw";
    [dele.mainNavigationController.view.layer addAnimation:anima forKey:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.navigationController);
    
//    self.navigationController.navigationBarHidden = NO;
    UIImageView *ivTitle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 14)];
    ivTitle.image = [UIImage imageNamed:@"main_title.png"];
    self.navigationController.navigationItem.titleView = ivTitle;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 }







@end
