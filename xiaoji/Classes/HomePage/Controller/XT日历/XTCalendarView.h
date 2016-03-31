//
//  XTCalendarView.h
//  CalendarTest
//
//  Created by xiaotei's on 15/11/13.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

typedef void(^XTCalendarViewEventCallBack)(NSDate* date);

@interface XTCalendarView : UIView

//水平日历
@property (nonatomic,weak)JTHorizontalCalendarView* horizontalCalendarView;
//顶部视图
@property (nonatomic,weak)JTCalendarMenuView* menuView;




@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (nonatomic,copy)XTCalendarViewEventCallBack callBack;

- (instancetype)initWithEventCallBack:(XTCalendarViewEventCallBack)callBack;


@property (nonatomic,weak)NSDate* selectedDate;


@property (nonatomic,weak)NSDate* minDate;

@property (nonatomic,strong)NSDate *todayDate;
@property (nonatomic,strong)NSDate *maxDate;


@end
