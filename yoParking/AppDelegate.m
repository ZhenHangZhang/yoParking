//
//  AppDelegate.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/17.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHZTabBarVC.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "WXApi.h"

#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"

 @interface AppDelegate ()<WXApiDelegate>
{
}
@end

@implementation AppDelegate

 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//微信注册
    [WXApi registerApp:WXKEY];
    [self setLeftVC];
    [self downloadData];
    
    [self configIFlySpeech];
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)configIFlySpeech
{
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"56f4c9f0",@"20000"]];
    
//    [IFlySetting setLogFile:LVL_NONE];
//    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"30" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"vinn" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
     // 当你再不需要保存音频时，请在必要的地方加上这行。
//    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}

-(void)downloadData{

    [GCD downloadWithUrlStr:@"http://b2c.ezparking.com.cn/rtpi-service/misc/token.do?deviceId=e1532a2de314c68516479d3487e4e8107fe6534c&app=com.ezparking.ios.qibutingche&version=37" andCallBack:^(NSData *d, NSError *e) {
        
        if (!e) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",[dic objectForKey:@"ipaUrl"]);

            NSString *strKey = [dic objectForKey:@"key"];
            NSInteger radius = [[dic objectForKey:@"parkingRadius"] integerValue];
            NSInteger size = [[dic objectForKey:@"parkingSize"] integerValue];
            
            [[NSUserDefaults standardUserDefaults] setObject:strKey forKey:REQ_KEY1];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)radius] forKey:MAP_RADIUS];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)size] forKey:MAP_SIZE];
            
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:TOKEN_INFO];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}
-(void)setLeftVC{
    ZHZTabBarVC *mainViewController=[[ZHZTabBarVC alloc]init];
    mainViewController.view.backgroundColor=[UIColor grayColor];
    UINavigationController *maNA = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    self.mainNavigationController = maNA;
    LeftViewController *leftViewController=[[LeftViewController alloc]init];
    leftViewController.view.backgroundColor=[UIColor whiteColor];
    self.LeftSlideVC = [[LeftSlideViewController alloc]initWithLeftView:leftViewController andMainView:maNA];
    self.window.rootViewController=self.LeftSlideVC;
}
-(void)setYR{
    ZHZTabBarVC *mainViewController=[[ZHZTabBarVC alloc]init];
    mainViewController.view.backgroundColor=[UIColor grayColor];
    
    LeftViewController *leftViewController=[[LeftViewController alloc]init];
    leftViewController.view.backgroundColor=[UIColor brownColor];
    UINavigationController *leftNav = [[UINavigationController alloc]initWithRootViewController:leftViewController];
    
    RightViewController *rightViewController=[[RightViewController alloc]init];
    UINavigationController *rightNav = [[UINavigationController alloc]initWithRootViewController:rightViewController];
    rightViewController.view.backgroundColor=[UIColor purpleColor];
    
    
    
    _YRvc=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
    _YRvc.rootViewController=mainViewController;
    _YRvc.leftViewController=leftNav;
    _YRvc.rightViewController=rightNav;
    
    
    _YRvc.leftViewShowWidth=250;
    _YRvc.rightViewShowWidth = 250;
    _YRvc.needSwipeShowMenu=true;//默认开启的可滑动展示
    //动画效果可以被自己自定义，具体请看api
    //    UINavigationController *rootVC = [[UINavigationController alloc]initWithRootViewController:_YRvc];
    
    self.window.rootViewController=_YRvc;

    
}



-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    return [WXApi handleOpenURL:url delegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void) onReq:(BaseReq*)reqonReq{

    
}
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void)onResp:(BaseResp *)resp{

    
}
@end
