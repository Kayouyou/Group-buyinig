//
//  SearchBarTableViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/23.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "SearchBarTableViewController.h"
#import "WebViewController.h"
#import "DianpingApi.h"
#import "BusinessTableViewCell.h"


@interface SearchBarTableViewController ()<UISearchBarDelegate>//searchbar 代理

//参数
@property (nonatomic,strong)NSMutableDictionary *params;

//商户信息
@property (nonatomic,strong) NSArray *businesses;
@end

@implementation SearchBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1，创建参数对象
    self.params = [NSMutableDictionary new];
    
    //2,创建searchbar
    
    UISearchBar *sbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
   
    //3,设置searchbar的代理
    
    sbar.delegate = self;
    
    //4,添加到vc
    
    self.tableView.tableHeaderView = sbar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 设置searchBar 为键盘第一响应者
-(void)viewDidAppear:(BOOL)animated{

    UISearchBar *sbar = (UISearchBar*)self.tableView.tableHeaderView;

    //成为第一响应者！
    [sbar becomeFirstResponder];


}

#pragma mark - 设置searchBar 的点击事件响应的方法实现

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    //1，searchbar 输入的目标城市
    NSString *targetCity = searchBar.text;
  
    //2, 绑定key value 键值对
    
    [self.params setObject:targetCity forKey:@"keyword"];
    
    //3,点击search 后释放第一响应者的身份
    
    [searchBar resignFirstResponder];
    
    //4,通过第三方库 应用接口 获取响应数据
    
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
      
        //5，拿回回调回来的数据
        self.businesses = obj;
        
        //6,更新
        
        [self.tableView reloadData];
        
        
    }];



}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    //1，设置重用的cell
    static NSString *cells = @"BusinessTableViewCell";
    
    //2，自定义单元格
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cells];
    
   //3, 加载自定义的 cell
    
    if (!cell) {
        
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessTableViewCell" owner:self options:nil]lastObject];
        
    }
    
    BusinessInfo *business = self.businesses[indexPath.row];
    
    cell.business = business;
    

    return cell;
}

#pragma mark - 设置单元格的 行高 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 90;


}

#pragma mark - 点击搜素返回的商户信息列表的单元格触发的事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //1,首先拿到  对应行的商户信息
    BusinessInfo *binfo = self.businesses[indexPath.row];
    
    //2,创建webview
    
    WebViewController *webVC = [WebViewController new];
    
    
    //3,绑定网络URL
    webVC.urlString = binfo.business_url;
    
    //4,推出webview时 隐藏bottomBar
    
    webVC.hidesBottomBarWhenPushed = YES;
    
    //5,navigationController  push
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    webVC.hidesBottomBarWhenPushed = NO;
    

}


@end
