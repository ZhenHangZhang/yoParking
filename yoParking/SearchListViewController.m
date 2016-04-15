//
//  SearchListViewController.m
//  testIndoorLibDemo
//
//  Created by auto on 15/10/19.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import "SearchListViewController.h"
#import "GridView.h"
#import "IndoorSearchEngine.h"
#import "SearchIResultViewController.h"
#import "IndoorRouteRequest.h"
#import "ViewController.h"

@interface SearchListViewController ()<UITextFieldDelegate,GridProtocol>
@property(nonatomic,strong) UITextField  *txtURL;
@property(nonatomic,strong) NSDictionary *shopDict;
@property(nonatomic,strong) NSDictionary *serviceDict;

@property(nonatomic,strong) NSArray *shopAry;
@property(nonatomic,strong) NSArray *serviceAry;

@property(nonatomic,strong) UIView *shopTitleView;
@property(nonatomic,strong) UIView *shopView;
@property(nonatomic,strong) UIView *serviceTitleView;
@property(nonatomic,strong) UIView *serviceView;
@property(nonatomic,strong) UILabel *shopLabel;
@property(nonatomic,strong) UILabel *serLabel;


@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) NSDictionary *typesDict;
@property(nonatomic,strong) NSDictionary *searchSDict;
@property(nonatomic,strong) NSDictionary *serviceSEDict;

@property(nonatomic,strong)IndoorSearchEngine *inSEngine;
@end

@implementation SearchListViewController

- (void)dealloc
{
    [_inSEngine FreeSearchEngine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];;
    //
    if (self.navigationController)
    {
        //创建一个UITextField
        UITextField *txtURL=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 40, 30)];
        //将txt改为圆角
        txtURL.borderStyle=UITextBorderStyleRoundedRect;
        //设置字体大小
        txtURL.font=[UIFont systemFontOfSize:14];
        //设置提示
        txtURL.placeholder=@"请输入关键字";
        //设置键盘的return类型为GO
        txtURL.returnKeyType=UIReturnKeyGo;
        //设置代理
        txtURL.delegate=self;
        self.txtURL=txtURL;
        
        
        //创建UIBarButtonItem，添加self.txtURL
        UIBarButtonItem *txtURLBtn=[[UIBarButtonItem alloc]initWithCustomView:self.txtURL];
        //设置导航条的左侧按钮
        self.navigationItem.rightBarButtonItem=txtURLBtn;
    }
    
    
    //self.navigationItem.titleView
    
    self.shopDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"名品服饰",@"AM0001",
                                        @"珠宝首饰",@"AM0002",
                                        @"时尚家居",@"AM0003",
                                        @"母婴亲子",@"AM0004",
                                        @"运动品牌",@"AM0007",
                                        @"数码家电",@"AM0008",
                                        @"美食",@"AM0010",
                                        @"电影院",@"AM0011",
                                        @"图书音像",@"AM0012",
                                        @"化妆品",@"AM0013",
                                        @"免税店",@"AM0014",
                                        nil];
    
    self.shopAry = @[@"AM0001",@"AM0002",@"AM0003",@"AM0004",@"AM0007",@"AM0008",@"AM0010",@"AM0011",@"AM0012",@"AM0013",@"AM0014"];
    
    self.serviceDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                     @"问讯处",@"AM1002",
                     @"卫生间",@"AM1004",
                     @"ATM",@"AM1005",
                     @"收银台",@"AM1009",
                     @"直梯",@"AM1010",
                     @"扶梯",@"AM1011",
                     @"出入口",@"AM1012",
                     @"楼梯",@"AM1013",
                     nil];

    self.serviceAry = @[@"AM1002",@"AM1004",@"AM1005",@"AM1009",@"AM1010",@"AM1011",@"AM1012",@"AM1013"];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.shopTitleView];
    [self.shopTitleView addSubview:self.shopLabel];
    [self.scrollView addSubview:self.shopView];
    [self.scrollView addSubview:self.serviceTitleView];
    [self.serviceTitleView addSubview:self.serLabel];
    [self.scrollView addSubview:self.serviceView];
    
    self.inSEngine =  [[IndoorSearchEngine alloc]init];
    [self.inSEngine InitSearchEngine:self.indoorPath];
    self.typeAry = [self.inSEngine getTypeList];
    
    [self initId];
    [self convertDict];
    [self loadViewInfo];
   
}

