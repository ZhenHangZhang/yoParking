//
//  PreferenTableViewCell.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "PreferenTableViewCell.h"

@implementation PreferenTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setViewsWithDic:(NSDictionary*)dic{

    self.isUse.text = dic[@"statusName"];
    
    if ([dic[@"leftDays"] integerValue] == 0) {
        self.sendBtnclick.hidden = YES;
    }else{
        self.sendBtnclick.hidden = NO;
    }
    self.priceL.text = [NSString stringWithFormat:@"%@",dic[@"balance"]] ;
    self.contentL.text = [ZHZTool dateStringFromNumberTimer:dic[@"expireTime"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
