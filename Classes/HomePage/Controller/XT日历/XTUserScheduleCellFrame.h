//
//  XTUserScheduleCellFrame.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/7.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemindResult.h"

@interface XTUserScheduleCellFrame : NSObject

/**
 *  提醒记录模型
 */
@property (nonatomic,strong)RemindResult* remindResult;

//提醒内容frame
@property (nonatomic,assign)Rect contentFrame;

/**
 *  时间标签frame
 */
@property (nonatomic,assign)Rect timeLabelFrame;

@property (nonatomic,assign)Rect nameFrame;

@property (nonatomic,assign)Rect phoneFrame;

/**
 *  跟进
 */
@property (nonatomic,assign)Rect trackBtnFrame;

@property (nonatomic,assign)Rect telBtnFrame;

/**
 *  最高高度
 */
@property (nonatomic,assign)float contentMaxHeight;

/**
 *  用户信息
 */
@property (nonatomic,assign)float infoMaxHeight;


- (instancetype)initWithRemindResult:(RemindResult*)result;

@end
