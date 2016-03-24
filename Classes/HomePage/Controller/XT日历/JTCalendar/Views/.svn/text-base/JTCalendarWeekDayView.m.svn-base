//
//  JTCalendarWeekDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarWeekDayView.h"

#import "JTCalendarManager.h"

#define NUMBER_OF_DAY_BY_WEEK 7.

@implementation JTCalendarWeekDayView

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
    NSMutableArray *dayViews = [NSMutableArray new];
    
    for(int i = 0; i < NUMBER_OF_DAY_BY_WEEK; ++i){
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [dayViews addObject:label];
        
        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
        label.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
    }
    self.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.89f alpha:1.00f];
    
    _dayViews = dayViews;
}

- (void)reload
{
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    NSDateFormatter *dateFormatter = [_manager.dateHelper createDateFormatter];
    NSArray *days = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    dateFormatter.timeZone = _manager.dateHelper.calendar.timeZone;
    dateFormatter.locale = _manager.dateHelper.calendar.locale;
    
    for(int i = 0; i < NUMBER_OF_DAY_BY_WEEK; ++i){
        UILabel *label =  _dayViews[i];
        
        
        label.text = days[i];
    }
}

- (void)layoutSubviews
{
    if(!_dayViews){
        return;
    }
    
    CGFloat x = 0;
    CGFloat dayWidth = self.frame.size.width / NUMBER_OF_DAY_BY_WEEK;
    CGFloat dayHeight = self.frame.size.height;
    
    for(UIView *dayView in _dayViews){
        dayView.frame = CGRectMake(x, 0.5, dayWidth + 1, dayHeight - 1);
        x += dayWidth;
    }
}

@end
