//
//  MenuCollectionViewCell.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MenuCollectionViewCell.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define CELL_SIZE CGSizeMake((SCREEN_W - 50)/4, (SCREEN_W - 50)/4)

@interface MenuCollectionViewCell ()

@end

@implementation MenuCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageV = [[UIImageView alloc] init];
        
        _imageV.layer.cornerRadius = 8;
        _imageV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageV];
        
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageV.frame = self.bounds;
    _nameLabel.frame = CGRectMake(0, CELL_SIZE.width - 25 , CELL_SIZE.height, 20);
    
}




@end
