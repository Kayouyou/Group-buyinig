//
//  Group-buyingTableViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/21.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "Group-buyingTableViewController.h"
#import "DianpingApi.h"
#import "Group-buying.h"
#import "Group_buyingTableViewCell.h"
#import "WebViewController.h"

//第三方库  为了设置团购页面上面的选项栏
#import "TheFirstViewController.h"
#import "TheSecondViewController.h"
#import "TheThirdViewController.h"
#import "MHTabBarController/MHTabBarController.h"


//第三方控件
#import "SVProgressHUD.h"

#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]
//代理第三方库   实现其中的代理方法
@interface Group_buyingTableViewController ()<MHTabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray *Group_buying;

@property (nonatomic,strong) MHTabBarController *TBC;
@property (nonatomic,strong) NSMutableDictionary *MDict;
//声明一个page属性
@property (nonatomic,assign) int currentPage;

@end

@implementation Group_buyingTableViewController

//引用第三方库的 方法
-(void)subViewController:(UIViewController *)subViewController SelectedCell:(NSString *)selectedText{

    if ([subViewController.title isEqualToString:@"全部分类"]) {
        
        [self.MDict setObject:selectedText forKey:@"category"];
    
    }else if ([subViewController.title isEqualToString:@"全部地区"]){
    
        [self.MDict setObject:selectedText forKey:@"region"];
        NSLog(@"test:%@",selectedText);
    
    }else{
    
        int orderType = 1;
        if ([selectedText isEqualToString:@"价格低优先"])
            orderType = 2;
        else if ([selectedText isEqualToString:@"价格高优先"])
            orderType = 3;
        else if([selectedText isEqualToString:@"购买人数多优先"])
            orderType = 4;
        
        [self.MDict setObject:@(orderType) forKey:@"sort"];
        
    
    }

[DianpingApi requestDealsWithParams:self.MDict AndCallback:^(id obj) {
   
    self.Group_buying = obj;
    [self.tableView reloadData];
    
    
}];


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MDict = [NSMutableDictionary dictionary];

    //[SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    
    
    
    //给当前页数赋初始值 1
    self.currentPage = 1;
    
    /*
     现在总结他们2者的区别就是：
     1, setObject：forkey：中value是不能够为nil的，不然会报错。
     setValue：forKey：中value能够为nil，但是当value为nil的时候，会自动调用removeObject：forKey方法
     2, setValue：forKey：中key的参数只能够是NSString类型，而setObject：forKey：的可以是任何类型
     
     注意：setObject：forKey：对象不能存放nil要与下面的这种情况区分：
     1, [imageDictionarysetObject:[NSNullnull] forKey:indexNumber];
     [NSNull null]表示的是一个空对象，并不是nil，注意这点
     
     2, setObject：forKey：中Key是NSNumber对象的时候，如下：
     [imageDictionarysetObject:obj forKey:[NSNumber numberWithInt：10]];
     
     注意：
     上面说的区别是针对调用者是dictionary而言的。
     setObject:forKey:方法NSMutabledictionary特有的,而
     setValue:forKey:方法是KVC（键-值编码）的主要方法。
     
     当 setValue:forKey:方法调用者是对象的时候：
     setValue:forKey:方法是在NSObject对象中创建的，也就是说所有的oc对象都有这个方法，所以可以用于任何类。
     比如使用:
     SomeClass *someObj = [[SomeClass alloc] init];
     [someObj setValue:self forKey:@"delegate"];
     表示的意思是：对象someObj设置他的delegate属性的值为当前类，当然调用此方法的对象必须要有delegate属性才能设置，不然调用了也没效果

     */
    [self.MDict setObject:@(self.currentPage) forKey:@"page"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getGroup_buying];
    
    [self initUI];
    
    //创建tabbar
    
    [self createTBC];
}

//给团购的导航也添加背景图
-(void)initUI{
    //设置状栏 的frame
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    //    // 添加
    [self.navigationController.navigationBar addSubview:statusBarView];
    //    //设置导航栏的背景色
    statusBarView.backgroundColor = TOPIC_COLOR_ORANGE;

    //设置导航栏字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //设置导航栏的的背景色
    self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;


}

#pragma mark - 创建tabbar

-(void)createTBC{

//如果创建过  就直接返回
    if (self.TBC) {
        return;
    }

    self.TBC = [[MHTabBarController alloc]init];
    
    self.TBC.delegate = self;
   
    //1,创建 category 的控制器
    TheFirstViewController *category1 = [[TheFirstViewController alloc]init];
    category1.title = @"全部分类";
    
    //2,创建 region 控制器
    TheSecondViewController *region1 = [[TheSecondViewController alloc]init];
    
    region1.title = @"全部地区";
    
    //3,创建 排序  控制器
    TheThirdViewController *sort1 = [[TheThirdViewController alloc]init];
    
    sort1.title = @"智能排序";

    self.TBC.viewControllers = @[category1,region1,sort1];

    //把tbc作为tableview的头视图
    
    self.tableView.tableHeaderView = self.TBC.view;

    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
}




#pragma mark - 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleDefault;

}


#pragma mark - 请求团购信息

-(void)getGroup_buying{

    [DianpingApi requestDealsWithParams:@{} AndCallback:^(id obj) {
        
        self.Group_buying = obj;
        
        NSLog(@"qingqiutuango :%@",obj);
        [self.tableView reloadData];
        

    }];

}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.Group_buying.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cells";
    
    
    
    Group_buyingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Group_buyingTableViewCell" owner:self options:nil] lastObject];
        
        
        
    }
    
    Group_buying *deal = self.Group_buying[indexPath.row];
    
    cell.deal = deal;

   //  优化  判断显示的是否是最后一行】  以便继续加载图片  而不是拉倒末尾就没有更新的图片继续显示
    if (indexPath.row == self.Group_buying.count-1) {
        
        
        
        //如果是最后一行了  就加一页
        [self.MDict setObject:@(++self.currentPage) forKey:@"page"];
        
        //加一页的同时 就需要在调用API一次来更新数据信息
        [DianpingApi requestDealsWithParams:self.MDict AndCallback:^(id obj) {
           
            //从心传回来数组的数据 加入 可变数组 团购中
            [self.Group_buying addObjectsFromArray:obj];
            
            //更新tableview
            [self.tableView reloadData];
            
        }];
        
        
    }
    

    return cell;
}


#pragma mark - 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;

}


#pragma mark - 推出webView

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    WebViewController *webView = [[WebViewController alloc]init];
    
    webView.urlString = ((Group_buying*)[self.Group_buying objectAtIndex:indexPath.row]).deal_h5_url;

    webView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webView animated:YES];
    
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
