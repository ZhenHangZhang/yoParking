//
//  RouteViewController.h
//  testIndoorLibDemo
//
//  Created by auto on 15/11/20.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PointD;
@class IndoorRouteRequest;

@interface RouteViewController : UIViewController

@property(nonatomic,strong)  NSString *name;
@property(nonatomic,strong)  NSString *spoiid;
@property(nonatomic,strong)  NSString *startFloor;
@property(nonatomic,strong)  NSString *buildID;
@property(nonatomic,strong)  PointD   *startPointD;
@property(nonatomic,strong)  PointD   *endPointD;
@property(nonatomic,strong)  NSString *startFloorNo;
@property(nonatomic,strong)  NSString *endFloorNo;

@end
