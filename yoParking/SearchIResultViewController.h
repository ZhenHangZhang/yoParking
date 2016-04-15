//
//  SearchIResultViewController.h
//  testIndoorLibDemo
//
//  Created by auto on 15/11/6.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndoorSearchEngine.h"

@interface SearchIResultViewController : UIViewController

@property(nonatomic,strong)NSArray  *resultAry;
@property(nonatomic,strong)IndoorSearchEngine *inSEngine;

@end
