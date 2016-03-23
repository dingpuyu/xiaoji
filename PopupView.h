//
//  PopupView.h
//  MSCDemo
//
//  Created by iflytek on 13-6-7.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIView*  ParentView;
@property (nonatomic,assign) int queueCount;


/**
 初始popUpView
 ****/
- (id)initWithFrame:(CGRect)frame withParentView:(UIView*)view;


/**
 直接调用下面接口可以显示
 ****/
- (void)showText:(NSString *)text;


/**
 请不要使用下面接口
 ****/
- (void)setText:(NSString *) text;//deprecated..

@end
