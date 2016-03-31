
//
//  ZHZParkAnnoationView.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/23.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZParkAnnoationView.h"

@implementation ZHZParkAnnoationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -15);
        CGRect rect = CGRectMake(0, 0, 90, 33+30);
        self.bounds = rect;
        _ivPinAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.width-17)/2, 30, 17, 33)];
        [self addSubview:_ivPinAnnotation];
        
        _contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 28)];
        //        _contentView.backgroundColor = [UIColor clearColor];
        //
        //        _ivBgPrice = [[UIImageView alloc]initWithFrame:_contentView.bounds];
        _contentView.image = [UIImage imageNamed:@"annotationView.png"];
        //        [_contentView addSubview:_ivBgPrice];
        
        UIImageView *ivRingNum = [[UIImageView alloc]initWithFrame:CGRectMake(2, 3, 18, 18)];
        ivRingNum.backgroundColor = [UIColor clearColor];
        ivRingNum.image = [UIImage imageNamed:@"white_ring.png"];
        [_contentView addSubview:ivRingNum];
        
        _labNum = [[UILabel alloc]initWithFrame:ivRingNum.frame];
        _labNum.backgroundColor = [UIColor clearColor];
        _labNum.textColor = [UIColor whiteColor];
        _labNum.font = [UIFont systemFontOfSize:12];
        _labNum.adjustsFontSizeToFitWidth = YES;
        _labNum.textAlignment = NSTextAlignmentCenter;
        //        _labNum.text = @"128";
        [_contentView addSubview:_labNum];
        
        UIImageView *ivRingBook = [[UIImageView alloc]initWithFrame:CGRectMake(_contentView.bounds.size.width-20, 3, 18, 18)];
        ivRingBook.backgroundColor = [UIColor clearColor];
        ivRingBook.image = [UIImage imageNamed:@"white_ring.png"];
        [_contentView addSubview:ivRingBook];
        
        UILabel *labBook = [[UILabel alloc]initWithFrame:ivRingBook.frame];
        labBook.backgroundColor = [UIColor clearColor];
        labBook.textColor = [UIColor whiteColor];
        labBook.font = [UIFont systemFontOfSize:12];
        labBook.textAlignment = NSTextAlignmentCenter;
        labBook.text = @"约";
        [_contentView addSubview:labBook];
        _labPrice = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _contentView.bounds.size.width-40, 23)];
        _labPrice.backgroundColor = [UIColor clearColor];
        _labPrice.font = [UIFont systemFontOfSize:13];
        //        _labPrice.adjustsFontSizeToFitWidth = YES;
        _labPrice.textColor = [UIColor whiteColor];
        _labPrice.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_labPrice];
        [self addSubview:_contentView];
    }
    return self;
}

-(void)annotationWithDic:(NSString*)dic{
    self.ivPinAnnotation.image = [UIImage imageNamed:@"location_low.png"];
     self.labPrice.text = dic;
     self.labNum.text = dic;
}

 /*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
