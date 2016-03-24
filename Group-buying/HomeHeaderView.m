//
//  HomeHeaderView.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/19.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView

/*
 -(id)initWithCoder:(NSCoder *)coder;//从coder中读取数据，保存到相应的变量中，即反序列化数据
 -(void)encodeWithCoder:(NSCoder *)coder;// 读取实例变量，并把这些数据写到coder中去。序列化数据
 
 
 
 */



- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        NSArray *labelText = @[@"美食",@"电影",@"酒店",@"KTV",@"小吃",@"休闲娱乐",@"今日新品",@"更多"];
        
        for (int i = 0; i < 8; i++) {
            
            UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(i%4*80+10, i/4*90+10, 60, 60)];
            headerButton.tag = i;
            [headerButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"首页_1%d",i+1]] forState:UIControlStateNormal];
            
            [headerButton addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:headerButton];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i%4*80+10, i/4*90+80, 60, 10)];
            label.text = labelText[i];
            
            label.textAlignment = NSTextAlignmentCenter;
            
            label.textColor = [UIColor lightGrayColor];
            
            label.font = [UIFont fontWithName:@"黑体-简" size:11];
            label.textColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1];
            [self addSubview:label];
            
            
            }
        
        }

    return self;

}


#pragma mark - categoryClick 
//给button添加点击事件 
-(void)categoryClick:(UIButton *)button{

    NSString *category = @"美食";
    switch (button.tag) {
        case 1:
            category = @"电影";
            break;
            
        case 2:
            category = @"酒店";
        break;
    
    
        case 3:
            category = @"KTV";
            break;
    
        case 4:
            category = @"购物";
            break;
    
        case 5:
            category = @"休闲娱乐";
            break;
    
    
        case 6:
            category = @"旅行社";
            break;
    
        case 7:
            category = @"购物";
            break;
    }
    
    
    
    //消息名字为clickedCategory  发送消息   响应分类按钮点击事件
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickedCategory" object:nil userInfo:@{@"category":category}];
    
    
}













@end
