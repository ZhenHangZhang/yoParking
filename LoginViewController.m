//
//  LoginViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/21.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "LoginViewController.h"
#import "MyControl.h"
#import "RegisViewController.h"
#import "AboutViewController.h"
#import "DownData.h"
#import "ZHZTool.h"

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITextField *_userTF;
    UITextField *_passTF;
    BOOL isAgree ;
    UIButton *btnProtocol;
    UIButton *_btnCode;
}
@end

@implementation LoginViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    [self setNavBar];
    [self setBtn];
    
    [self setLoginBtn];
    
   }
 -(void)setLoginBtn{
    UIButton *loginBtn = [MyControl creatButtonWithFrame:CGRectMake(60, SCREEN_HEIGHT - 250 + 25 + 50 - 90, SCREEN_WIDTH-120, 40) target:self sel:@selector(login) tag:0 image:nil title:@"登陆"];
    loginBtn.layer.cornerRadius = 8;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.035 alpha:1.000];
    [self.view addSubview:loginBtn];
    
    btnProtocol = [MyControl creatButtonWithFrame:CGRectMake(60, SCREEN_HEIGHT - 250 + 25 + 50 - 50 + 10, 25, 25) target:self sel:@selector(isAgree) tag:1 image:@"ytc_icon_bj@2x_15" title:nil];
    [self.view addSubview:btnProtocol];
    NSString *strHint = @"中新网3月22日电 昨晚，德云社相声演员李久春在微博晒出一张合成照，还调侃称，“那些妇女们你们死心吧”。照片中，左侧是热播韩剧《太阳的后裔》男主角宋仲基，而与他四目相对的则是岳云鹏，画风十分奇怪";
    CGSize size = [strHint boundingRectWithSize:CGSizeMake(loginBtn.frame.size.width - 25, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    
    UILabel *labProtocol = [[UILabel alloc]initWithFrame:CGRectMake(90 , SCREEN_HEIGHT - 250 + 25 + 50 - 50 +10, loginBtn.frame.size.width - 25, size.height+2)];
    labProtocol.backgroundColor= [UIColor clearColor];
    labProtocol.font = [UIFont systemFontOfSize:12];
    labProtocol.numberOfLines = 0;
    labProtocol.text = strHint;
    [self.view addSubview:labProtocol];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProtocolo:)];
    labProtocol.userInteractionEnabled = YES;
    [labProtocol addGestureRecognizer:tapGesture];
    
    //验证码：
    _btnCode = [MyControl creatButtonWithFrame:CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 250 + 50 - 110, 80, 30) target:self sel:@selector(getCode) tag:2 image:nil title:@"获取验证码"];
     _btnCode.layer.cornerRadius = 4;
    _btnCode.layer.masksToBounds = YES;
    _btnCode.titleLabel.font = [UIFont systemFontOfSize:13];
    _btnCode.backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.035 alpha:1.000];
    _btnCode.alpha = 0.7;
    [self.view addSubview:_btnCode];
}
-(void)getCode{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                _btnCode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_btnCode setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                _btnCode.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    
}
-(void)showProtocolo:(UITapGestureRecognizer*)tap{

    AboutViewController *vc = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)isAgree{
    isAgree = !isAgree;
    if (isAgree) {
        [btnProtocol setBackgroundImage:[UIImage imageNamed:@"ytc_icon_bj@2x_15"] forState:UIControlStateNormal];
    }
    else
    {
        [btnProtocol setBackgroundImage:[UIImage imageNamed:@"kaung"] forState:UIControlStateNormal];
    }
}
-(void)login{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IS_LOGIN];

    [[UIApplication sharedApplication].keyWindow endEditing: YES];
    if (![ZHZTool isPhoneNumber:_userTF.text]) {
        
    }else if (_passTF.text.length==0)
    {
    }
    else
    {
        
        //http://b2c.ezparking.com.cn/rtpi-service/member/activate.do?key=4e165112b5b09b3defa583da68415fed
        NSString *url = [NSString stringWithFormat:@"http://b2c.ezparking.com.cn/rtpi-service/member/activate.do?key=4e165112b5b09b3defa583da68415fed&tel=%@&code=%@",@"15382306059",_passTF.text];
        [DownData getUrl:url params:nil success:^(id data) {
            NSLog(@"%@",data);
            NSDictionary *dic = (NSDictionary*)data;
            if (![dic[@"id"]isEqual:[NSNull null]]) {
                
                NSDictionary *dictRet = dic;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_userTF.text forKey:user_phone];
                [userDefaults setObject:[dictRet objectForKey:@"recommendCode"] forKey:user_code];
                [userDefaults setObject:[dictRet objectForKey:@"id"] forKey:user_id];
                NSString *strCar = [dictRet objectForKey:@"carNo"];
                if ([strCar isEqual:[NSNull null]]==NO&&strCar.length>0) {
                    [userDefaults setObject:strCar forKey:user_car];
                }
                
                NSMutableDictionary *dictUser = [[NSMutableDictionary alloc] initWithDictionary:dictRet];
                for (NSString *key in dictUser.allKeys) {
                    if ([[dictUser objectForKey:key] isEqual:[NSNull null]]) {
                        [dictUser removeObjectForKey:key];
                    }
                }
                [userDefaults setObject:dictUser forKey:user_info];
                [userDefaults setObject:@"1" forKey:IS_LOGIN];
                [userDefaults synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HEADERIMG object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError *error) {
            
            
        }];
     }
  }
