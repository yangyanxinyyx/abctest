//
//  MixFoodCollectionViewCell.m
//  食材组合
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 yangyanxin. All rights reserved.
//

#import "MixFoodCollectionViewCell.h"

@implementation MixFoodCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        
        self.labelName = [[UILabel alloc] init];
        [self.contentView addSubview:self.labelName];

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageV.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    self.imageV.layer.cornerRadius = self.contentView.frame.size.width/2;
    self.imageV.layer.masksToBounds = YES;

    

 
    self.labelName.textAlignment = NSTextAlignmentCenter;
    self.labelName.font = [UIFont systemFontOfSize:17];
    self.labelName.textColor = [UIColor whiteColor];
    self.labelName.alpha = 0.7;
    self.labelName.backgroundColor = [UIColor blackColor];
    self.labelName.layer.cornerRadius = 5;
    self.labelName.layer.masksToBounds = YES;
    
    
    
}
@end
