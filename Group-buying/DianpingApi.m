//
//  DianpingApi.m
//  SerlizerURL
//
//  Created by ivan liu on 15-3-28.
//  Copyright (c) 2015年 ivan liu. All rights reserved.
//
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "DianpingApi.h"
#import "Group-buying.h"
#define kAPP_KEY @"4123794720"
#define kAPP_SECRET @"5a908d5484254cf4879bb47131bfd822"
#import "JsonParser.h"
@implementation DianpingApi

+(void)requestDealsWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback{

    //获取mapview 中具体城市的信息
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    
    NSMutableDictionary *allParams = [params mutableCopy];
    [allParams setObject:cityName forKey:@"city"];
 
//    NSMutableDictionary *allParams = [params mutableCopy];
//    
//    [allParams setObject:@"北京" forKey:@"city"];
    NSString *path = @"http://api.dianping.com/v1/deal/find_deals";
    path = [DianpingApi serializeURL:path params:allParams];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
//    NSString *str = @"1234";
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        //根据解析的数据来解析团购信息
        NSArray *deals = [JsonParser parseDealsByDic:dic];
        
        NSLog(@"--%@",deals);
        //调用callback 块对象   返回deals 
        callback(deals);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
    }];
    
    [operation start];


}

+(void)requestBusinessWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback{

    //发送请求的城市信息
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    
    NSMutableDictionary *allParams = [params mutableCopy];
    
    [allParams setObject:cityName forKey:@"city"];
    NSString *path = @"http://api.dianping.com/v1/business/find_businesses";
    path = [DianpingApi serializeURL:path params:allParams];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    
    NSArray *businesses = [JsonParser parseBusinessByDic:dic];
    
    NSLog(@"-%@",businesses);
    callback(businesses);
    
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"请求失败");
}];

    [operation start];

}

//+(void)requestBusinessAndCallback:(MyCallback)callback{
//
//    NSString *path = @"http://api.dianping.com/v1/business/find_businesses";
//    path = [DianpingApi  serializeURL:path params:@{@"city":@"北京"}];
//    
//    NSLog(@"%@",path);
//    
//    NSURL *url = [NSURL URLWithString:path];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        
//        NSArray *businesses = [JsonParser parseBusinessByDic:dic];
//        NSLog(@"==============%@",businesses);
//        callback(businesses);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       
//        NSLog(@"请求失败");
//        
//        
//    }];
//
//
//
//    [operation start];
//
//}



+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *signString = [NSMutableString stringWithString:kAPP_KEY];
    NSMutableString *paramsString = [NSMutableString stringWithFormat:@"appkey=%@", kAPP_KEY];
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
        [paramsString appendFormat:@"&%@=%@", key, [paramsDic objectForKey:key]];
    }
    [signString appendString:kAPP_SECRET];
    unsigned char digest[20];
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:20];
        for (int i=0; i<20; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        [paramsString appendFormat:@"&sign=%@", [digestString uppercaseString]];
        return [NSString stringWithFormat:@"%@://%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        return nil;
    }
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


@end
