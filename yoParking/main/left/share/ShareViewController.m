//
//  ShareViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/22.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ShareViewController.h"
#import "ZHZViewController.h"
#import <MessageUI/MessageUI.h>
#import "WXApi.h"
@interface ShareViewController ()<MFMessageComposeViewControllerDelegate,WXApiDelegate>

{
    UIView *bottomView;
    NSString *strSms;
}
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(regis)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fh_bj@2x_03"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    
    
    [self setButtomView];
    
    
    
    
    
    
    
}

-(void)setButtomView{
    UIImageView *ivRecommend = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2.0, 64+20, 120, 120)];
    ivRecommend.backgroundColor = [UIColor clearColor];
    ivRecommend.image = [UIImage imageNamed:@"recommend.png"];
    [self.view addSubview:ivRecommend];
    
    UILabel *labTip = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2.0, 64+20+120+5, 120, 22)];
    labTip.backgroundColor = [UIColor clearColor];
    labTip.textAlignment = NSTextAlignmentCenter;
    labTip.text = @"分享您的推荐码";
    labTip.textColor = [UIColor grayColor];
    [self.view addSubview:labTip];
    
    UILabel *labCode = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2.0, 64+20+120+5+22, 150, 35)];
    labCode.font = [UIFont systemFontOfSize:20];
    labCode.textColor = [UIColor colorWithRed:35/255.0 green:175/255.0 blue:205/255.0 alpha:1.0];
    labCode.textAlignment = NSTextAlignmentCenter;
    NSString *recommend = [[NSUserDefaults standardUserDefaults] objectForKey:user_code];
    labCode.text = recommend;
    [self.view addSubview:labCode];
    //    NSDictionary *dictInfo = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_INFO];
    UILabel *labNote = [[UILabel alloc]initWithFrame:CGRectMake(20, 64+20+120+5+22+35+10, SCREEN_WIDTH-40, 45)];
    labNote.backgroundColor = [UIColor clearColor];
    labNote.text = @"当您的好友使用您的优惠码时,你们都将获得";
    //[dicToken objectForKey:@"recommendHint"];//[NSString stringWithFormat:@"当您的好友使用您的优惠码时,你们都将获得¥%@。",[dictInfo objectForKey:@"recommendAmount"]];
    labNote.numberOfLines = 0;
    [self.view addSubview:labNote];
    
    UIButton *btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(20, 64+20+120+5+22+35+10+40+20, SCREEN_WIDTH-40, 50)];
    [btnLogin setBackgroundImage:[[UIImage imageNamed:@"btn_bg_n.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[[UIImage imageNamed:@"btn_bg_hl.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20] forState:UIControlStateHighlighted];
    [btnLogin setTitle:@"邀请好友" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 100)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    NSArray *imageArray = [NSArray arrayWithObjects:@"share_wechat.png",@"share_friend.png",@"share_msg.png", nil];
    NSArray *array = [NSArray arrayWithObjects:@"微信好友",@"朋友圈",@"短信", nil];
    
    for (int i = 0; i<3; i++)
    {
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0*i, 10, SCREEN_WIDTH/3.0, 80)];
        
        //        [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateHighlighted];
        [shareButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [shareButton setTitle:array[i] forState:UIControlStateNormal];
        
        shareButton.tag = 10+i;
        [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addSubview:shareButton];
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(shareButton.bounds), CGRectGetMidY(shareButton.bounds));
        CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(shareButton.imageView.bounds));
        CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(shareButton.bounds)-CGRectGetMidY(shareButton.titleLabel.bounds));
        
        CGPoint startImageViewCenter = shareButton.imageView.center;
        
        CGPoint startTitleLabelCenter = shareButton.titleLabel.center;
        
        CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
        CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop+5, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
        
        CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
        CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        shareButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom+5, titleEdgeInsetsRight);
    }
    [self.view addSubview:bottomView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissBottomView)];
    [self.view addGestureRecognizer:tapGesture];
}
- (void)inviteAction
{
    if (bottomView.frame.origin.y>=SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            [bottomView setFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
        } completion:nil];
    }
}

- (void)dismissBottomView
{
    if (bottomView.frame.origin.y<SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            [bottomView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 100)];
        } completion:nil];
    }
}

- (void)shareAction:(UIButton *)shareBtn
{
    switch (shareBtn.tag) {
        case 10:
        {
            if ([WXApi isWXAppSupportApi]) {
                [self showWXApp:0];
            }
        }
            break;
        case 11:
        {
            [self showWXApp:1];
        }
            break;
        case 12:
        {
            [self showMessageViewController];
        }
            break;
            
        default:
            break;
    }
}
-(void)showWXApp:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}


-(void)showMessageViewController{

    if( [MFMessageComposeViewController canSendText] )//判断是否能发短息
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.body = strSms;
        controller.messageComposeDelegate = self;//注意不是delegate
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"短信功能不可用!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//短信发送成功后的回调
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            //用户取消发送
        }
            break;
        case MessageComposeResultFailed://发送短信失败
        {
            UIAlertView *mfAlertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享失败,请重试!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [mfAlertview show];
        }
            break;
        case MessageComposeResultSent:
        {
            UIAlertView *mfAlertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"信息已发送，感谢您对我们的支持！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [mfAlertview show];
        }
            break;
        default:
            break;
    }
}
-(void)releaseInfo{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)regis{
    
    ZHZViewController *one = [[ZHZViewController alloc]init];
    self.title = @"测试";
    [self.navigationController pushViewController:one animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.title = @"分享";
    self.navigationController.navigationBarHidden = NO;
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
