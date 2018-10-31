//
//  keyBoard.h
//  keyBoard
//
//  Created by 王洋 on 2018/10/24.
//  Copyright © 2018年 王洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface keyBoard :UIView
//是否接受通知
@property(nonatomic,assign)BOOL isAcceptNoti;
@property(copy,nonatomic)void(^KeyBoardBlock)(NSString *CodeStr);
@property(strong,nonatomic)UITextField *handleTextFiled;
@end
