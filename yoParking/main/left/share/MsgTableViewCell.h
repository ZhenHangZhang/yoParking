//
//  MsgTableViewCell.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *effectL;
@property (weak, nonatomic) IBOutlet UILabel *startL;


-(void)setViewsWithDic:(NSDictionary*)dic;


@end
