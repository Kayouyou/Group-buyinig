//
//  HeaderTableViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/19.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//


#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]


#import "HeaderTableViewController.h"
#import "BusinessTableViewController.h"
#import "BusinessTableViewCell.h"
#import "MarkGet_two-dimension.h"

//第三方控件

#import "SVProgressHUD.h"

@interface HeaderTableViewController ()<UIAlertViewDelegate,MarkGet_twodimensionDelegate,UIScrollViewDelegate>

//添加扫二维码的view的属性

@property (nonatomic,strong)MarkGet_two_dimension *dimensionView;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) NSMutableArray *businesses;

//加载的显示图
@property (nonatomic,strong) UIActivityIndicatorView* activityIndicatorView;
//设置显示页面的配置
@property (nonatomic,strong) NSMutableDictionary *params;

@property (nonatomic,assign) int currentPage;

@property(nonatomic,assign)BOOL isLoading;
@end

@implementation HeaderTableViewController

- (void)viewDidLoad {
    
    self.params = [NSMutableDictionary new];
    
    self.isLoading = NO;
    
    //添加activityindicatorview  可以是系统的也可以是第三方控件的   SVpROGRESSHUD
    
    [self addActivity];
    
    
    //默认当期第一页
    self.currentPage = 1;
    
    [self.params setObject:@(self.currentPage) forKey:@"page"];
    //设置页数限制
    [self.params setObject:@(20) forKey:@"limit"];
    
    [super viewDidLoad];
    //初始化
    [self initHeaderView];
    
    //1，已在homeheaderview 里发送通知
    //2，添加监听 当用户点击自动以headerView礼里面的分类按钮的时候响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickedCategory:) name:@"clickedCategory" object:nil];
}

#pragma mark - addActivity

-(void)addActivity{

    //1,第三方方法
   // [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    
    
    
    
 //2,系统方法
//    self.activityIndicatorView = [ [ UIActivityIndicatorView  alloc ]
//                                                      initWithFrame:CGRectMake(0,0,200.0,200.0)];
//    
//    
//    
//    self.activityIndicatorView.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height*0.5);
//    
//    self.activityIndicatorView.contentMode  = UIViewContentModeScaleAspectFill;
//    
//    //大型化白的的指示器
//    _activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
//    
//    //如果希望指示器停止后自动隐藏，那么要设置hidesWhenStoped属性为YES。默认是YES。设置为NO停止后指示器仍会显示。
//    _activityIndicatorView.hidesWhenStopped = YES;
//    
//    
//    //启动
//    [_activityIndicatorView startAnimating];
//
//    [self.view addSubview:_activityIndicatorView ];

}

//判断是否是到达可看区域的所有行的最后一行  然后停止activityview
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,第三方控件方法
    
    if([indexPath row] == 3){

        self.tabBarController.tabBar.hidden = NO;
        [SVProgressHUD dismiss];
    
    }
//2，系统方法
//    if([indexPath row] == 3){
//        
//        [_activityIndicatorView stopAnimating];
//    }
}


#pragma mark -   clickedCategory:

-(void)clickedCategory:(NSNotification*)notif{
    
    NSLog(@"1111111111111111%@",notif.userInfo);
    //在这个位置跳转页面显示所点击的分类内容
    NSString *category = [notif.userInfo objectForKey:@"category"];
    
    /* 这里为什么没有用present 的原因 
     基本绝大部分情况下，这个成员方法都可以正常使用，不过有些时候可能会使用失败，失败一般的原因都是，同一个视图控制器，在同一个时间，只能present一个另外的视图控制器，如果当前的VC已经present了，再次present一个VC时，就会提示失败，具体的失败提示在log里面有，我忘了就不说了，如果想继续present，就必须将原来present的控制器dismiss。
     */
    //通过segue 把点击按钮对应的category信息  传给businessvc 视图控制器
    //跳转页面
//#warning 有更改
    //这是navigation push的方法
   // [self.navigationController  pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>];
   
   //注意一定要设置segue的identifier
  [self performSegueWithIdentifier:@"businessvc" sender:category];
    
}

#pragma mark - reloadUI
//更新UI
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
    
    
    
    self.tabBarController.tabBar.hidden = NO;
//    //设置城市label
//    self.cityLabel.text = @"北京";
}

#pragma mark - 视图即将出现的时候 

