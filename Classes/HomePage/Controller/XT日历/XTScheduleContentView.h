//
//  XTScheduleContentView.h
//  LastCalendar
//
//  Created by xiaotei's on 15/12/14.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XTScheduleListResultModel.h"
#import "XTUserScheduleInfoCell.h"
#import <UIKit/UIKit.h>

@class XTScheduleInfoTableView;

typedef void(^XTScheduleContentViewEventCallBack)(UITableView* tableView,CGPoint contentOffset);

typedef void(^XTScheduleContentViewDraggingEvent)(NSUInteger tag);

typedef void(^XTScheduleDeleteResult)(NSInteger remindID);

typedef void(^XTSchdueldCustomerEvent)(XTUserScheduleInfoCellEvent event,RemindResult* customer);



@interface XTScheduleContentView : UIView

@property (nonatomic,assign)BOOL scrollEnable;

@property (nonatomic,weak)XTScheduleInfoTableView* tableView;

@property (nonatomic,copy)XTScheduleContentViewEventCallBack callBack;

@property (nonatomic,copy)XTScheduleDeleteResult deleteCallBack;

@property (nonatomic,copy)XTScheduleContentViewDraggingEvent draggingEvent;

@property (nonatomic,copy)XTSchdueldCustomerEvent customerCallBack;

- (void)setContentOffsetZero;

@property (nonatomic,assign)NSUInteger startY;

//@property (nonatomic,strong)XTScheduleListResultModel* resultModel;

@property (nonatomic,weak)NSDateFormatter* inputFormatter;

@property (nonatomic,weak)NSDateFormatter* hourFormatter;

@end
