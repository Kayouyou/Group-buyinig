//
//  SearchCitiesTableViewController.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/23.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "SearchCitiesTableViewController.h"
#import "pinyin.h"
@interface SearchCitiesTableViewController ()

//声明 一个字典的value  是一个城市
@property (strong,nonatomic) NSMutableDictionary *cityDict;

//所有的 keys  就是所有的26个英文字母
@property (strong,nonatomic)NSArray *allSortedKeys;



@end

@implementation SearchCitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1，首先，创建city对象
    self.cityDict = [NSMutableDictionary new];

    //2, 获取cities plist 文件
    NSString *path = [[NSBundle mainBundle]pathForResource:@"citys" ofType:@"plist"];
    
    //3, 根据路径从plist文件中读取数据   也就是城市 数组
    NSArray * cities = [NSArray arrayWithContentsOfFile:path];
    
    //4, 遍历所有的城市  以城市拼音的首字母  为key 一一对应该城市
    
    for (NSString *cityName in cities) {
        
        //调用第三方库的方法  传入 城市的首字   直接获取改字的第一个字母
        char firstLetter = pinyinFirstLetter([cityName characterAtIndex:0]);
        
        //把获取的首字母  作为字典的 key 与城市相对应
        NSString *key = [NSString stringWithFormat:@"%c",firstLetter];
        
        //依据key逐一取出相应的城市名 并用来创建一个以同一个首字母为标签的城市数组
        NSMutableArray *sameLetterCities = [self.cityDict objectForKey:key];
        
        //第一次 做一下判断  如果没有创建 就创建一下
        if (!sameLetterCities) {
            
            sameLetterCities = [NSMutableArray new];
            
            [self.cityDict setObject:sameLetterCities forKey:key];
            
        }
        
        //将统一首字母的加一起！！！
        [sameLetterCities addObject:cityName];
        
        }

    //数组排序详细说明链接
   //http://blog.csdn.net/xiaoxuan415315/article/details/9198729
//第一种，利用数组的sortedArrayUsingComparator调用 NSComparator ，obj1和obj2指的数组中的对象

//第二种 排序方法 利用sortedArrayUsingFunction 调用 对应方法customSort，这个方法中的obj1和obj2分别是指数组中的对象。

    
    
    
    
    
    
self.allSortedKeys = [self.cityDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
   
    return [obj1 compare:obj2];
    
    
}];
    NSString *str = @"list";
    
    //[self.allSortedKeys insertObject:str atIndex:0];
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.cityDict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //根据不同的字母  行数也不同
    //先根据不同的分区 取出响应的key
    NSString *key = self.allSortedKeys[section];
    //在根据key 来取出对应的城市数组   也就的 到行数了
    
    NSArray *cities = [self.cityDict objectForKey:key];
    
    
    
    return cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //先拿到当前分区的key
    NSString *key = self.allSortedKeys[indexPath.section];
    //在通过拿到的key 来获取value  也就是响应的城市
    NSArray *cities = [self.cityDict objectForKey:key];
    
    //获取当前行的下标  依次对应数组的下标 拿到每一行对应的值
    NSString *cityName = cities[indexPath.row];
    
    //给单元格的label 赋值
    cell.textLabel.text = cityName;
    
    NSLog(@"%@",cityName);
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return self.allSortedKeys[section];
}

//在视图的右侧  添加一个list 显示每一个分区的title

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    return self.allSortedKeys;

}

//响应点击某一单元格的事件方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = self.allSortedKeys[indexPath.section];
    //获取选择的城市
    NSArray *choosedCities = [self.cityDict objectForKey:key];
    
    NSString *cityName = choosedCities[indexPath.row];
    NSLog(@"选中的城市是%@",cityName);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:cityName forKey:@"cityName"];
    
    [ud synchronize];
    
    
//添加通知
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityChanged" object:nil userInfo:@{@"cityName":cityName}];
    
//选择城市 返回首页
    [self.navigationController popViewControllerAnimated:YES];



}









@end
