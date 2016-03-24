//
//  JsonParser.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/20.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject
//定义一个类方法 解析商户信息
+(NSArray *)parseBusinessByDic:(NSDictionary *)dic;


//解析团购信息
+(NSArray *)parseDealsByDic:(NSDictionary *)dic;

@end
