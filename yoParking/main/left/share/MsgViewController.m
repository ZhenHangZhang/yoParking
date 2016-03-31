//
//  MsgViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/22.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgTableViewCell.h"
@interface MsgViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tabv;
}
@property(nonatomic,copy)NSMutableArray *dataArr;
@end

@implementation MsgViewController
-(NSMutableArray *)dataArr{

    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    [self setTabbleView];
    [self getdata];
}

-(void)getdata{

    [GCD downloadWithUrlStr:@"http://b2c.ezparking.com.cn/rtpi-service/memberMessage/list.do?key=bab47cb29d891ff2291257c67ca83f9&memberId=qFhDdwZi" andCallBack:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"%ld",(long)error.code);
            return ;
        }
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",arr);
        [self.dataArr addObjectsFromArray:arr];
         [_tabv reloadData];
     }];
 }
-(void)setTabbleView{

    _tabv = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tabv.delegate = self;
    _tabv.dataSource = self;
    [self.view addSubview:_tabv];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellId = @"cellId";
     MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MsgTableViewCell" owner:self options:nil] objectAtIndex:0];
      }
    [cell setViewsWithDic:self.dataArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

     return cell;

 }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
@end
