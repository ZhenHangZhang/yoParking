//
//  MsgTableViewCell.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "MsgTableViewCell.h"

@implementation MsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setViewsWithDic:(NSDictionary*)dic{

    self.nameL.text = dic[@"title"];
    
    self.priceL.text = dic[@"statusName"];
    
    
    self.effectL.text = dic[@"content"];
    
    self.startL.text = [ZHZTool dateStringFromNumberTimer:dic[@"createTime"]];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
