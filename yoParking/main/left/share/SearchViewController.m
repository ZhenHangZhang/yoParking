//
//  SearchViewController.m
//  Park
//
//  Created by  apple on 15/8/3.
//  Copyright (c) 2015年  apple. All rights reserved.
//

#import "SearchViewController.h"
#import "SingleShow.h"
@interface SearchViewController ()<AMapSearchDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
{
    BOOL    flagSearched;
    UICollectionView* _collectionV;
    NSIndexPath *indexPath1;
}

@property (nonatomic, strong) AMapSearchAPI *searchArr;
@property (nonatomic, strong) UISearchBar   *searchBar;
@property (nonatomic, strong) UITableView   *tbSearchResults;
@property (nonatomic, copy) NSMutableArray  *arrResults;
@property (nonatomic ,copy) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *locationDataArr;
@property (nonatomic, strong) UIButton *keyBoardMiss;
@property(nonatomic,copy)NSMutableArray*searchRecords;
@property(nonatomic,copy)NSString *selectedPlace;

@end

@implementation SearchViewController
+(instancetype)show{

    static SearchViewController *vc = nil;
    if (vc == nil) {
        vc = [[SearchViewController alloc]init];
    }return vc;

}
-(NSMutableArray *)searchRecords{
    if (_searchRecords == nil) {
        _searchRecords = [[NSMutableArray alloc]init];
        indexPath1= [[NSIndexPath alloc]init];
    }
    return _searchRecords;
}
-(NSMutableArray *)cityArr{
    if (_cityArr == nil) {
        _cityArr = [[NSMutableArray alloc]init];
        [self getDataOfHotsoso];
    }
    return  _cityArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.searchRecords addObjectsFromArray:[self readData:@"searchRecords"]];
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBackAction)];
    self.navigationItem.leftBarButtonItem = barBtn;
    _arrResults = [[NSMutableArray alloc]initWithCapacity:10];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    _tbSearchResults = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    _tbSearchResults.dataSource = self;
    _tbSearchResults.delegate = self;
    _tbSearchResults.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tbSearchResults];

    [AMapSearchServices sharedServices].apiKey = AMKEY;
    //初始化检索对象
    _searchArr = [[AMapSearchAPI alloc] init];
    _searchArr.delegate = self;
 
    [self createCollectWithHot];
}
#pragma mark - UISearchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"%f",[UIApplication sharedApplication].keyWindow.frame.size.height);
    flagSearched = NO;
    return YES;
}
//输入提示的搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    AMapInputTipsSearchRequest *tipsSearch = [[AMapInputTipsSearchRequest alloc] init];
    _collectionV.hidden = YES;
    if (searchBar.text.length < 1) {
        _collectionV.hidden = NO;
    }
    tipsSearch.keywords = searchText;
    tipsSearch.city = self.parkCity;
    [_searchArr AMapInputTipsSearch:tipsSearch];
}
//点击搜索按钮之后的搜索地址编码
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (searchBar.text.length == 0)
    {
        return;
    }
    flagSearched = YES;
    [self searchAMapWithKey:searchBar.text];
}
//地理编码！
- (void)searchAMapWithKey:(NSString *)strKey
{
    NSLog(@"strKey===>%@",strKey);
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = strKey;
     [_searchArr AMapGeocodeSearch:geo];
}
 - (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        flagSearched = NO;
        return;
    }
    if (flagSearched) {
        [self.arrResults removeAllObjects];
        [self.arrResults setArray:response.geocodes];
        [self.tbSearchResults reloadData];
    }
    else
    {
        AMapGeocode *geocode = [response.geocodes objectAtIndex:0];
        CLLocationCoordinate2D searchCoordinate = CLLocationCoordinate2DMake(geocode.location.latitude, geocode.location.longitude);
        if ([self.searchDelegate respondsToSelector:@selector(searchWithPoint:address:tag:)]) {
            [self.searchDelegate searchWithPoint:searchCoordinate address:geocode.formattedAddress tag:1];
            NSLog(@"geocode.formattedAddress %f   %f ===>%@",searchCoordinate.latitude,searchCoordinate.longitude, geocode.formattedAddress);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
 }
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
     if (flagSearched ==YES&&[request isKindOfClass:[AMapGeocodeSearchRequest class]]) {
        flagSearched = NO;
    }
}
/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.arrResults setArray:response.tips];
    [self.tbSearchResults reloadData];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
    static NSString *searchCell = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCell];
    }
    if (flagSearched)
    {
        AMapGeocode *geocode = self.arrResults[indexPath.row];
        cell.textLabel.text = self.searchBar.text;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",geocode.city,geocode.district];
    }
    else
    {
        AMapTip *tip = self.arrResults[indexPath.row];
        cell.textLabel.text = tip.name;
        cell.detailTextLabel.text = tip.district;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    flagSearched = NO;
    if (flagSearched)
    {
        AMapGeocode *geocode = self.arrResults[indexPath.row];
        NSLog(@"%@",self.arrResults[indexPath.row]);
        CLLocationCoordinate2D searchCoordinate = CLLocationCoordinate2DMake(geocode.location.latitude, geocode.location.longitude);
        NSString *recordStr = geocode.formattedAddress;
        NSNumber *laStr = [NSNumber numberWithDouble:geocode.location.latitude];
        NSNumber *loStr = [NSNumber numberWithDouble:geocode.location.longitude];
        NSDictionary *dictPlace = [[NSDictionary alloc]initWithObjectsAndKeys:recordStr,@"place",laStr,@"latitude",loStr,@"longitude", nil];
        NSLog(@"搜索：====》%@",dictPlace);
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [arr addObjectsFromArray:[self readData:@"searchRecords"]];
        if (arr.count == 6) {
            if ([arr containsObject:dictPlace]) {
                [arr removeObject:dictPlace];
                [arr insertObject:dictPlace atIndex:0];
            }else{
                [arr removeLastObject];
                [arr insertObject:dictPlace atIndex:0];
            }
        }else{
            if ([arr containsObject:dictPlace]) {
                [arr removeObject:dictPlace];
                [arr insertObject:dictPlace atIndex:0];
            }else{
                [arr insertObject:dictPlace atIndex:0];
            }
        }
        [self saveData:arr];
        
        [SingleShow show].block(searchCoordinate,geocode.formattedAddress,1);
     
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.searchBar resignFirstResponder];
        AMapTip *tip = self.arrResults[indexPath.row];
        NSString *recordStr = [NSString stringWithFormat:@"%@ %@", tip.district, tip.name];
        NSNumber *laStr = [NSNumber numberWithDouble:tip.location.latitude];
        NSNumber *loStr = [NSNumber numberWithDouble:tip.location.longitude];
        NSDictionary *dictPlace = [[NSDictionary alloc]initWithObjectsAndKeys:recordStr,@"place",laStr,@"latitude",loStr,@"longitude", nil];
        NSLog(@"提示：====》%@",dictPlace);
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [arr addObjectsFromArray:[self readData:@"searchRecords"]];
        if (arr.count == 6) {
            if ([arr containsObject:dictPlace]) {
                [arr removeObject:dictPlace];
                [arr insertObject:dictPlace atIndex:0];
            }else{
                [arr removeLastObject];
                [arr insertObject:dictPlace atIndex:0];
            }
        }else{
            if ([arr containsObject:dictPlace]) {
                [arr removeObject:dictPlace];
                [arr insertObject:dictPlace atIndex:0];
            }else{
                [arr insertObject:dictPlace atIndex:0];
            }
        }
        [self saveData:arr];
        NSString *key = [NSString stringWithFormat:@"%@%@", tip.district, tip.name];
        NSLog(@"%@",key.description);
        CLLocationCoordinate2D searchCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
         [SingleShow show].block(searchCoordinate,tip.name,1);
//         if ([self.searchDelegate respondsToSelector:@selector(searchWithPoint:address:tag:)]) {
//            [self.searchDelegate searchWithPoint:searchCoordinate address:tip.name tag:1];
//        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
//        [self searchAMapWithKey:key];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
- (void)searchBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 热门搜索
- (void)getDataOfHotsoso
{
     self.parkCity = @"上海市";
    if (self.parkCity != nil) {
        NSString *urlStr = [[NSString alloc]initWithFormat:@"http://b2c.ezparking.com.cn/rtpi-service/hotSearch/list.do?key=%@&city=%@",REQ_KEY,self.parkCity];
        NSString *URL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [GCD downloadWithUrlStr:URL andCallBack:^(NSData *data, NSError *error) {
           
            if (!error) {
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (arr) {
                    [_cityArr addObjectsFromArray:arr];
                    [_collectionV reloadData];
                    
                }else{
                    NSLog(@"暂无信息");
                }
            }
        }];
     }
}
- (void)createCollectWithHot
{ 
    //集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 60);
    _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)collectionViewLayout:flowLayout];
    _collectionV.backgroundColor = [UIColor whiteColor];
    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    [self.view addSubview:_collectionV];
    //注册cell和reusableView
    [_collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"records"];
    [_collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
}
#pragma -uicollectionView delegate-
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.searchRecords.count!=0) {
        return 2;
    }
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.searchRecords.count != 0) {
        if (section == 0) {
            return self.searchRecords.count;
        }else{
            return self.cityArr.count;}
    }
    return self.cityArr.count;
}
 -(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     if (_searchRecords.count != 0) {
        if (indexPath.section == 0) {
            static NSString *cellId = @"records";
            UICollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
            UILabel *label = [[UILabel alloc]initWithFrame:cell1.contentView.frame];
            label.backgroundColor = [UIColor groupTableViewBackgroundColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            [cell1.contentView addSubview:label];
            NSString *address = self.searchRecords[indexPath.row][@"place"];
            label.text = [[address componentsSeparatedByString:@" "]lastObject];
            return cell1;
        }else{
            static NSString *cellId = @"cell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
            UILabel *label = [[UILabel alloc]initWithFrame:cell.contentView.frame];
            label.backgroundColor = [UIColor groupTableViewBackgroundColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            [cell.contentView addSubview:label];
            label.text = (((NSDictionary*)[self.cityArr objectAtIndex:indexPath.row])[@"key"]);
            return cell;
             }
    }else{
        static NSString *cellId = @"cell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc]initWithFrame:cell.contentView.frame];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        [cell.contentView addSubview:label];
        NSString *text = ((NSDictionary*)[self.cityArr objectAtIndex:indexPath.row])[@"key"];
        label.text = text;
        return cell;
    }
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headView.frame.size.width-50, headView.frame.size.height)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:18];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(headView.frame.size.width-50, 0, 50, 30);
    [btn setTitle:@"×" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:30];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //        btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    indexPath1  =indexPath;
    [btn addTarget:self action:@selector(clearBtn) forControlEvents:UIControlEventTouchUpInside];
    for (UIView *view in headView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
         if (self.searchRecords.count != 0) {
        if (indexPath.section == 0) {
            [headView addSubview:btn];
            label.text = @"搜索历史";
        }else{
            label.text = @"热门搜索";
        }
        [headView addSubview:label];
        return headView;
    }
    label.text = @"热门搜索";
    [headView addSubview:label];
    return headView;
}
-(void)clearBtn{
    [[UIApplication sharedApplication].keyWindow endEditing: YES];
//    _collectionV.hidden = YES;
    [self.searchRecords removeAllObjects];
    _searchRecords = nil;
    [self saveData:_searchRecords];
    [_collectionV reloadData];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((SCREEN_WIDTH-20)/3, 35);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(1, 0, 1, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.searchRecords.count != 0) {
        if (indexPath.section == 0) {
            NSDictionary *oneStr = self.searchRecords[indexPath.row];
            [self.searchRecords removeObjectAtIndex:indexPath.row];
            [self.searchRecords insertObject:oneStr atIndex:0];
            [self saveData:self.searchRecords];
            
            NSNumber* la = oneStr[@"latitude"];
            
            NSNumber* lo = oneStr[@"longitude"];
            
           CLLocationCoordinate2D searchCoordinate = CLLocationCoordinate2DMake((double)la.floatValue, (double)lo.floatValue);
            
            [SingleShow show].block(searchCoordinate,oneStr[@"place"],1);

            
//            if ([self.searchDelegate respondsToSelector:@selector(searchWithPoint:address:tag:)]) {
//                [self.searchDelegate searchWithPoint:searchCoordinate address:oneStr[@"place"] tag:1];
//            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *city = self.cityArr[indexPath.row][@"key"];
            NSString *locationValue = self.cityArr[indexPath.row][@"value"];
            NSArray *arr = [locationValue componentsSeparatedByString:@","];
            NSLog(@"%@  %@  %@",city,arr[1],arr[0]);
            CLLocationCoordinate2D searchCoordinate = CLLocationCoordinate2DMake([arr[1] floatValue], [arr[0] floatValue]);
            
            [SingleShow show].block(searchCoordinate,city,2);

            
//            if ([self.searchDelegate respondsToSelector:@selector(searchWithPoint:address:tag:)]) {
//                [self.searchDelegate searchWithPoint:searchCoordinate address:city tag:2];
//            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        NSString *city = self.cityArr[indexPath.row][@"key"];
        NSString *locationValue = self.cityArr[indexPath.row][@"value"];
        NSArray *arr = [locationValue componentsSeparatedByString:@","];
        NSLog(@"%@  %@  %@",city,arr[1],arr[0]);
        CLLocationCoordinate2D searchCoordinate = CLLocationCoordinate2DMake([arr[1] floatValue], [arr[0] floatValue]);
        
        [SingleShow show].block(searchCoordinate,city,2);

        
//        if ([self.searchDelegate respondsToSelector:@selector(searchWithPoint:address:tag:)]) {
//            [self.searchDelegate searchWithPoint:searchCoordinate address:city tag:2];
//        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   }
/**
 *  （搜索历史记录）存数据
 */
-(void)saveData:(NSArray*)arr{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:arr forKey:@"searchRecords"];
    [userDefaults synchronize];
}
/**
 *  （搜索历史记录）取数据
 */
-(NSArray*)readData:(NSString*)str{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return (NSArray*)[userDefaults objectForKey:str];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    _collectionV.frame = CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-kbSize.height-10);
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:1 animations:^{
        _collectionV.frame = CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    }];
    
}
#pragma mark - 统计

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //释放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
 }
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication].keyWindow endEditing: YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
