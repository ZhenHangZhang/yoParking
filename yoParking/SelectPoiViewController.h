//
//  SelectPoiViewController.h
//  testIndoorLibDemo
//
//  Created by auto on 15/11/10.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PointD;
@class IndoorMarkerView;
@class IndoorPoiInfo;

@interface SelectPoiViewController : UIViewController

@property(nonatomic,strong)   PointD *userLocation;
@property(nonatomic,strong)  PointD *endLocation;
@property(nonatomic,strong)  IndoorMarkerView *selMarkView;
@property(nonatomic,strong)  IndoorPoiInfo *poi;
@property(nonatomic,strong)  NSString *type;
@property(nonatomic,strong)  NSString *spoid;

@end
