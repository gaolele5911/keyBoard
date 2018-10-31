//
//  keyBoard.m
//  keyBoard
//
//  Created by 王洋 on 2018/10/24.
//  Copyright © 2018年 王洋. All rights reserved.
//

#import "keyBoard.h"

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface keyBoard()
{
    UIButton *_lastNumBtn;
}

@end
@implementation keyBoard
-(instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, KScreenHeight, KScreenWidth, 260);

    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    
    return self;
}


-(void)setUpUI {
    self.tag = 1001;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 260)];
    backView.backgroundColor = [UIColor orangeColor];
    [self addSubview:backView];
    
    
    NSString *ZMStr = @"1 2 3 4 5 6 7 8 9 0 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
    NSArray *ZMArray = [ZMStr componentsSeparatedByString:@" "];
    for (int i = 0; i < ZMArray.count; i++) {
        UIButton *numBtn = [[UIButton alloc]init];
        numBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:numBtn];
        [numBtn setTitle:[NSString stringWithFormat:@"%@",ZMArray[i]] forState:UIControlStateNormal];
        [self addSubview:numBtn];
        
        CGFloat MarginX = 5;
        CGFloat MarginY = 10;
        CGFloat buttonW = (KScreenWidth - 11 * MarginX) / 10;
        CGFloat buttonY = (self.frame.size.height - 5 * MarginY) / 4;
        
        CGFloat row = 0;
        CGFloat line = 0;
        if (i < 29) {
            row = i % 10;
            line = i / 10;
        }else {
            row = i % 29;
            line = 3;
        }
        
        [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numBtn addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i < 20){
            numBtn.frame = CGRectMake(MarginX + (buttonW + MarginX) * row,MarginY + (buttonY + MarginY) * line,buttonW,buttonY);
        }else if(i >= 20 && i < 29){
            numBtn.frame = CGRectMake(MarginX + buttonW / 2 + (buttonW + MarginX) * row,MarginY + (buttonY + MarginY) * line,buttonW,buttonY);
        }else {
            numBtn.frame = CGRectMake(buttonW + 2 * MarginX + buttonW / 2 + (buttonW + MarginX) * row,MarginY + (buttonY + MarginY) * line,buttonW,buttonY);
        }
        _lastNumBtn = numBtn;
        numBtn.layer.cornerRadius = 5;
        [numBtn.layer masksToBounds];
    }
    
    CGFloat deleteBtnW = 40;
    CGFloat deleteBtnH = 40;
    UIButton *deleteBtn = [[UIButton alloc]init];
    deleteBtn.backgroundColor = [UIColor redColor];
    [self addSubview:deleteBtn];
    [deleteBtn setTitle:@"删" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.frame = CGRectMake(KScreenWidth - 40 - 5, _lastNumBtn.frame.origin.y + 10, deleteBtnW, deleteBtnH);
    deleteBtn.layer.cornerRadius = 5;
    [deleteBtn.layer masksToBounds];
    
}
-(void)setHandleTextFiled:(UITextField *)handleTextFiled {
    _handleTextFiled = handleTextFiled;
}

#pragma mark --相应键盘的通知事件
- (void)changeKeyBoard:(NSNotification *)notification{
    NSString *userInfo = notification.object;
    CGRect endFrame;

    
    if ([userInfo isEqualToString:@"YES"]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, KScreenHeight - 260, KScreenWidth, 260);
        }];
       endFrame = CGRectMake(0, KScreenHeight - 260, KScreenWidth, 260);
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 260);
        }];
        endFrame = CGRectMake(0, KScreenHeight, KScreenWidth, 260);
    }
    
    UIView *mainView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    CGFloat moveY = - (mainView.frame.size.height - endFrame.origin.y);

    CGAffineTransform transForm = mainView.transform;
    //移动
    transForm = CGAffineTransformMakeTranslation(0, moveY);
    
    //    执行动画移动
    [UIView animateWithDuration:0.2 animations:^{
        for (UIView *subView in mainView.subviews) {
            if (subView.tag != 1001) {
                subView.transform = transForm;
            }
        }
    }];
   
    
    
//    UIView *mainView = [[UIApplication sharedApplication] keyWindow];
//    if (![_handleTextFiled isEditing] && mainView.frame.origin.y >= 0) {
//        return;
//    }
    
    //获取userInfo信息
//    NSDictionary *userInfo = notification.userInfo;
    //获取要移动控件的transForm
    
    //获取移动的位置 屏幕的高度 - 最终显示的frame的Y = 移动的位置
    //1. 获取键盘最终显示的y
//    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
//
//    CGRect endFrame = [value CGRectValue];
//    if (_handleTextFiled.frame.origin.y + _handleTextFiled.frame.size.height < endFrame.origin.y && mainView.frame.origin.y >= 0) {
//        return;
//    }
    
    

    
    
}
-(void)setIsAcceptNoti:(BOOL)isAcceptNoti {
    _isAcceptNoti = isAcceptNoti;
    if (isAcceptNoti == YES) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:@"STARTEDITING" object:nil];
    }
}
-(void)numBtnAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"删"]) {
        [self.handleTextFiled deleteBackward];
    }else {
        [self.handleTextFiled insertText:btn.titleLabel.text];
    }
    
}
-(void)textFieldDone {
    [_handleTextFiled endEditing:YES];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
