//
//  XTUserScheduleCellFrame.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/7.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTUserScheduleCellFrame.h"
#import "NSString+Extension.h"
#import <UIKit/UIKit.h>
@implementation XTUserScheduleCellFrame

- (void)setRemindResult:(RemindResult *)remindResult{
    _remindResult = remindResult;
    
//    CGSize timeLabelSize = [NSString sizeWithString:remindResult.datetime font:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(CGFLOAT_MAX, 9)];
//    _timeLabelFrame = CGRectMake(16, 14, timeLabelSize.width, 9);
//
//    CGSize contentSize = [NSString sizeWithString:remindResult.content font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kMainScreenWidth - 32 , MAXFLOAT)];
//    
//    _contentFrame = CGRectMake(16, CGRectGetMaxY(_timeLabelFrame) + 12, kMainScreenWidth - 32, contentSize.height);
//    
//    _contentMaxHeight = CGRectGetMaxY(_contentFrame) + 14.0f;
//    
//    
//    CGSize nameLabelSize = [NSString sizeWithString:remindResult.name font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 16)];
//    
//    _nameFrame = CGRectMake(16, 15, nameLabelSize.width, 16);
//    
//    CGSize phoneLabelSize = [NSString sizeWithString:remindResult.phone font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(MAXFLOAT, 10)];
//    
//    _phoneFrame = CGRectMake(16, CGRectGetMaxY(_nameFrame) + 11, phoneLabelSize.width, 10);
//    
//
//    _trackBtnFrame = CGRectMake(kMainScreenWidth - 16 - 22 - 44, 20, 44, 30);
//    
//    _telBtnFrame = CGRectMake(kMainScreenWidth - 16 - 22, 20, 22, 30);
//    
//    
//    _infoMaxHeight = CGRectGetMaxY(_phoneFrame) + 14;
}


- (instancetype)initWithRemindResult:(RemindResult *)result{
    if (self = [super init]) {
        self.remindResult = result;
    }
    return self;
}

@end