-(void)viewWillAppear:(BOOL)animated{
    
    //设置界面
    [self initUI];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //取出keycityName  对应的value
    NSString *cityName = [ud objectForKey:@"cityName"];
    if (!cityName) {
        
        //如果默认设置城市名位空   默认为北京
        cityName = @"深圳";
        [ud setObject:cityName forKey:@"cityName"];
       
        //.强制让数据立刻保存
        [ud synchronize];
        
    }
    //tablebar的textlabel现实城市名
    self.cityLabel.text = cityName;
    

    //拿到数据
    [self getBusinesses];
    
    //这个时候不要掩藏tabbar
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark - 视图显示后 

-(void)viewDidDisappear:(BOOL)animated{
    
    //设置状态栏 为默认值
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 初始化tableheaderview
-(void)initHeaderView{
    
    //把headerview  设置为 tableview的头饰图 
    self.headerView = self.tableView.tableHeaderView;
    
    //设置头饰图的大小
    self.headerView.frame = CGRectMake(0, 0, 320, 200);
    
    
}

#pragma mark - 分类按钮点击事件

-(void)categoryClick:(UIButton*)btn{
  
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -请求商户信息
-(void)getBusinesses{
    
    //通过API的类方法 得到商户的数据
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
        //block块对象  返回的就是businesses  详情请看DianpingAPI.m
        self.businesses = obj;
        NSLog(@"test,params:%@",self.params);
        //更新tableview
        [self.tableView reloadData];
    }];
   

}

#pragma mark - Table view data source
//section  可以省略     这里省略了
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //有多少的商户就有多少的行
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //在Objective-C 的语法中声明后的static静态变量在其他类中是不能通过类名直接访问的，它的作用域只能是在声明的这个.m文件中 。static关键字声明的变量必须放在implementation外面，或者方法中，如果不为它赋值默认为0，它只在程序开机初始化一次。
    static NSString *cells = @"BusinessTableViewCell";
    
    
    
    //自定义的cell
    BusinessTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cells];
    if (!cell) {
   
        //加载自定义的cell BusinessTableViewCell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessTableViewCell" owner:self options:nil]lastObject];
    }
    
    BusinessInfo *business = self.businesses[indexPath.row];
    
    cell.business = business;
  
    //设置页面的更新属性
    //超过limit的20个的限制 就页面加一
    if (self.businesses.count-1 == indexPath.row) {
        
        [self.params setObject:@(++self.currentPage) forKey:@"page"];
        [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
            
            [self.businesses addObjectsFromArray:obj];
            [self.tableView reloadData];
            
            
        }];
        
        
    }
    
    return cell;
}



//设置sectionheader的 title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //设置分区头的title
    NSString * str = @"猜你所想";
    
    return str;
}


//设置单元格的高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;


}

#pragma mark - 设置点击行所促发的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessInfo *info = self.businesses[indexPath.row];
    
    WebViewController *webVC = [[WebViewController alloc]init];
    
    webVC.urlString = info.business_url;
    
    webVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    webVC.hidesBottomBarWhenPushed = NO;
    

}

#pragma mark - navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //segue 推出的vc   必须提前实现这个 把下一个vc设置为 segue 的目的视图控制器
    if ([segue.identifier isEqualToString:@"businessvc"]) {
        BusinessTableViewController *vc = segue.destinationViewController;
        
        //把 category 传过去
        vc.category = sender;
    }
    
    
   


}

#pragma mark - 获取二维码
- (IBAction)get_twodimension:(id)sender {


    for (id sub in self.view.subviews) {
        
        if ([sub isKindOfClass:[MarkGet_two_dimension class]]) {
            
            [self.dimensionView.captureSession stopRunning];
            
            [self.dimensionView removeFromSuperview];
            
            return;
            
        }
    }


    self.dimensionView = [[MarkGet_two_dimension alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.dimensionView];
    self.dimensionView.backgroundColor = [UIColor redColor];
    //[self.view bringSubviewToFront:self.dimensionView];
    [self.dimensionView get_twodimension];
    
    self.dimensionView.delegate = self;

}

#pragma --mark dimensional代理
-(void)get_twodimensionSuccessWithInfo:(NSString *)info{

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描的的链接是:%@",info] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.dimensionView removeFromSuperview];
    }];
    UIAlertAction *gotoWeb = [UIAlertAction actionWithTitle:@"打开链接" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.dimensionView removeFromSuperview];
        
      
        [self gotoWebviewWith:info];
    
    }];
    
    
    [alert addAction:cancel];
    [alert addAction:gotoWeb];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)gotoWebviewWith:(NSString *)str {
   WebViewController *webVC = [WebViewController new];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.urlString = str;
    [self.navigationController pushViewController:webVC animated:YES];
}















@end
