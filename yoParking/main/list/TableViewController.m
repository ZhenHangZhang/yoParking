//
//  TableViewController.m
//  yoParking
//
//  Created by zhanghangzhen on 16/3/25.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "TableViewController.h"
#import "ZHZViewController.h"
#import "AppDelegate.h"
@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [UITableView new];
    tableView.frame = self.view.frame;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

-(void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.textLabel.text = self.dataArr[indexPath.row][@"name"];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     ZHZViewController *vc = [[ZHZViewController alloc]init];
     [self.navigationController pushViewController:vc animated:YES];
//     [self dismissViewControllerAnimated:YES completion:nil];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
