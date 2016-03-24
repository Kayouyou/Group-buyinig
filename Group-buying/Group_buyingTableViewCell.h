//
//  Group_buyingTableViewCell.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/21.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group-buying.h"
#import "BusinessInfo.h"



@interface Group_buyingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *s_image;

@property (weak, nonatomic) IBOutlet UILabel *deal_descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (nonatomic,strong) Group_buying *deal;

@property (nonatomic,strong) BusinessInfo *business;












@end
