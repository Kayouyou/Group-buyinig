//
//  Group_buyingTableViewCell.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/21.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "Group_buyingTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation Group_buyingTableViewCell


-(void)layoutSubviews{

    [super layoutSubviews];
    self.currentPriceLabel.text = [self.deal.current_price stringByAppendingString:@"元"];
    if (self.deal.categories) {
        self.deal_descriptionLabel.text = [self.deal.categories firstObject];
        
    }

    self.reviewLabel.text = [@"已售" stringByAppendingString:[NSString stringWithFormat:@"%d",(int)self.deal.purchase_count]];
    
    self.distanceLabel.text = [[NSString stringWithFormat:@"%@",self.deal.distance] stringByAppendingString:@"米"];
    
    self.nameLabel.text = self.deal.title;

    //利用第三方框架  获取网络上面的图片
    [self.s_image setImageWithURL:[NSURL URLWithString:self.deal.s_image_url]];

    if ([self.deal.regions count]>0) {
        
        if ([self.deal.regions count] == 1) {
            
            self.regionLabel.text = [self.deal.regions objectAtIndex:0];
    
        }else{
            
        self.regionLabel.text = @"多商区";
        
        }
        
    }
    
    
    
    


}














































- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
