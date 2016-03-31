//
//  ZHZParkAnnoationView.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <AMapNaviKit/MAMapKit.h>

@interface ZHZParkAnnoationView : MAAnnotationView


@property (nonatomic, strong) UIImageView    *contentView;
@property (nonatomic, strong) UIImageView   *ivPinAnnotation;
//@property (nonatomic, strong) UIImageView   *ivBgPrice;
@property (nonatomic, strong) UILabel       *labPrice;
@property (nonatomic, strong) UILabel       *labNum;

-(void)annotationWithDic:(NSString*)dic;

@end
