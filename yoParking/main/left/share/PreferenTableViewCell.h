//
//  PreferenTableViewCell.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *isUse;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIButton *sendBtnclick;

@property (weak, nonatomic) IBOutlet UILabel *priceL;

-(void)setViewsWithDic:(NSDictionary*)dic;



@end
