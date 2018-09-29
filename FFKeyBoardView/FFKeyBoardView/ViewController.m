//
//  ViewController.m
//  FFKeyBoardView
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018 healifeGroup. All rights reserved.
//

#import "ViewController.h"
#import "CommentsInputView/CommonInputView.h"
#import "MoreItemsView.h"
#import "EmojBoardView.h"

#import <Masonry.h>

#define kIsPhoneX   [UIApplication sharedApplication].statusBarFrame.size.height > 20.0 ? YES : NO

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) CommonInputView *commentInputView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) MoreItemsView *moreItemView;

@property (nonatomic,strong) EmojBoardView *emojView;

///选项面板是否打开
@property (nonatomic,assign) BOOL isOpen;

///表情面板是否打开
@property (nonatomic,assign) BOOL isEmojOpen;


@end

@implementation ViewController

-(void)dealloc{
    [self removeObserverForKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
        调整模拟器键盘后再测试
     */
    
    [self registerForKeyboardNotifications];

    ///聊天列表
    [self.view addSubview:self.tableView];
    
    ///选项面板
    self.moreItemView = [[MoreItemsView alloc] init];
    self.moreItemView.hidden = YES;
    [self.view addSubview:self.moreItemView];
    
    ///表情面板
    self.emojView = [[EmojBoardView alloc] init];
    self.emojView.hidden = YES;
    self.emojView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.emojView];
    
    ///输入框面板
    self.commentInputView = [[CommonInputView alloc] initWithFrame:CGRectZero];
    self.commentInputView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.commentInputView];
    
    ///点击事件处理
    [self commentInputAction];
    
    CGFloat height = 160.0;
    CGFloat bottomH = 0.0;
    
    BOOL ret = kIsPhoneX;
    if (ret) {
        height = 194.0;
        bottomH = 34.0;
    }
    
    [self.commentInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottomH);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.moreItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentInputView);
        make.right.equalTo(self.commentInputView.mas_right);
        make.top.equalTo(self.commentInputView.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    
    [self.emojView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentInputView);
        make.right.equalTo(self.commentInputView.mas_right);
        make.top.equalTo(self.commentInputView.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.commentInputView.mas_top);
    }];

}

#pragma mark - Action

- (void)commentInputAction{
    
    self.moreItemView.buttonClickBlock = ^(NSInteger index) {
        NSLog(@"----- index = %ld ---",index);
        switch (index) {
            case 0: {
                
            } break;
            case 1: {
                
            } break;
                
            default:
                break;
        }
    };
    
    CGFloat height = 160.0;
    BOOL ret = kIsPhoneX;
    if (ret) {
        height = 194.0;
    }
    
    __weak typeof(self) weakSelf = self;
    self.commentInputView.textViewDidChangedBlock = ^(SZTextView *textV) {
        if (weakSelf.dataArr.count > 0) {
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    };
    
    self.commentInputView.inputBtnActionBlock = ^(CommonInputView *aView, SZTextView *textV, NSInteger tag) {
        
        if (tag == 0) { //发送
            
            [aView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50.0);
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.view layoutIfNeeded];
            }];
            
            [weakSelf.dataArr addObject:textV.text];
            [weakSelf.tableView reloadData];
            ///这个滚动要放到UI更新之后再做
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            textV.text = nil;
            [aView.sendBtn setUserInteractionEnabled:YES];
            
        }else if (tag == 1){    // + 选项面板
            weakSelf.moreItemView.hidden = NO;
            weakSelf.emojView.hidden = YES;
            
            if (weakSelf.isEmojOpen) {
                weakSelf.isOpen = NO;
                weakSelf.isEmojOpen = NO;
            }
            
            weakSelf.isOpen = !weakSelf.isOpen;
            if (weakSelf.isOpen) {
                [textV resignFirstResponder];
                [aView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-height);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];
                
                ///这个滚动一定要放到上面这个动画执行完成后再做
                if (weakSelf.dataArr.count > 0) {
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                
            }else{
                [textV becomeFirstResponder];
            }
            
        }else if (tag == 2){    // 😁 表情面板
            weakSelf.moreItemView.hidden = YES;
            weakSelf.emojView.hidden = NO;
            
            if (weakSelf.isOpen) {
                weakSelf.isEmojOpen = NO;
                weakSelf.isOpen = NO;
            }
            
            weakSelf.isEmojOpen = !weakSelf.isEmojOpen;
            if (weakSelf.isEmojOpen) {
                [textV resignFirstResponder];
                [aView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-height);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];
                
                ///这个滚动一定要放到上面这个动画执行完成后再做
                if (weakSelf.dataArr.count > 0) {
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                
            }else{
                [textV becomeFirstResponder];
            }
            
        }
    };
}

-(void)hiddenInputView{
    self.isOpen = NO;
    self.isEmojOpen = NO;
    
    self.moreItemView.hidden = YES;
    self.emojView.hidden = YES;
    
    [self.commentInputView.textView resignFirstResponder];
    
    CGFloat height = 0.0;
    BOOL ret = kIsPhoneX;
    if (ret) {
        height = 34.0;
    }
    
    [self.commentInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-height);
        make.height.mas_equalTo(50.0);
    }];

    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hiddenInputView];
}

#pragma mark - UIKeyboard 评论框弹出和下落

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObserverForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 弹出键盘
- (void)keyboardWillShown:(NSNotification *)notification{
    self.isOpen = NO;
    self.isEmojOpen = NO;
    
    self.moreItemView.hidden = YES;
    self.emojView.hidden = YES;
    
    NSDictionary *dict = [notification userInfo];
    CGSize kbSize = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat keyboardHeight = kbSize.height;
    [self.commentInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-keyboardHeight);
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentInputView.mas_top);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    if (self.dataArr.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
// 隐藏键盘
- (void)keyboardWillBeHidden:(NSNotification *)notification{
    if (self.isOpen || self.isEmojOpen) {
        return;
    }
    
    CGFloat height = 0.0;
    BOOL ret = kIsPhoneX;
    if (ret) {
        height = 34.0;
    }
    
    [self.commentInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-height);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentInputView.mas_top);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    if (self.dataArr.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Lazy

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0.0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
