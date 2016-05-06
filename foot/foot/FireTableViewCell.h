//
//  FireTableViewCell.h
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FireTableViewCellDelegate <NSObject>

-(void)toucheBuutonWith:(UIButton *)but;

@end

@interface FireTableViewCell : UITableViewCell
@property (nonatomic,weak)id<FireTableViewCellDelegate>delegate;
@end
