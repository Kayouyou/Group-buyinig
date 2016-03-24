//
//  MapAnnotation.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/23.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessInfo.h"
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;



// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic,  copy) NSString *subtitle;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong)BusinessInfo *business;

// Called as a result of dragging an annotation view.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;


@end
