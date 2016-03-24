//
//  WebViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/20.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "WebViewController.h"
#import "UIView+MarkSharedView.h"
@interface WebViewController ()<UIWebViewDelegate,UIActionSheetDelegate>

@property (nonatomic,assign)BOOL isChooseShareButton;

@property(nonatomic,assign)BOOL isLoading;

//为了设置加载webview的小动画效果
@property(nonatomic,strong)UIImageView *animationImageView;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UILabel *label;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isChooseShareButton = NO;
    
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    
   
    

    self.isLoading = NO;
    //设置webview 的 大小  属性
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.delegate = self;
    //拿到URL
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    //根据URL 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"============%@",url);
    
    //加载webview
    [self.view addSubview:self.webView];
    
    //实现请求
    [self.webView loadRequest:request];
    
    //设置 滚动视图内容视图的边距大小
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(-44, 0, 0, 0)];

    //添加动画效果
    
    
    [self addAnnotation];

}

-(void)addAnnotation{


    self.animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.animationImageView.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height*0.5);
    self.animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.image = [UIImage  animatedImageNamed:@"icon_loading_animating_" duration:2*1/10.0];
    self.animationImageView.image = self.image;
    [self.view addSubview:self.animationImageView];

    self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.animationImageView.frame.origin.x,self.animationImageView.frame.origin.y+160, self.animationImageView.frame.size.width, 20)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.label.text = @"正在努力加载中...";
    [self.view addSubview:self.label];


}



//webView  push  and pop
- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    self.isLoading = YES;
    //移除label
    [self.label removeFromSuperview];
    
    //移除动画
    
    [self.animationImageView removeFromSuperview];
    
    
}



//解决webview推出时,页面层次递进关系 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if (self.isLoading == YES) {
        WebViewController *weVC = [WebViewController new];
        //url.absolutestring  得到的就是字符串
        weVC.urlString = request.URL.absoluteString;
        [self.navigationController pushViewController:weVC animated:YES];
        return NO;
    }
    return YES;

}


#pragma - mark shareAction

- (void)shareAction:(UIBarButtonItem *)sender{

  //弹出actionsheet
    UIActionSheet *mySheet = [[UIActionSheet alloc]initWithTitle:@"提醒:分享需要授权访问您要分享的应用" delegate:self
        cancelButtonTitle:@"取消分享"destructiveButtonTitle:@"确定分享" otherButtonTitles:nil];
    
    [mySheet showInView:self.view];
    

    


}


#pragma mark - actionsheet的代理方法

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
      
        //会触发分享按钮界面的弹出 ！！！
        self.isChooseShareButton = !self.isChooseShareButton;
        
        if (self.isChooseShareButton) {
            
            //调用"UIView+MarkSharedView.h" 的方法 ！
            [self.view chooseSharedFunctionWithWebUrl:self.webView.request.URL];
            
            
        }else {
            
            [self.view dismiss];
            
            
        }
 
        
    }else if (buttonIndex == 1){}
    else{}
    










}













@end
