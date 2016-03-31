//
//  RegisViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/21.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "RegisViewController.h"
#import "Keyboard.h"
#import "ZHZTool.h"
@interface RegisViewController ()<UITextFieldDelegate,keyboard>

{
    UITextField *textPhone;
    UITextField *textCarNo;
    UITextField *textCode;
    UITextField *textInviter;
    
    UIButton    *btnCode;
    NSTimer     *timer;
    NSInteger   downTime;
    
}
@property(nonatomic,strong)Keyboard*board;

@end

@implementation RegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftView)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
//    self.navigationItem.rightBarButtonItem = nil;
    
    self.board = [Keyboard show];
    self.board.delegate = self;
    [self addSubviews];
}
- (void)addSubviews
{
    UILabel *labPhone = [[UILabel alloc]initWithFrame:CGRectMake(20, 64+25, 60, 25)];
    labPhone.backgroundColor = [UIColor clearColor];
    labPhone.font = [UIFont systemFontOfSize:14];
    labPhone.text = @"手机号码";
    [self.view addSubview:labPhone];
    
    textPhone = [[UITextField alloc]initWithFrame:CGRectMake(120, 64+25, SCREEN_WIDTH-120-20, 25)];
    textPhone.backgroundColor = [UIColor clearColor];
    textPhone.keyboardType = UIKeyboardTypeNumberPad;
    textPhone.delegate = self;
    
    [self.view addSubview:textPhone];
    // 输入键盘自定义
    textPhone.inputView = self.board;
    [textPhone becomeFirstResponder];
    
    UIImageView *ivLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 64+25+25, SCREEN_WIDTH-40, 1)];
    ivLine.backgroundColor = [UIColor colorWithRed:35/255.0 green:175/255.0 blue:205/255.0 alpha:1.0];
    [self.view addSubview:ivLine];
    
    UILabel *labCarNo = [[UILabel alloc]initWithFrame:CGRectMake(20, 64+25+25+20, 80, 25)];
    labCarNo.backgroundColor = [UIColor clearColor];
    labCarNo.font = [UIFont systemFontOfSize:14];
    labCarNo.text = @"车牌号";
    [self.view addSubview:labCarNo];
    
    textCarNo = [[UITextField alloc]initWithFrame:CGRectMake(120, 64+25+25+20, SCREEN_WIDTH-120-20, 25)];
    textCarNo.backgroundColor = [UIColor clearColor];
    textCarNo.delegate = self;
    textCarNo.inputView = self.board;
    [self.view addSubview:textCarNo];
    
    UIImageView *carLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 64+25+25+20+25, SCREEN_WIDTH-40, 1)];
    carLine.backgroundColor = [UIColor colorWithRed:35/255.0 green:175/255.0 blue:205/255.0 alpha:1.0];
    [self.view addSubview:carLine];
    
    //推荐码
    UILabel *labInvite = [[UILabel alloc]initWithFrame:CGRectMake(20, 64+25+25+20+25+20, 80, 25)];
    labInvite.backgroundColor = [UIColor clearColor];
    labInvite.font = [UIFont systemFontOfSize:14];
    labInvite.text = @"推荐码";
    [self.view addSubview:labInvite];
    
    textInviter = [[UITextField alloc]initWithFrame:CGRectMake(120, 64+25+25+20+25+20, SCREEN_WIDTH-120-20, 25)];
    textInviter.backgroundColor = [UIColor clearColor];
    textInviter.placeholder = @"选填";
    textInviter.delegate = self;
    textInviter.inputView = self.board;
    [self.view addSubview:textInviter];
    
    UIImageView *codeLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 64+25+25+20+25+20+25, SCREEN_WIDTH-40, 1)];
    codeLine.backgroundColor = [UIColor colorWithRed:35/255.0 green:175/255.0 blue:205/255.0 alpha:1.0];
    [self.view addSubview:codeLine];
    
    //验证码
    UILabel *labCode = [[UILabel alloc]initWithFrame:CGRectMake(20, 64+25+25+20+25+20+25+20, 80, 25)];
    labCode.backgroundColor = [UIColor clearColor];
    labCode.font = [UIFont systemFontOfSize:14];
    labCode.text = @"验证码";
    [self.view addSubview:labCode];
    
    textCode = [[UITextField alloc]initWithFrame:CGRectMake(120, 64+25+25+20+25+20+25+20, SCREEN_WIDTH-120-20-90, 25)];
    textCode.backgroundColor = [UIColor clearColor];
    textCode.delegate = self;
    textCode.inputView = self.board;
    [self.view addSubview:textCode];
    
    btnCode = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 64+25+25+20+25+20+25+13, 90, 30)];
    [btnCode setBackgroundImage:[[UIImage imageNamed:@"gray_btn_n.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [btnCode setBackgroundImage:[[UIImage imageNamed:@"gray_btn_hl.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCode addTarget:self action:@selector(registerCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCode];
    
    UIImageView *inviteLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 64+25+25+20+25+20+25+20+25, SCREEN_WIDTH-40, 1)];
    inviteLine.backgroundColor = [UIColor colorWithRed:35/255.0 green:175/255.0 blue:205/255.0 alpha:1.0];
    [self.view addSubview:inviteLine];
    
    
    
    UIButton *btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(20, 64+25+25+20+25+20+25+20+25+30, SCREEN_WIDTH-40, 44)];
    [btnLogin setBackgroundImage:[[UIImage imageNamed:@"btn_bg_n.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[[UIImage imageNamed:@"btn_bg_hl.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20] forState:UIControlStateHighlighted];
    [btnLogin setTitle:@"提交" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
}
#pragma mark - 注册

- (void)registerAction
{
    [self.view endEditing:YES];
    if ([ZHZTool isPhoneNumber:textPhone.text]==NO)
    {
    }
    else if ([ZHZTool isCarNumber:textCarNo.text]==NO)
    {
    }
    else if (textCode.text.length<1)
    {
    }
    else
    {
        [self doRegister];
    }
}
-(void)doRegister{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"http://b2c.ezparking.com.cn/rtpi-service/member/register.do?key=71c798e5cbc60dcf68bc446db4abda47&tel=%@&code=%@&carNo=%@",textPhone.text,textCode.text,textCarNo.text];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        __weak typeof(self)weakSelf = self;

    [DownData getUrl:urlStr params:nil success:^(id data) {
        NSDictionary *dictInfo = (NSDictionary *)data;
        [userDefaults setObject:[dictInfo objectForKey:@"tel"] forKey:user_phone];
        [userDefaults setObject:[dictInfo objectForKey:@"recommendCode"] forKey:user_code];
        [userDefaults setObject:[dictInfo objectForKey:@"id"] forKey:user_id];
        NSString *strCar = [dictInfo objectForKey:@"carNo"];
        if ([strCar isEqual:[NSNull null]]==NO&&strCar.length>0) {
            [userDefaults setObject:strCar forKey:user_car];
        }
        NSMutableDictionary *dictUser = [[NSMutableDictionary alloc] initWithDictionary:dictInfo];
        for (NSString *key in dictUser.allKeys) {
            if ([[dictUser objectForKey:key] isEqual:[NSNull null]]) {
                [dictUser removeObjectForKey:key];
            }
        }
        [userDefaults setObject:dictUser forKey:user_info];
        [userDefaults synchronize];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - 验证码
- (void)registerCodeAction
{
    [self.view endEditing:YES];
    if ([ZHZTool isPhoneNumber:textPhone.text]==NO)
    {
        
    }
    else if ([ZHZTool isCarNumber:textCarNo.text]==NO)
    {
        
    }else
    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        btnCode.userInteractionEnabled = NO;
//        [self showHudInView:self.view hint:nil];
        NSString *urlStr = @"http://b2c.ezparking.com.cn/rtpi-service/member/registerNotify.do?key=71c798e5cbc60dcf68bc446db4abda47&tel=13323819717";
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [DownData getUrl:urlStr params:nil success:^(id data) {
            
        } fail:^(NSError *error) {
        }];
        downTime = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(registerChangeTime) userInfo:nil repeats:YES];
    }
}
- (void)registerChangeTime
{
    downTime -=1;
    if (downTime<=0) {
        [timer invalidate];
        timer = nil;
        [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        btnCode.userInteractionEnabled = YES;
    }
    else
    {
        [btnCode setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)downTime] forState:UIControlStateNormal];
    }
}
-(void)leftView{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -textField-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == textCarNo) {
        if (textCarNo.text.length > 0) {
            [self.board ScrollViewMoveRight];
        }
        else{
            [self.board ScrollViewMoveLeft];
        }
    }
    else
    {
        [self.board ScrollViewMoveRight];
    }
    return YES;
}
#pragma mark -keyboard-

