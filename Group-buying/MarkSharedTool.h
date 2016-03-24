//
//  MarkSharedTool.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/6/1.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkSharedTool : NSObject

//单例的工厂方法 
+(MarkSharedTool *)sharedTool;

//分享到微信朋友圈
- (void)sharedToWeiChatWithWebUrl:(NSURL *)url;

//分享给微信朋友

- (void)sharedtoWXfriendsWithUrl:(NSURL *)url;




@end
