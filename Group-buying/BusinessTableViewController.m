//
//  BusinessTableViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/20.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "BusinessTableViewController.h"
#import "WebViewController.h"
#import "DianpingApi.h"
#import "BusinessTableViewCell.h"
#import "BusinessInfo.h"

//第三方控件
#import "SVProgressHUD.h"



#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]
@interface BusinessTableViewController ()

//声明businesses 属性  保存传进来的值
@property (nonatomic,strong) NSArray *businesses;



//为了设置加载webview的小动画效果
//@property(nonatomic,strong)UIImageView *animationImageView;
//@property(nonatomic,strong)UIImage *image;
//@property(nonatomic,strong)UILabel *label;

@end

@implementation BusinessTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给推出的business页面添加相应的category的名称
    
    self.navigationItem.title = self.category;
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    
    //调用得到对应分类category的商户信息的方法
    [self getBusinesses];
    
}

#pragma mark - 请求商户信息

-(void)getBusinesses{

    //调用api里面的带有参数 category 的 方法
    [DianpingApi requestBusinessWithParams:@{@"category":self.category} AndCallback:^(id obj) {
        
        // 这里的 obj 就是 得到的 商户信息
        self.businesses = obj;
        
    
        
        
        //更新tableview 界面
        
        [self.tableView reloadData];
        
        
        
    }];

}









#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //有多少商户信息就有多少行
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   //定义一个 静态的  作用域 只在 .m文件里   要么implementation外面 要么方法内部
    static NSString *cells = @"BusinessTableViewCell";
    
    //自定义的单元格
    BusinessTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cells];
    
    if (!cell) {
        
        //自定义单元格  如果带nib文件 必须调用这个方法 来加载nib文件
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessTableViewCell" owner:self options:nil]lastObject];
        
        }
    //商户信息  跟 对应行的下标一一对应
    BusinessInfo *business = self.businesses[indexPath.row];
    
    //把传来的值  付给 自己的business 属性
    cell.business = business;
    
    
    return cell;
}

#pragma mark - 设置每一行单元格的高

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 90;



}


#pragma mark - 设置每一行点击促发事件反馈的信息

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessInfo *info = self.businesses[indexPath.row];
    
    //点击某行单元格  会推出一个WEBVC   显示相应的详细信息
    //先创建一个WEBVC对象
    WebViewController *webVC = [[WebViewController alloc]init];
    
    //webvc  根据传来的商户信息的URL   来显示响应的信息
    webVC.urlString = info.business_url;
    
    //推出的web 界面是  隐藏bottomBar
    webVC.hidesBottomBarWhenPushed = YES;
    
    //调用推出下一个界面的方法  带动画
    [self.navigationController pushViewController:webVC animated:YES];

    

    
    
}

#pragma mark - 判断加载页面的显示结束时机
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,第三方控件方法
    
    if([indexPath row] == 5){
        
        [SVProgressHUD dismiss];
        
    }
    


}











@end
