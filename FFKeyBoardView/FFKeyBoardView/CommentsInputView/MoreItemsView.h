//
//  MoreItemsView.h
//  FFKeyBoardView
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018 healifeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

////选项面板视图

NS_ASSUME_NONNULL_BEGIN

@interface MoreItemsView : UIView

@property (nonatomic,copy) void (^buttonClickBlock) (NSInteger index);

@end

NS_ASSUME_NONNULL_END
