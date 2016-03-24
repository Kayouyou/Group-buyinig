//
//  MapCallOutAnnotationViewCell.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/28.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCallOutAnnotationViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@property (nonatomic,copy) NSString *urlString;



@end
