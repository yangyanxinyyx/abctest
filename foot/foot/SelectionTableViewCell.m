//
//  SelectionTableViewCell.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "SelectionTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation SelectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(SelectionFoodModel *)model{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self addSubview:self.selectImageView];
        [self addSubview:self.labelName];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return  self;
    
    
}
#pragma MARK -懒加载
-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0,KScreenWidth-20, 190)];
        self.selectImageView.layer.cornerRadius = 10;
        self.selectImageView.layer.masksToBounds = YES;
    }
    return _selectImageView;
}
-(UILabel *)labelName{
    if (!_labelName) {
        self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-120, 160, 100, 20)];
        self.labelName.textColor = [UIColor whiteColor];
        
    }
    return _labelName;
}

@end
