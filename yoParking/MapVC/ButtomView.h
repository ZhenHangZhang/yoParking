//
//  ButtomView.h
//  yoParking
//
//  Created by zhanghangzhen on 16/3/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

 @protocol butomVC <NSObject>

-(void)nav;

@end

@interface ButtomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;
 - (IBAction)navigationBtn:(id)sender;
- (IBAction)appointmentBtnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *accountL;
@property (weak, nonatomic) IBOutlet UILabel *totalNumL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;


@property(assign,nonatomic)id<butomVC>delegate;
-(void)setViewWithDic:(NSDictionary*)dic;


@end