// 输入汉字
- (void)address:(NSString *)str
{
    [self.board ScrollViewMoveRight];
    [self changetextBelonging:str];
}
- (void)changetextBelonging:(NSString *)text
{
    NSString *iphoneText = textCarNo.text;
    textCarNo.text = [NSString stringWithFormat:@"%@%@", iphoneText, text];
}
// 输入字母或者数字

- (void)inputChars:(NSString *)str
{
    if ([textPhone isFirstResponder]) {
        NSString *iphoneText = textPhone.text;
        if (iphoneText.length > 10) {
            return;
        }
        textPhone.text = [NSString stringWithFormat:@"%@%@", iphoneText, str];
    }
    if ([textCarNo isFirstResponder]) {
        NSString *carNumber = textCarNo.text;
        if (carNumber.length > 6) {
            return;
        }
        if (carNumber.length == 1) {
            if ([ZHZTool isEnglishNum:str]) {
                textCarNo.text = [NSString stringWithFormat:@"%@%@", carNumber, str];
            }
            else
            {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:@"您的输入不符合车牌规则, 请点击确定重新输入" preferredStyle:(UIAlertControllerStyleActionSheet)];
                [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alter animated:true completion:nil];
                
            }
        }else{
            textCarNo.text = [NSString stringWithFormat:@"%@%@", carNumber, str];}
    }
    if ([textInviter isFirstResponder]) {
        NSString *carNumber = textInviter.text;
        textInviter.text = [NSString stringWithFormat:@"%@%@", carNumber, str];
    }
    if ([textCode isFirstResponder]) {
        NSString *carNumber = textCode.text;
        if (carNumber.length > 3) {
            return;
        }
        textCode.text = [NSString stringWithFormat:@"%@%@", carNumber, str];
    }
}