-(void)setBtn{
    _userTF = [[UITextField alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT - 250 - 100, 180, 30)];
    _userTF.backgroundColor = [UIColor clearColor];
    _userTF.keyboardType = UIKeyboardTypeNumberPad;
    _userTF.delegate = self;
    _userTF.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    _userTF.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_userTF];
    UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ytc_icon_bj@2x_07"]];
    imgv.frame = CGRectMake(50, SCREEN_HEIGHT - 255 - 100, 30, 30);
    [self.view addSubview:imgv];
//    _userTF.leftView=imgv;
//    _userTF.leftViewMode = UITextFieldViewModeAlways;
//    [_userTF becomeFirstResponder];
     UIImageView *ivLine = [[UIImageView alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT - 250 - 100 + 25, SCREEN_WIDTH-60, 1)];
    ivLine.backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.035 alpha:1.000];
    [self.view addSubview:ivLine];
    UIImageView *hline = [[UIImageView alloc]initWithFrame:CGRectMake(89, SCREEN_HEIGHT - 255 - 100, 1, 30)];
    hline.backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.035 alpha:1.000];
    [self.view addSubview:hline];
    
    _passTF = [[UITextField alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT - 250 + 50 - 100, 120, 30)];
    _passTF.backgroundColor = [UIColor clearColor];
    _passTF.keyboardType = UIKeyboardTypeNumberPad;
    _passTF.delegate = self;
    _passTF.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    _passTF.font = [UIFont systemFontOfSize:20];

    [self.view addSubview:_passTF];
    UIImageView *imgv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ytc_icon_bj@2x_11"]];
    imgv1.frame = CGRectMake(50, SCREEN_HEIGHT - 255 - 100 + 50, 30, 30);
    [self.view addSubview:imgv1];
//    [_userTF becomeFirstResponder];
    UIImageView *ivLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT - 250 + 25 + 50 - 100 , SCREEN_WIDTH-60, 1)];
    ivLine1.backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.035 alpha:1.000];
    [self.view addSubview:ivLine1];
    UIImageView *hline1 = [[UIImageView alloc]initWithFrame:CGRectMake(89, SCREEN_HEIGHT - 255 + 50 - 100, 1, 30)];
    hline1.backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.035 alpha:1.000];
    [self.view addSubview:hline1];
  }

-(void)setNavBar{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ytc_bj"]];
    UIImageView *img = [MyControl creatImageViewWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 64, 100, 100*259/197) imageName:@"ytc_icon_bj@2x_03"];
    [self.view addSubview:img];
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fh_bj@2x_03"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regis)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)regis{
    [[UIApplication sharedApplication].keyWindow endEditing: YES];
    RegisViewController *vc = [[RegisViewController alloc]init];
    vc.title = @"注册";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)releaseInfo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[UIApplication sharedApplication].keyWindow endEditing: YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_userTF) {
        if (textField.text.length>=11&&string.length>0) {
            return NO;
        }
    }
    else if (textField ==_passTF)
    {
        if (textField.text.length>=4&&string.length>0) {
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
