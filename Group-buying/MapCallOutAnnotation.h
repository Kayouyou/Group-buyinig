//
//  MapCallOutAnnotation.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/28.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import "BusinessInfo.h"
@interface MapCallOutAnnotation : NSObject<MKAnnotation>



@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@property (nonatomic,strong)BusinessInfo *business;

@property (nonatomic,copy) NSString *urlString;

@end
