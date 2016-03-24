//
//  JsonParser.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/20.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "JsonParser.h"
#import "BusinessInfo.h"
#import "Group-buying.h"
@implementation JsonParser

#pragma mark - 解析团购

+(NSArray *)parseDealsByDic:(NSDictionary *)dic{

    //声明一个可变数组，用来保存解析后的数据！！！为了不断增加数据，所以是可变的！
    NSMutableArray *dealsArr = [NSMutableArray new];
   
    
    NSArray *deals = [dic objectForKey:@"deals"];
    /*
     NSNull类定义了一个单例对象用于表示集合对象的空值
     
     　　>集合对象无法包含nil作为其具体值，如NSArray、NSSet和NSDictionary。相应地，nil值用一个特定的对象NSNull来表示。NSNull提供了一个单一实例用于表示对象属性中的的nil值。默认的实现方法中，dictionaryWithValuesForKeys:和setValuesForKeysWithDictionary:自动地将NSNull和nil相互转换，因此您的对象不需要进行NSNull的测试操作。
    在Objective-C里，nil对象被设计来跟NULL空指针关联的。他们的区别就是nil是一个对象，而NULL只是一个值。而且我们对于nil调用方法，不会产生crash或者抛出异常。
     
     sKindOfClass来确定一个对象是否是一个类的成员，或者是派生自该类的成员
     　　isMemberOfClass只能确定一个对象是否是当前类的成员
     　　例如：我们已经成NSObject派生了自己的类，isMemberOfClass不能检测任何的类都是基于NSObject类这一事实，而isKindOfClass可以。
     　　[[NSMutableData data] isKindOfClass:[NSData class]]; // YES
     [[NSMutableData data] isMemberOfClass:[NSData class]]; // NO
    */
    if ([deals isMemberOfClass:[NSNull class]]) {
        
        return [NSArray new];
        
    }

    for (NSDictionary *deal in deals) {
        
        Group_buying *tuan = [[Group_buying alloc]init];
        
        tuan.deal_id = [deal objectForKey:@"deal_id"];
        tuan.title = [deal objectForKey:@"title"];
        tuan.regions = [deal objectForKey:@"regions"];
        
        tuan.current_price =[NSString stringWithFormat:@"%.1f",[[deal objectForKey:@"current_price"] floatValue]];
        
        tuan.categories = [deal objectForKey:@"categories"];
        
        tuan.purchase_count = [[deal objectForKey:@"purchase_count"]integerValue];
        
        tuan.distance = [deal objectForKey:@"distance"];
        
        tuan.image_url = [deal objectForKey:@"image_url"];
        
        tuan.s_image_url = [deal objectForKey:@"s_image_url"];
        tuan.deal_h5_url = [deal objectForKey:@"deal_h5_url"];
        
        tuan.businesses = [deal objectForKey:@"businesses"];
        
        //获取所有团购商户的地理坐标
        for (NSDictionary *dic in tuan.businesses) {
            
            tuan.business_latitude = [dic objectForKey:@"latitude"];
            tuan.business_longitude = [dic objectForKey:@"longitude"];
            
        }
        tuan.rating_s_img_url = [dic objectForKey:@"rating_s_img_url"];
        
        
        
        [dealsArr addObject:tuan];
        
    }

    return dealsArr;

}



+(NSArray *)parseBusinessByDic:(NSDictionary *)dic{

    //声明一个可变数组 保存解析后的数据
    NSMutableArray * businesses = [NSMutableArray new];
    
    NSMutableArray *businessesDic = [dic objectForKey:@"businesses"];
    NSLog(@"%@",businessesDic);
    
    if ([businessesDic isMemberOfClass:[NSNull class]]) {
        
        return [NSArray new];
        
        
    }
    
    for (NSDictionary *businessDic in businessesDic) {
        
        BusinessInfo *business = [[BusinessInfo alloc] init];
        
        business.name = [businessDic objectForKey:@"name"];
        business.city = [businessDic objectForKey:@"city"];
        business.latitude = [[businessDic objectForKey:@"latitude"]floatValue];
        business.longitude = [[businessDic objectForKey:@"longitude"]floatValue];
        
        business.avg_rating = [[businessDic objectForKey:@"avg_rating"]floatValue];
        business.rating_img_url = [businessDic objectForKey:@"rating_img_url"];
        business.rating_s_img_url = [businessDic objectForKey:@"rating_s_img_url"];
        
        business.avg_price = [[businessDic objectForKey:@"avg_price"]integerValue];
        business.business_url = [businessDic objectForKey:@"business_url"];
        business.photo_url = [businessDic objectForKey:@"photo_url"];
        business.s_photo_url = [businessDic objectForKey:@"s_photo_url"];
        business.has_coupon = [[businessDic objectForKey:@"has_copon"]integerValue];
        business.coupon_description = [businessDic objectForKey:@"coupon_description"];
        business.has_deal = [[businessDic objectForKey:@"has_deal"]integerValue];
        business.deal_count = [[businessDic objectForKey:@"deal_count"]integerValue];
        business.deals = [businessDic objectForKey:@"deals"];
        business.has_online_reservation = [[businessDic objectForKey:@"has_online_reservation"]integerValue];
        
        business.online_reservation_url = [businessDic objectForKey:@"online_reservation_url"];
        
        
        [businesses addObject:business];
        
        
        
    }
    
    
    
    
    
    
    return businesses;





}
@end
