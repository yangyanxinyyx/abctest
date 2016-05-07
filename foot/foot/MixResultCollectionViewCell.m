//
//  MixResultCollectionViewCell.m
//  foot
//
//  Created by lanou on 16/5/7.
//  Copyright © 2016年 念恩. All rights reserved.
//

#define Cell_W self.contentView.frame.size.width
#define Cell_H self.contentView.frame.size.height

#import "MixResultCollectionViewCell.h"

@implementation MixResultCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        
        self.labelText = [[UILabel alloc] init];
        [self.contentView addSubview:self.labelText];
        
        self.labelHard = [[UILabel alloc] init];
        [self.contentView addSubview:self.labelHard];
        
        self.labelTime = [[UILabel alloc] init];
        [self.contentView addSubview:self.labelTime];
        
        self.imageVHat = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageVHat];
        
        self.imageVTime = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageVTime];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageV.frame = CGRectMake(0, 0, Cell_W, Cell_W);
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.clipsToBounds = YES;
    
    self.labelText.frame = CGRectMake(0, Cell_W, Cell_W, (Cell_H-Cell_W)/2);
    self.labelText.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width*19/414];
    self.labelText.textAlignment = NSTextAlignmentCenter;
    
    self.imageVHat.frame = CGRectMake(0, Cell_W+(Cell_H-Cell_W)/2, Cell_W/5, (Cell_H-Cell_W)/2);
    self.imageVHat.image = [UIImage imageNamed:@"厨师帽16"];
    self.imageVHat.contentMode = UIViewContentModeCenter;
    
    self.labelHard.frame = CGRectMake(Cell_W/5,Cell_W+(Cell_H-Cell_W)/2, Cell_W/5, (Cell_H-Cell_W)/2);
    self.labelHard.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width*17/414];
    self.labelHard.textAlignment = NSTextAlignmentCenter;
    
    self.imageVTime.frame = CGRectMake(Cell_W/5*2, Cell_W+(Cell_H-Cell_W)/2, Cell_W/5, (Cell_H-Cell_W)/2);
    self.imageVTime.image = [UIImage imageNamed:@"表16"];
    self.imageVTime.contentMode = UIViewContentModeRight;
    
    self.labelTime.frame = CGRectMake(Cell_W/5*3, Cell_W+(Cell_H-Cell_W)/2, Cell_W/5*2, (Cell_H-Cell_W)/2);
    self.labelTime.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width*17/414];
    self.labelTime.textAlignment = NSTextAlignmentCenter;
    
}

@end
