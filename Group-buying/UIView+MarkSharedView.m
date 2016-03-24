//
//  UIView+MarkSharedView.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/6/1.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//


#define SPACE_UP_DOWN 10
#define SPACE_LEFT_RIGHT 5
#define ICON_WIDE_HEOGH 50
/*
 关联是指把两个对象相互关联起来，使得其中的一个对象作为另外一个对象的一部分。
 关联特性只有在Mac OS X V10.6以及以后的版本上才是可用的。
 在类的定义之外为类增加额外的存储空间
 使用关联，我们可以不用修改类的定义而为其对象增加存储空间。这在我们无法访问到类的源码的时候或者是考虑到二进制兼容性的时候是非常有用。
 关联是基于关键字的，因此，我们可以为任何对象增加任意多的关联，每个都使用不同的关键字即可。关联是可以保证被关联的对象在关联对象的整个生命周期都是可用的（在垃圾自动回收环境下也不会导致资源不可回收）。
 创建关联
 创建关联要使用到Objective-C的运行时函数：objc_setAssociatedObject来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。当然，此处的关键字和关联策略是需要进一步讨论的。
 ■  关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
 ■  关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；还有这种关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。这种关联策略是通过使用预先定义好的常量来表示的。
 
 
 
 
 */



#import "UIView+MarkSharedView.h"
#import "MarkSharedTool.h"
#import <objc/runtime.h>
@implementation UIView (MarkSharedView)

//为了在category里加属性  需要重写set  get 方法
- (void)setUrl:(NSURL *)url{

    objc_setAssociatedObject(self, @"shareUrl", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    
    
}

- (NSURL *)url {

    return objc_getAssociatedObject(self, @"shareUrl");

    
}

- (void)setSharedScroller:(UIScrollView *)sharedScroller{

    objc_setAssociatedObject(self, @"sharedScroller", sharedScroller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);




}


- (UIScrollView *)sharedScroller {

    return objc_getAssociatedObject(self, @"sharedScroller");


}


//添加的方法
- (void)chooseSharedFunctionWithWebUrl:(NSURL *)url{

    self.url = url;
    NSArray *shareIcon = @[@"share_logo_weixin",@"share_logo_weixinFriends"];
    self.sharedScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(self.bounds.size.width-60, 150, 60, 140)];
    self.sharedScroller.backgroundColor = [UIColor lightGrayColor];
    self.sharedScroller.tag = 100;
    
    for (int i = 0; i < shareIcon.count; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SPACE_LEFT_RIGHT, SPACE_UP_DOWN + i * (ICON_WIDE_HEOGH+SPACE_UP_DOWN), ICON_WIDE_HEOGH, ICON_WIDE_HEOGH)];
        button.tag = i;
        
        [button setBackgroundImage:[UIImage imageNamed:shareIcon[i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(tapShareIcon:) forControlEvents:UIControlEventTouchDragInside];
        [self.sharedScroller addSubview:button];
        
    }
    
    self.sharedScroller.contentSize = CGSizeMake(60, (shareIcon.count+1)*SPACE_UP_DOWN + shareIcon.count*ICON_WIDE_HEOGH);
    self.sharedScroller.showsHorizontalScrollIndicator = NO;
    
    self.sharedScroller.showsVerticalScrollIndicator = NO;
    
    
    

    
    
    [self addSubview:self.sharedScroller];

}

- (void)tapShareIcon:(UIButton *)sender {
    
    NSLog(@"%ld",(long)sender.tag);
    
    //创建单例
 MarkSharedTool *shareTool = [MarkSharedTool sharedTool];
    
    switch (sender.tag) {
        case 0:
            [shareTool sharedtoWXfriendsWithUrl:self.url];
            NSLog(@"tag=0:%@",self.url);
            break;
            
        case 1:
            [shareTool sharedToWeiChatWithWebUrl:self.url];
            NSLog(@"tag=1:%@",self.url);
            break;
            
    }
    
    [self dismiss];
    
}





- (void)dismiss{


    [self.sharedScroller removeFromSuperview];


}



@end
