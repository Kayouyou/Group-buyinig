//
//  TheThirdViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/22.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "TheThirdViewController.h"

@interface TheThirdViewController ()

@end

@implementation TheThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //本身没有plist 文件   所以字典信息  自己设置
    
    //同样继承父类中的方法  赋值给 title
    
    [self.dataDict setObject:@[@"默认",@"价格低优先",@"价格高优先",@"购买人数多优先"] forKey:self.title];
    
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
