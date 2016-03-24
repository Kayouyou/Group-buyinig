//
//  UIView+MarkSharedView.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/6/1.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MarkSharedView)

//这里需要加入属性但是分类是不可以添加属性的 所以这里用到了 运行时#import <objc/runtime.h>

//1,分享页面的滚动视图控制器
@property (nonatomic,strong)UIScrollView *sharedScroller;

//2,要分享的URL
@property (nonatomic,strong)NSURL *url;


//添加的方法
- (void)chooseSharedFunctionWithWebUrl:(NSURL *)url;

- (void)dismiss;












@end
