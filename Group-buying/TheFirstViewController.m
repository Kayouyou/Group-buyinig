//
//  TheFirstViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/22.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "TheFirstViewController.h"

@interface TheFirstViewController ()

@end

@implementation TheFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
   //读取plist 文件  因为在本地  所以用nsbundle来获取路径
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"plist"];

   //继承至父类 MHCategoryViewController  它有的属性 字典类型的 dataDict
    
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
