//
//  DianpingApi.h
//  SerlizerURL
//
//  Created by ivan liu on 15-3-28.
//  Copyright (c) 2015年 ivan liu. All rights reserved.
//
//C语言里typedef的解释是用来声明新的类型名来代替已有的类姓名
typedef void (^MyCallback)(id obj);//block 的回调
#import <Foundation/Foundation.h>

@interface DianpingApi : NSObject

+(void)requestBusinessAndCallback:(MyCallback)callback;

//带参数请求
+(void)requestBusinessWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback;


//获取团购的信息
+(void)requestDealsWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback;


@end
