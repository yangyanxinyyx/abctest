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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
        [self addSubview:viewBack];
        [viewBack addSubview:self.selectImageView];
        [viewBack addSubview:self.labelName];
        [viewBack addSubview:self.labelBrowse];
        [viewBack addSubview:self.labelCollect];
        UIView *viewGray = [[UIView alloc]initWithFrame:CGRectMake(0, 300-10, KScreenWidth, 10)];
        viewGray.backgroundColor = [UIColor lightGrayColor];
        [viewBack addSubview:viewGray];
    }
    return  self;
    
    
}
#pragma MARK -懒加载
-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10,KScreenWidth-20, 220)];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
        _selectImageView.clipsToBounds = NO;
        self.selectImageView.layer.cornerRadius = 10;
        self.selectImageView.layer.masksToBounds = YES;
    }
    return _selectImageView;
}
-(UILabel *)labelName{
    if (!_labelName) {
        self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(20, 235, KScreenWidth-100, 20)];
        self.labelName.textColor = [UIColor blackColor];
        
    }
    return _labelName;
}
//浏览
-(UILabel *)labelBrowse{
    if (!_labelBrowse) {
        self.labelBrowse = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-180, 260, 100, 20)];
        _labelBrowse.textColor = [UIColor blackColor];
        _labelBrowse.font = [UIFont systemFontOfSize:12];
    }
    return _labelBrowse;
}
//收藏
-(UILabel *)labelCollect{
    
    if (!_labelCollect) {
        self.labelCollect = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-120, 260, 80, 20)];
        _labelCollect.textColor = [UIColor blackColor];
        _labelCollect.font = [UIFont systemFontOfSize:12];
    }
    return _labelCollect;
}
@end
