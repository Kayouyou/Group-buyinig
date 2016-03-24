//
//  TheSecondViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/22.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "TheSecondViewController.h"

@interface TheSecondViewController ()

@end

@implementation TheSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1，获取region 的plist 文件
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"plist"];
    
    //2，获取其中的信息 赋给通过父类继承来的属性
    
    self.dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
