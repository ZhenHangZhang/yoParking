//
//  SelectPoiMapViewController.m
//  testIndoorLibDemo
//
//  Created by auto on 15/11/17.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import "SelectPoiMapViewController.h"
#import "IndoorMapView.h"
#import "InMapView.h"
#import "IndoorRouteRequest.h"
#import "SelectPoiViewController.h"

@interface SelectPoiMapViewController ()<IndoorMapViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)  IndoorMapView    *mapView;
@property(nonatomic,strong)  UIView           *poiView;
@property(nonatomic,strong)  UILabel          *poiLabel;
@property(nonatomic,strong)  NSArray          *floorsAry;
@property(nonatomic,strong)  PointD           *selLocation;
@property(nonatomic,strong)  IndoorPoiInfo    *poi;
@end

@implementation SelectPoiMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *fBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 190, 28)];
    fBtn.backgroundColor = [UIColor clearColor];
    [fBtn setTitle:@"楼层选择" forState:UIControlStateNormal];
    [fBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fBtn addTarget:self action:@selector(onFloor) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = fBtn;
    
    UIBarButtonItem* btnListItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onOK)];
    self.navigationItem.rightBarButtonItem = btnListItem;
    
    self.mapView = [InMapView sharedMapView].mapView;
    self.mapView.delegate = self;
    self.mapView.isPlottingScale = NO;
    self.mapView.iscompassView = NO;
    [self.view addSubview:self.mapView];
    
    [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",1 ]];
     self.poiLabel.text = [NSString stringWithFormat:@"%d层",1];
    
    [self.view addSubview:self.poiView];
    [self.poiView addSubview:self.poiLabel];
    
    [self.mapView removeMarkers];
    self.poi = nil;
    
    [self.mapView setUserEnable:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action
- (void)onOK
{
    SelectPoiViewController *vc = (SelectPoiViewController *)([self.navigationController viewControllers][1]);
    if ([vc isKindOfClass:[SelectPoiViewController class]]) {
        vc.poi = self.poi;
        vc.type = self.type;
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark floor
- (void)onFloor
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"楼层"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    ;
    
    NSArray *ary = [self.mapView getFloorInfos];
    self.floorsAry = ary;
    for (IndoorFloorInfo *info in ary) {
        [actionSheet addButtonWithTitle:info.namecode];
    }
    
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1;
    
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == self.floorsAry.count) {
        return;
    }
    
    IndoorFloorInfo *fs = self.floorsAry[buttonIndex];
    [self.mapView loadFloorWithIndex:[NSString stringWithFormat:@"%d",fs.floorIndex]];
    
    self.poiLabel.text =@"";
    self.poiLabel.text = [NSString stringWithFormat:@"%d层",(int)fs.floorIndex];
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

#pragma mark poi click
- (void)didTapClick:(IndoorMarkerView *)idoorMView
{
    if (idoorMView) {
        self.poiLabel.text = idoorMView.info.name;
    }
    
}

- (void)didTapPoint:(CGPoint)point withFloorNum:(int)num withPoiArray:(NSArray *)array
{
    NSLog(@"didTapPoint:%@",array);
    
    if([array count]<=0)
    {
        return ;
    }

    [self.mapView removeMarkers];
    IndoorPoiInfo *poi= (IndoorPoiInfo *)array[0];
    if (poi.type == 900 || poi.type == 100 || poi.type == 300) {
        return ;
    }

    
    [self.mapView addMarker:CGPointMake(poi.x, poi.y) withFloorNum:num withPoiInfo:poi withImageName:@"default_map_select_point_normal"];
    self.poiLabel.text = [NSString stringWithFormat:@"%d层 %@",(int)poi.floorNum,poi.name ];
    self.poi  = poi;
    
}

#pragma mark
- (UIView *)poiView
{
    if (!_poiView) {
        _poiView = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-120.0f, self.view.frame.size.width-2*20, 60)];
        _poiView.backgroundColor = [UIColor whiteColor];
    }
    
    return _poiView;
}

- (UILabel *)poiLabel
{
    if (!_poiLabel) {
        _poiLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.poiView.frame.size.width-2*20, 20)];
        _poiLabel.backgroundColor = [UIColor clearColor];
        _poiLabel.textColor = [UIColor grayColor];
        _poiLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _poiLabel;
}

@end
