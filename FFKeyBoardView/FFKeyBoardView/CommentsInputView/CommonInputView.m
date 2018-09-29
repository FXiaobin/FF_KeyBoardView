//
//  CommonInputView.m
//  JinGuFinance
//
//  Created by IOS开发 on 2018/4/13.
//  Copyright © 2018年 JinGuCaiJing. All rights reserved.
//

#import "CommonInputView.h"

#define kHexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CommonInputView

-(void)dealloc{
    //[self removeObserverForKeyboardNotifications];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kHexColor(0xf9f9f9);
        
        [self addSubview:self.textView];
        [self addSubview:self.addBtn];
        [self addSubview:self.sendBtn];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 10, 5, 100));
        }];
        
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-5);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.addBtn.mas_left).offset(-5);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
 
    }
    return self;
}


#pragma mark - <UITextViewDelegate>

-(void)textViewDidChange:(UITextView *)textView{
    //750 - 100 - 30 = 620
    
    CGFloat height = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - 100 - 10, 80)].height;
    if (height < 40) {
        height = 40;
    }else if (height > 80){
        height = 80;
    }
    
    ///总高度是kSCALE(100)
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height+10.0);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    if (self.textViewDidChangedBlock) {
        self.textViewDidChangedBlock(self.textView);
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        if (self.textView.text.length == 0) {
            NSLog(@"------ 请输入评论内容 -----");
            return NO;
        }
        
        if (self.inputBtnActionBlock) {
            ///在发送消息成功后需要重新置为YES
            self.sendBtn.userInteractionEnabled = NO;
            self.inputBtnActionBlock(self, self.textView, 0);
        }
        return NO;
    }
    return YES;
}

#pragma mark - <Button Click>
- (void)inputBtnAction:(UIButton *)sender{
    
    NSInteger index = sender.tag - 30000;
    
    if (index == 0) {
        
        if (self.textView.text.length == 0) {
            NSLog(@"------ 请输入评论内容 -----");
            return ;
        }
    }
  
    if (self.inputBtnActionBlock) {
        if (index == 0) {   ///在发送消息成功后需要重新置为YES
            self.sendBtn.userInteractionEnabled = NO;
        }
        self.inputBtnActionBlock(self, self.textView, index);
    
    }
}

#pragma mark - <Lazy>

-(SZTextView *)textView{
    if (_textView == nil) {
        _textView = [[SZTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderColor = kHexColor(0xe5e5e5).CGColor;
        _textView.layer.borderWidth = 0.5;
        ///添加图片
//        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//        textAttachment.image = [UIImage imageNamed:@"comment"];
//        textAttachment.bounds = CGRectMake(0, 0, kSCALE(44), kSCALE(32));
//
//        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@" 我想说两句..." attributes:@{NSForegroundColorAttributeName : kSubTitleColor, NSFontAttributeName : kFont(kSCALE(28))}];
//        [str insertAttributedString:attrStringWithImage atIndex:0];
        
        _textView.placeholder = @"我想说两句...";
        _textView.placeholderTextColor = kHexColor(0x888888);
    }
    return _textView;
}

-(UIButton *)sendBtn{
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"😁" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(inputBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.tag = 30002;
    }
    return _sendBtn;
}

-(UIButton *)addBtn{
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(inputBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 30001;
    }
    return _addBtn;
}


@end
