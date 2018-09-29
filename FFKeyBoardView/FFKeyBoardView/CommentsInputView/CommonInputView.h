//
//  CommonInputView.h
//  JinGuFinance
//
//  Created by IOS开发 on 2018/4/13.
//  Copyright © 2018年 JinGuCaiJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <SZTextView.h>

///输入框视图

@interface CommonInputView : UIView<UITextViewDelegate>

@property (nonatomic,weak) UIViewController *targetVC;

@property (nonatomic,strong) SZTextView *textView;

@property (nonatomic,strong) UIButton *sendBtn;

@property (nonatomic,strong) UIButton *addBtn;

@property (nonatomic,copy) void (^inputBtnActionBlock) (CommonInputView *aView,SZTextView *textV,NSInteger tag);

@property (nonatomic,copy) void (^textViewDidChangedBlock) (SZTextView *textV);


@end
