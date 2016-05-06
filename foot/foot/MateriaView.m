//
//  MateriaView.m
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MateriaView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@implementation MateriaView

-(instancetype)initWithFrame:(CGRect)frame materia:(NSString *)materia dosage:(NSString *)dosage
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *materiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, SCREEN_W /2 - 30, 20)];
        [self addSubview:materiaLabel];
        materiaLabel.text = materia;
        materiaLabel.font = [UIFont systemFontOfSize:16];
        
        UILabel *dosageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W / 2, 5, SCREEN_W /2 - 30, 20)];
        dosageLabel.textColor = [UIColor grayColor];
        dosageLabel.text = dosage;
        dosageLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:dosageLabel];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
