//
//  SearchViewController.h
//  Park
//
//  Created by  apple on 15/8/3.
//  Copyright (c) 2015年  apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@protocol SearchResultDelegate <NSObject>
/**
 *
 *
 *  @param coordinate 坐标
 *  @param addr       地址
 *  @param flag       标记  记录 == 1    商圈 == 2
 */
- (void)searchWithPoint:(CLLocationCoordinate2D)coordinate address:(NSString *)addr tag:(int)flag;
@end

@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) id<SearchResultDelegate> searchDelegate;
@property (nonatomic, copy) NSString *parkCity;

+(instancetype)show;

@end
