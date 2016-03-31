//
//  MapViewController.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"


@interface MapViewController : UIViewController<AMapNaviManagerDelegate,IFlySpeechSynthesizerDelegate>


@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;


@end
