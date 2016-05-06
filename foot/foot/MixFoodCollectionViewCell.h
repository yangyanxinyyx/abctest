//
//  MixFoodCollectionViewCell.h
//  食材组合
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 yangyanxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixFoodModel.h"
#import "UIImageView+WebCache.h"

@interface MixFoodCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *labelName;
@property(nonatomic,strong)UIImageView *imageSelect;

@property(nonatomic,strong)MixFoodModel *mixFood;
@end
