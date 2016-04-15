//
//  ViewController.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

@class IndoorEn;
@class PointD;

@interface ViewController : UIViewController

@property(nonatomic,strong)  NSString *name;
@property(nonatomic,strong)  NSString *spoiid;
@property(nonatomic,strong)  NSString *startFloor;

- (void)loadSearchPoi:(IndoorEn *)en;
- (void)loadSearchAllPoi:(NSArray *)pois;

@end

