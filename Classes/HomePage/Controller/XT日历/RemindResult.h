//
//  RemindResult.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//我的提醒

#import <Foundation/Foundation.h>

@interface RemindResult : NSObject

@property (nonatomic,copy)NSString* content;//提醒内容
@property (nonatomic,copy)NSString* phone;//客户电话
@property (nonatomic,copy)NSString* customerId;//客户id
@property (nonatomic,copy)NSString* name;//客户姓名
@property (nonatomic,assign)NSInteger remindId;//提醒id
@property (nonatomic,copy)NSString* datetime;

@end
