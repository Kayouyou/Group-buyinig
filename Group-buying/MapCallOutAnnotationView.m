//
//  MapCallOutAnnotationView.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/28.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "MapCallOutAnnotationView.h"

#import "MapCallOutAnnotationViewCell.h"

//要设置成为tableview的代理

@interface MapCallOutAnnotationView()<UITableViewDataSource,UITabBarDelegate>

@property (nonatomic,strong)UITableView *tableView;


@end





@implementation MapCallOutAnnotationView

//延迟加载tableview
-(UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        
        _tableView.dataSource = self;

        _tableView.delegate = self;
        
        
        
        
        
    }



    return _tableView;


}

-(void)setBusiness:(BusinessInfo *)business{


    _business = business;

    self.frame = CGRectMake(0, 0, 200, 50);
    [self.tableView registerNib:[UINib nibWithNibName:@"MapCallOutAnnotationViewCell" bundle:nil] forCellReuseIdentifier:@"pushMapCell"];
    [self addSubview:self.tableView];
    
    [self.tableView reloadData];
    
    self.tableView.scrollEnabled = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.bounds = CGRectMake(0, 0, 200, 100 + 60);
    


}

#pragma mark - tableView datasource 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 1;


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MapCallOutAnnotationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushMapCell" forIndexPath:indexPath];
    
    cell.descriptionLabel.text = self.business.name;
    
    cell.urlString = self.business.business_url;

    //返回主线程加载图片
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSString *str = [self.business.s_photo_url stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            cell.iconImage.image = [UIImage  imageWithData: data];
            
            [cell setNeedsLayout];
            
            
        
        });
        
    
    });
    

    return cell;

}


//设置cell的点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   MapCallOutAnnotationViewCell *cell = (MapCallOutAnnotationViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //点击时间交给mapViewController处理
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushWebViewNotification" object:nil userInfo:@{@"url":cell.urlString}];
    
    [self removeFromSuperview];
}

















@end
