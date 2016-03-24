//
//  XTUserScheduleInfoCell.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/10.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUserScheduleCellFrame.h"

//cell事件
typedef NS_ENUM(NSInteger,XTUserScheduleInfoCellEvent) {
    XTUserScheduleInfoCellCallEvent,   //电话
    XTUserScheduleInfoCellAddFollow,   //添加跟进
    XTUserScheduleInfoCellAddSchedule,  //添加提醒
    XTUserScheduleInfoCellDetailInfo
};

@class XTUserScheduleInfoCell;

typedef void(^XTUserScheduleInfoCellCallBack)(XTUserScheduleInfoCell* infoCell,XTUserScheduleInfoCellEvent event);

@interface XTUserScheduleInfoCell : UITableViewCell

+ (instancetype)userScheduleInfoCellWithTableView:(UITableView*)tableView;

+ (instancetype)userScheduleInfoCellWithTableView:(UITableView *)tableView eventCallBack:(XTUserScheduleInfoCellCallBack)callBack;

- (void)hiddenCallBtn:(BOOL)hidden;

@property (nonatomic,copy)XTUserScheduleInfoCellCallBack callBack;

@property (nonatomic,strong)XTUserScheduleCellFrame* cellFrame;
@end
