//
//  ViewController.h
//  MHTabBar
//
//  Created by Tarena on 15/1/14.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MHCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (copy,nonatomic) NSString *selectedText;
@property (strong,nonatomic) NSMutableDictionary *dataDict;
@property (strong,nonatomic) UITableView *leftTableView;
@property (strong,nonatomic) UITableView *rightTableView;

@end
