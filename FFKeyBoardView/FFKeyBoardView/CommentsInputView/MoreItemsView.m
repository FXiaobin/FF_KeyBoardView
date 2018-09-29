//
//  MoreItemsView.m
//  FFKeyBoardView
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018 healifeGroup. All rights reserved.
//

#import "MoreItemsView.h"

#define kHexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MoreItemsView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = kHexColor(0xe5e5e5);
        
        NSArray *titles = @[@"图片",@"拍照",@"位置",@"文件",@"收藏",@"个人名片",@"红包"];
        NSArray *images = @[@"my_01",@"my_02",@"my_03",@"my_04",@"my_05",@"my_06",@"my_07"];
        
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) / 4.0;
        for (int i = 0; i < titles.count; i++) {
            
            NSInteger row = i / 4, cloumn = i % 4;
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(cloumn * width, row * 80.0, width, 80.0);
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //使图片和文字水平居中显示
            [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height+10 ,-button.imageView.frame.size.width, 0.0,0.0)];
            //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
            [button setImageEdgeInsets:UIEdgeInsetsMake(-button.imageView.frame.size.height / 2.0 - 10, 0.0,0.0, -button.titleLabel.bounds.size.width)];
            //图片距离右边框距离减少图片的宽度，其它不边
           
            
            
            button.tag = 10000 + i;
            [self addSubview:button];
        }
        
        
    }
    
    return self;
}

-(void)buttonClick:(UIButton *)sender{
    NSInteger tag = sender.tag - 10000;
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(tag);
    }
}

@end