- (void)loadViewInfo
{
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"class" ofType:@"bundle"];
    NSUInteger rowNum =  ([self.shopDict count]%4 == 0) ? [self.shopDict count]/4 : ([self.shopDict count]/4 + 1);
    NSInteger  width = self.view.frame.size.width/4 ;
    NSInteger  count = 0;
    for (NSInteger i  = 0; i < rowNum; i++){
        for (NSInteger r  = 0; r < 4; r++){
            if ([self.shopAry count]-1 < count) {
                break;
            }
            GridView * view  = [[GridView alloc] initWithFrame:CGRectMake(width* r, width*i+5, width, width) row:i colum:r];
            NSString *name=self.shopAry[count];
            NSString *imgName = [NSString stringWithFormat:@"%@/indoor_%@",bundlePath,[name lowercaseString]];
            view.text = self.shopDict[name];
            view.image = [UIImage imageWithContentsOfFile:imgName];
            view.delegate = self;
            view.type = @"0";
            [self.shopView addSubview:view];
            count++;
        }
    }
    
    rowNum = ([self.serviceDict count]%4 == 0) ? [self.serviceDict count]/4 : ([self.serviceDict count]/4 + 1);
    count = 0;
    for (NSInteger i  = 0; i < rowNum; i++){
        for (NSInteger r  = 0; r < 4; r++){
            if ([self.serviceAry count]-1 < count) {
                break;
            }
            GridView * view  = [[GridView alloc] initWithFrame:CGRectMake(width* r, width*i+15, width, width) row:i colum:r];
            NSString *name=self.serviceAry[count];
            NSString *imgName = [NSString stringWithFormat:@"%@/indoor_%@",bundlePath,[name lowercaseString]];
            view.text = self.serviceDict[name];
            view.image = [UIImage imageWithContentsOfFile:imgName];
            view.type = @"1";
            view.delegate = self;
            [self.serviceView addSubview:view];
            count++;
        }
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    int height = self.shopTitleView.frame.size.height + self.shopView.frame.size.height+self.serviceTitleView.frame.size.height+self.serviceView.frame.size.height+2*10;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width,height)];
}


- (void)initId
{
    NSArray *lines; /*将文件转化为一行一行的*/
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"indoor" ofType:@"bundle"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"searchtype.txt"];
    
    NSError* err=nil;
    NSString* mTxt=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    lines =[mTxt componentsSeparatedByString:@"\r\n"];
    
    if ([lines count]<=0) {
        return ;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (NSString *line in lines) {
        NSArray *ids = [line componentsSeparatedByString:@","];
        if ([ids count] == 0) {
            continue;
        }
        // NSLog(@"%@",line);
        if ([[ids objectAtIndex:2] isEqualToString:@" "]) {
            continue;
        }
        [dict setObject:ids[3] forKey:[NSNumber numberWithInteger:[ids[1]intValue]]];
       // NSLog(@"%@",dict);
    }
    self.typesDict = dict;
    
}

- (void)convertDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (NSNumber *ids in self.typeAry) {
        NSString *key =  self.typesDict[ids];
        if (![key isKindOfClass:[NSString class]]) {
            continue;
        }

        NSMutableArray *ary  =[dict objectForKey:key];
        if (![ary isKindOfClass:[NSMutableArray class]]) {
            ary  = [[NSMutableArray alloc]initWithCapacity:0];
        }
        //NSLog(@"---%@",ary);
        
        [ary addObject:ids];
        [dict setObject:ary forKey:key];
    }
    self.searchSDict =dict;
    //NSLog(@"%@",self.self.searchSDict);
}


