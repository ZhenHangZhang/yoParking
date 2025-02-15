//
//  ZHZTabBar.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZTabBar.h"



@interface ZHZTabBar ( )
@property(nonatomic,strong)UIButton*plusBtn;
@end


@implementation ZHZTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) {
            self.backgroundImage = [UIImage imageWithName:@"tabbar_background"];
        }
        self.selectionIndicatorImage = [UIImage imageWithName:@"navigationbar_button_background"];
        // 添加加号按钮
        [self setupPlusButton];
    }
    return self;
}
-(void)setupPlusButton{

    UIButton *plusButton = [[UIButton alloc] init];
    // 设置背景
//    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"]forState:UIControlStateNormal];
//    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    // 设置图标
    
    [plusButton setTitle:@"搜索" forState:UIControlStateNormal];
    [plusButton setTitle:@"搜索" forState:UIControlStateHighlighted];

//    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_message_center_selected" ] forState:UIControlStateNormal];
//    [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    // 添加
    [self addSubview:plusButton];
    self.plusBtn = plusButton;
}

-(void)plusClick{
//通知代理：
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
    
        [self.tabBarDelegate tabBarDidClickedPlusButton:self];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    // 设置plusButton的frame
    [self setupPlusButtonFrame];
    
    // 设置所有tabbarButton的frame
    [self setupAllTabBarButtonsFrame];

}
-(void)setupPlusButtonFrame{
    self.plusBtn.size = CGSizeMake(50, 50);
    self.plusBtn.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}
-(void)setupAllTabBarButtonsFrame{
    int index = 0;
    // 遍历所有的button
    for (UIView *tabBarButton in self.subviews) {
        // 如果不是UITabBarButton， 直接跳过
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        // 根据索引调整位置
        [self setupTabBarButtonFrame:tabBarButton atIndex:index];
        
        // 索引增加
        index++;
    }
}
/**
 *  设置某个按钮的frame
 *
 *  @param tabBarButton 需要设置的按钮
 *  @param index        按钮所在的索引
 */
- (void)setupTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index
{
    // 计算button的尺寸
    CGFloat buttonW = self.width / (self.items.count + 1);
    CGFloat buttonH = self.height;
    
    tabBarButton.width = buttonW;
    tabBarButton.height = buttonH;
    if (index >= 1) {
        tabBarButton.x = buttonW * (index + 1);
    } else {
        tabBarButton.x = buttonW * index;
    }
    tabBarButton.y = 0;
}


@end
