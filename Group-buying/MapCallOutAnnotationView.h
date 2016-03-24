//
//  MapCallOutAnnotationView.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/28.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BusinessInfo.h"
@interface MapCallOutAnnotationView : MKAnnotationView


@property (nonatomic,copy) NSString *urlString;

@property (nonatomic,strong)BusinessInfo*business;
@end
