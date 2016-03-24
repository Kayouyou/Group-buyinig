//
//  SettingsTableViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/30.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "SettingsTableViewController.h"

#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]
@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置背景色
- (void)viewWillAppear:(BOOL)animated{


    [self initUI];


}

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







@end
