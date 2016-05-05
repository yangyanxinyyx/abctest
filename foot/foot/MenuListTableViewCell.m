//
//  MenuListTableViewCell.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MenuListTableViewCell.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@implementation MenuListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        
        self.collectLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_collectLabel];
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    self.imageV.frame = CGRectMake(10, 10, 100, 90);
    
    self.nameLabel.frame = CGRectMake(120, 12, SCREEN_W - 120 -10, 25);
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    
    self.titleLabel.frame = CGRectMake(120, 36, SCREEN_W -120 - 10, 45);
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 2;
    
    self.collectLabel.frame = CGRectMake(SCREEN_W - 90, 83, 100, 20);
    self.collectLabel.font = [UIFont systemFontOfSize:14];
    self.collectLabel.textColor = [UIColor grayColor];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