#pragma mark - 重新输入
- (void)inputAgain
{
    if ([textPhone isFirstResponder]) {
        textPhone.text = @"";
    }
    if ([textCarNo isFirstResponder]) {
        textCarNo.text = @"";
        [self.board ScrollViewMoveLeft];
    }
    if ([textInviter isFirstResponder]) {
        textInviter.text = @"";
    }
    if ([textCode isFirstResponder]) {
        textCode.text = @"";
    }
}
#pragma mark - 删除
- (void)delegateStr
{
    if ([textPhone isFirstResponder]) {
        NSString *deleteBefore = textPhone.text;
        if (deleteBefore.length > 0) {
            NSString *deleteAfter = [deleteBefore substringToIndex:deleteBefore.length - 1];
            textPhone.text = deleteAfter;
        }
    }
    if ([textCarNo isFirstResponder]) {
        NSString *deleteBefore = textCarNo.text;
        if (deleteBefore.length > 0) {
            NSString *deleteAfter = [deleteBefore substringToIndex:deleteBefore.length - 1];
            textCarNo.text = deleteAfter;
            if (textCarNo.text.length == 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.board ScrollViewMoveLeft];
                }];
            }
        }
    }
    if ([textCode isFirstResponder]) {
        NSString *deleteBefore = textCode.text;
        if (deleteBefore.length > 0) {
            NSString *deleteAfter = [deleteBefore substringToIndex:deleteBefore.length - 1];
            textCode.text = deleteAfter;
        }
    }
    if ([textInviter isFirstResponder]) {
        NSString *deleteBefore = textInviter.text;
        if (deleteBefore.length > 0) {
            NSString *deleteAfter = [deleteBefore substringToIndex:deleteBefore.length - 1];
            textInviter.text = deleteAfter;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