#pragma mark grid 
- (void)gridClick:(NSUInteger)row
            colum:(NSUInteger)colum
             type:(NSString *)type
{
    NSLog(@"%lu- %lu -%@",(unsigned long)row,(unsigned long)colum,type);
    NSArray *ary;
    NSString *key;
    if ([type isEqualToString:@"0"]) {
        key=self.shopAry[row*4+colum];
        ary = self.searchSDict[key];
        if ([ary count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"搜索数据" message:@"没有数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        NSMutableArray *mA = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSString *typeid in ary) {
            NSArray *ary = [self.inSEngine searchByType:[typeid intValue]  floorID:0 fx:-1 fy:-1 nlimit:500];
            for (IndoorEn *ie in ary) {
                [mA addObject:ie];
            }
        }
        SearchIResultViewController *siv = [[SearchIResultViewController alloc]init];
        siv.resultAry = mA;
        siv.inSEngine = self.inSEngine;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationItem.backBarButtonItem = barButtonItem;
        [self.navigationController pushViewController:siv animated:YES];
        
    }else if([type isEqualToString:@"1"]){
        key=self.serviceAry[row*4+colum];
        ary = self.searchSDict[key];
        if ([ary count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"搜索数据" message:@"没有数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }

        NSMutableArray *mA = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSString *typeid in ary) {
            NSArray *ary = [self.inSEngine searchByType:[typeid intValue]  floorID:0 fx:-1 fy:-1 nlimit:500];
            for (IndoorEn *ie in ary) {
                [mA addObject:ie];
            }
        }

        ViewController *vc = (ViewController *)([self.navigationController viewControllers][0]);
        if ([vc isKindOfClass:[ViewController class]]) {
            [vc loadSearchAllPoi:mA];
        }
        [self.navigationController popToViewController:vc  animated:YES];
        return ;
        
    }
    
}

#pragma mark uitextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *searchTxt = textField.text;
    if ([searchTxt length] >0) {
        NSArray *ary =[self.inSEngine searchByKey:searchTxt floorID:0 fx:-1 fy:-1 nlimit:500];
        SearchIResultViewController *siv = [[SearchIResultViewController alloc]init];
        siv.resultAry = ary;
        siv.inSEngine = self.inSEngine;
        [self.navigationController pushViewController:siv animated:YES];
    }
    
    return YES;
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

#pragma mark setter or getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scrollView.backgroundColor = [UIColor colorWithRed:(CGFloat)232.0/255.0 green:(CGFloat)232.0/255.0 blue:(CGFloat)232.0/255.0 alpha:1.0f];
        _scrollView.showsVerticalScrollIndicator = NO;
        
    }
    return _scrollView;
}


- (UIView *)shopTitleView
{
    if (!_shopTitleView) {
        _shopTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _shopTitleView.backgroundColor = [UIColor clearColor];
        
    }
    return _shopTitleView;
}

- (UILabel *)shopLabel
{
    if (!_shopLabel) {
        _shopLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 25)];
        _shopLabel.text = @"精品商家";
        _shopLabel.font = [UIFont systemFontOfSize:16];
    }
    return _shopLabel;
}

- (UILabel *)serLabel
{
    if (!_serLabel) {
        _serLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 25)];
        _serLabel.text = @"服务设施";
        _serLabel.font = [UIFont systemFontOfSize:16];
    }
    return _serLabel;
}

- (UIView *)shopView
{
    if (!_shopView) {
        _shopView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 300)];
        _shopView.backgroundColor = [UIColor whiteColor];
        
    }
    return _shopView;
}

- (UIView *)serviceTitleView
{
    if (!_serviceTitleView) {
        _serviceTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 40)];
        _serviceTitleView.backgroundColor = [UIColor clearColor];
        
    }
    return _serviceTitleView;
}

- (UIView *)serviceView
{
    if (!_serviceView) {
        _serviceView = [[UIView alloc]initWithFrame:CGRectMake(0, 395, self.view.frame.size.width, 220)];
        _serviceView.backgroundColor = [UIColor whiteColor];
        
    }
    return _serviceView;
}

@end
