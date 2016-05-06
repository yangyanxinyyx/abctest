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
        
        self.viewBack = [[UIView alloc] init];
        [self.contentView addSubview:self.viewBack];
        
        self.imageSelect = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageSelect];
        
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageV.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    self.imageV.layer.cornerRadius = self.contentView.frame.size.width/2;
    self.imageV.layer.masksToBounds = YES;

 
    self.viewBack.frame = self.contentView.frame;
    self.viewBack.layer.cornerRadius = self.contentView.frame.size.width/2;
    self.viewBack.layer.masksToBounds = YES;
    
    self.imageSelect.frame = CGRectMake(0, 0, self.contentView.frame.size.width*0.3, self.contentView.frame.size.height*0.3);
    self.imageSelect.center = self.contentView.center;

 
    self.labelName.textAlignment = NSTextAlignmentCenter;
    self.labelName.font = [UIFont systemFontOfSize:17];
    self.labelName.textColor = [UIColor whiteColor];
    self.labelName.alpha = 0.7;
    self.labelName.backgroundColor = [UIColor blackColor];
    self.labelName.layer.cornerRadius = 5;
    self.labelName.layer.masksToBounds = YES;
    
    
    
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UIImageView *image = [[UIImageView alloc] initWithFrame:self.contentView.frame];
//    image.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:image];
//}
@end
