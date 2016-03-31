//
//  XTCalendarPageView.m
//  LastCalendar
//
//  Created by xiaotei's on 15/12/11.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "XTCalendarPageView.h"
#import "JTCalendarManager.h"
#import "JTCalendarWeekView.h"

#define MAX_WEEKS_BY_MONTH 6

@interface XTCalendarPageView (){
    NSMutableArray *_weeksViews;
    NSUInteger _numberOfWeeksDisplayed;
}

@end

@implementation XTCalendarPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    // Maybe used in future
}

- (void)setDate:(NSDate *)date
{
    NSAssert(_manager != nil, @"manager cannot be nil");
    NSAssert(date != nil, @"date cannot be nil");
    
    self->_date = date;
    
    [self reload];
}

- (void)reload
{
    if(!_weeksViews){
        _weeksViews = [NSMutableArray new];
        
        for(int i = 0; i < MAX_WEEKS_BY_MONTH; ++i){
            JTCalendarWeekView *weekView = (JTCalendarWeekView *)[_manager.delegateManager buildWeekView];
            weekView.drawLine = NO;
            [_weeksViews addObject:weekView];
            [self addSubview:weekView];
            
            weekView.manager = _manager;
        }
    }
    
    NSDate *weekDate = nil;
    
    if(_manager.settings.weekModeEnabled){
        _numberOfWeeksDisplayed = MIN(MAX(_manager.settings.pageViewWeekModeNumberOfWeeks, 1), MAX_WEEKS_BY_MONTH);
        weekDate = [_manager.dateHelper firstWeekDayOfWeek:_date];
    }
    else{
        _numberOfWeeksDisplayed = MIN(_manager.settings.pageViewNumberOfWeeks, MAX_WEEKS_BY_MONTH);
        if(_numberOfWeeksDisplayed == 0){
            _numberOfWeeksDisplayed = [_manager.dateHelper numberOfWeeks:_date];
        }
        
        weekDate = [_manager.dateHelper firstWeekDayOfMonth:_date];
    }
    
    for(NSUInteger i = 0; i < _numberOfWeeksDisplayed; i++){
        UIView<JTCalendarWeek> *weekView = _weeksViews[i];
        
        weekView.hidden = NO;
        
        // Process the check on another month for the 1st, 4th and 5th weeks
        if(i == 0 || i >= 4){
            [weekView setStartDate:weekDate updateAnotherMonth:YES monthDate:_date];
        }
        else{
            [weekView setStartDate:weekDate updateAnotherMonth:NO monthDate:_date];
        }
        
        weekDate = [_manager.dateHelper addToDate:weekDate weeks:1];
    }
    
    for(NSUInteger i = _numberOfWeeksDisplayed; i < MAX_WEEKS_BY_MONTH; i++){
        UIView<JTCalendarWeek> *weekView = _weeksViews[i];
        
        weekView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    if(!_weeksViews){
        return;
    }
    
    CGFloat y = 0;
    CGFloat weekWidth = self.frame.size.width;
    
    CGFloat weekHeight = (self.frame.size.height - y) / _numberOfWeeksDisplayed;
    
    for(UIView *weekView in _weeksViews){
        weekView.frame = CGRectMake(0, y, weekWidth, weekHeight);
        y += weekHeight;
    }
}


- (NSUInteger)weekIndexWithDate:(NSDate *)date{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    NSDate* startDate = [_manager.dateHelper firstWeekDayOfWeek:date];
    
    for (int i = 0; i < _weeksViews.count; i++) {
        UIView<JTCalendarWeek>* weekView = _weeksViews[i];
        
//        BOOL equal =  [_manager.dateHelper.calendar isDate:weekView.startDate inSameDayAsDate:startDate];
        BOOL equal =  [_manager.dateHelper date:weekView.startDate isTheSameDayThan:startDate];
        if (equal) {
            return i;
        }
    }
    return -1;
}
@end

