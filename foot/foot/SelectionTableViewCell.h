//
//  SelectionTableViewCell.h
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionFoodModel.h"
@interface SelectionTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *selectImageView;
@property (nonatomic,strong)UILabel *labelName;
@property (nonatomic,strong)UILabel *labelBrowse;
@property (nonatomic,strong)UILabel *labelCollect;
@property (nonatomic,strong)SelectionFoodModel *selectionFM;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;
@end
