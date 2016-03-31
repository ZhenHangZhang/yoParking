//
//  AboutViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/22.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "AboutViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface AboutViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
}
@property(nonatomic,copy)NSString*strTitle;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    //    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
     _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = self;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0.0;
    [self.navigationController.navigationBar addSubview:_progressView];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://yo.ezparking.com.cn/about.html"]];
    [_webView loadRequest:request];
}
 #pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if (self.strTitle==nil) {
        self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        NSLog(@"%@",self.title);
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
