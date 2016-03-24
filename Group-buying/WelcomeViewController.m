//
//  WelcomeViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/19.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//
/*
 定义设备的屏幕的宽和高
 */
#define YDEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define YDEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height

#import "WelcomeViewController.h"
#import "AppDelegate.h"
@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//从欢迎页进入主页按钮

@property (nonatomic,strong) UIButton *enterButton;
@end


@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认就是NO
    [self prefersStatusBarHidden];
    //翻页设置打开
    self.scrollView.pagingEnabled = YES;
    //打开欢迎界面水平滚动
    self.scrollView.showsHorizontalScrollIndicator = YES;
    //关闭页面上下滚动
    self.scrollView.showsVerticalScrollIndicator = NO;
    //设置滚动视图的内容视图大小   三个主视图宽的宽度   根据欢迎界面的页数二决定
    self.scrollView.contentSize = CGSizeMake(YDEVICE_WIDTH * 3, YDEVICE_HEIGHT);
    
    //设置滚动视图的代理
    self.scrollView.delegate = self;
    
    //调用添加图片的方法
    [self addPicturesData];
    
    
    
}

#pragma mark - 添加图片的方法

-(void)addPicturesData{
    
    for (int i = 0; i < 3; i++) {
        //每次滚动一个固定宽度的距离
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(YDEVICE_WIDTH * i, 0, YDEVICE_WIDTH, YDEVICE_HEIGHT)];
        //根据i 的值  来取相应的图片
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页－%d.jpg",i + 1]];
        
        //一一对应添加图片
        [self.scrollView addSubview:imageView];
        
        //添加enterButton
        if(2 == i){
           
            //打开此页的用户交互设置
            imageView.userInteractionEnabled = YES;
            //设置button的位置 大小  尽可能大一点  用户点击面也就相应的大一点
            self.enterButton = [[UIButton alloc] initWithFrame:CGRectMake(103, 501, 118, 35)];
            //给按钮添加点击事件
            [self.enterButton addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
            
            //添加按钮到视图上面
            
            [imageView addSubview:self.enterButton];
            
        }
        
    }
    
}


#pragma mark - enter 进入主页的按钮响应方法

-(void)enter{
//设置Appdelegate的单例

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //把故事版的根视图 还给 mainvc
    app.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainvc"];
   
    
    
  
    // 第一次浏览时 会显示欢迎界面   之后就不在显示了
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
   
    
    
    [UD setBool:YES forKey:@"isVisibled"];
    //保存设置［[NSUserDefaultsstandardUserDefaults] synchronize］命令直接同步到文件里，来避免数据的丢失。

    [UD synchronize];

}













@end
