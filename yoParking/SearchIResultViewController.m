//
//  SearchIResultViewController.m
//  testIndoorLibDemo
//
//  Created by auto on 15/11/6.
//  Copyright © 2015年 autonavi. All rights reserved.
//

#import "SearchIResultViewController.h"
#import "IndoorSearchEngine.h"
#import "ViewController.h"

@interface SearchIResultViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) UITableView  *table;
@property(nonatomic,strong) UITextField  *txtURL;
@end

@implementation SearchIResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    self.table = [[UITableView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
    self.table.dataSource = self;
    self.table.delegate = self;
    
    self.table.showsVerticalScrollIndicator = YES;
    self.table.backgroundView = nil;
    self.table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //    table.scrollEnabled = YES;
    
    self.table.layer.borderWidth = 0.5;

    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsZero];
    }

    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.table];
    [self.table reloadData];
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

#pragma mark uitextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *searchTxt = textField.text;
    if ([searchTxt length] >0) {
        NSArray *ary =[self.inSEngine searchByKey:searchTxt floorID:0 fx:-1 fy:-1 nlimit:500];
        if ([ary count]>0) {
            self.resultAry = ary;
            [self.table reloadData];
        }
    }
    
    return YES;
}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"_table_";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    IndoorEn *en = self.resultAry[indexPath.row];
    cell.textLabel.text = en.name_dp;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d层",en.floorIndex];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IndoorEn *en = self.resultAry[indexPath.row];
    ViewController *vc = (ViewController *)([self.navigationController viewControllers][2]);
    if ([vc isKindOfClass:[ViewController class]]) {
        [vc loadSearchPoi:en];
    }
    [self.navigationController popToViewController:vc  animated:YES];
}

@end
