//
//  VideoTableViewCell.h
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *ImageView;
@property (nonatomic,strong)UILabel *labelName;
@property (nonatomic,strong)UILabel *labelBrowse_Collerc;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;
@end
