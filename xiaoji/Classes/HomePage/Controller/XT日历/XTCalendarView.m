//
//  XTCalendarView.m
//  CalendarTest
//
//  Created by xiaotei's on 15/11/13.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "XTCalendarView.h"

#define CalendarHeight 315

#define kMainScreenHeight self.frame.size.width

@interface XTCalendarView() <JTCalendarDelegate>
{
}
@property (nonatomic,strong)NSDateFormatter* formatter;

//选中数据数组
@property (nonatomic,strong)NSMutableArray* datesSelectedArray;

//加载下一页按钮
@property (nonatomic,weak)UIButton* loadNextPage;

//加载上一页按钮
@property (nonatomic,weak)UIButton* loadPrePage;

@property (nonatomic,weak)UIView* backgroundView;

@end

@implementation XTCalendarView

- (instancetype)initWithEventCallBack:(XTCalendarViewEventCallBack)callBack{
    if (self = [super init]) {
        [self backgroundView];
        self.backgroundColor = [UIColor clearColor];
        _callBack = callBack;
        
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self calendarManager];
    
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self backgroundView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self backgroundView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)didMoveToSuperview{
    [_calendarManager reload];
}


-(void)layoutSubviews{
    [super layoutSubviews];
//    (self.frame.size.height - CalendarHeight - 30)/2.0
       self.menuView.frame =  CGRectMake(0,kMainScreenHeight , self.frame.size.width, 50);
    self.horizontalCalendarView.frame = CGRectMake(0, CGRectGetMaxY(_menuView.frame), self.frame.size.width,CalendarHeight);
    
    self.loadPrePage.frame = CGRectMake(0, _menuView.frame.origin.y, _menuView.frame.size.height, _menuView.frame.size.height);
    self.loadNextPage.frame = CGRectMake(self.frame.size.width - _menuView.frame.size.height, _menuView.frame.origin.y, _menuView.frame.size.height,_menuView.frame.size.height);
    
    [UIView animateWithDuration:0.27 animations:^{
        self.menuView.frame =  CGRectMake(0,kMainScreenHeight - 50 - CalendarHeight, self.frame.size.width, 50);
        self.horizontalCalendarView.frame = CGRectMake(0, CGRectGetMaxY(_menuView.frame), self.frame.size.width,CalendarHeight);
        
        self.loadPrePage.frame = CGRectMake(0, _menuView.frame.origin.y, _menuView.frame.size.height, _menuView.frame.size.height);
        self.loadNextPage.frame = CGRectMake(self.frame.size.width - _menuView.frame.size.height, _menuView.frame.origin.y, _menuView.frame.size.height,_menuView.frame.size.height);
    }];
    

}



#pragma mark - calendar delegate
-(void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView{
//    NSLog(@"%@",[self.formatter stringFromDate:dayView.date]);
    dayView.circleView.alpha = 0.3;
    dayView.circleView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.2 animations:^{
        dayView.circleView.hidden = NO;
        dayView.circleView.alpha = 1.0f;
        dayView.circleView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (_callBack) {
            _callBack(dayView.date);
        }
    }];

//    dayView.dotView.hidden = !dayView.dotView.isHidden;
    
    
    // Load the previous or next page if touch a day from another month
#if 0   //这里是跳转到时间所对应月份的方法
    if(![_calendarManager.dateHelper date:_horizontalCalendarView.date isTheSameMonthThan:dayView.date]){
        if([_horizontalCalendarView.date compare:dayView.date] == NSOrderedAscending){
            [_horizontalCalendarView loadNextPageWithAnimation];
        }
        else{
            [_horizontalCalendarView loadPreviousPageWithAnimation];
        }
    }
#endif
}

-(UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar{
    
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont systemFontOfSize:18];
    
    view.textLabel.textColor = [UIColor colorWithRed:0.40f green:0.41f blue:0.42f alpha:1.00f];
    
    return view;
}

// Used to limit the date for the calendar

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    if([dayView isFromAnotherMonth]&&!_calendarManager.settings.weekModeEnabled){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:self.selectedDate isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        
        //        dayView.circleView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.lunarLabel.textColor= [UIColor whiteColor];
    }
    
    //    // Selected date
    //    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
    //        dayView.circleView.hidden = NO;
    //        dayView.circleView.backgroundColor = [UIColor redColor];
    //        dayView.dotView.backgroundColor = [UIColor whiteColor];
    //        dayView.textLabel.textColor = [UIColor whiteColor];
    //    }
    //    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        dayView.textLabel.textColor =[UIColor colorWithRed:0.40f green:0.41f blue:0.42f alpha:1.00f];
        dayView.lunarLabel.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.36f alpha:1.00f];
    }
    
    if ([_calendarManager.dateHelper date:dayView.date isEqualOrAfter:self.todayDate]) {
        dayView.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.86f alpha:1.00f];
        dayView.textLabel.textColor =[UIColor colorWithRed:0.40f green:0.41f blue:0.42f alpha:1.00f];
        dayView.lunarLabel.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.36f alpha:1.00f];
        dayView.userInteractionEnabled = NO;
        dayView.circleView.hidden = YES;
    }else{
        dayView.userInteractionEnabled = YES;
        dayView.backgroundColor = [UIColor whiteColor];
    }
    //
    //    // Your method to test if a date have an event for example
    //    if([self haveEventForDay:dayView.date]){
    //        dayView.dotView.hidden = NO;
    //    }
    //    else{
    //        dayView.dotView.hidden = YES;
    //    }
}

#pragma mark - getter

-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

-(JTHorizontalCalendarView *)horizontalCalendarView{
    if (!_horizontalCalendarView) {
        JTHorizontalCalendarView* horizontalView = [[JTHorizontalCalendarView alloc]init];
        //        horizontalView.frame = CGRectMake(0, 0,300, 300);
        [self addSubview:horizontalView];
        _horizontalCalendarView = horizontalView;
    }
    return _horizontalCalendarView;
}

-(JTCalendarManager *)calendarManager{
    if (!_calendarManager) {
        _calendarManager = [JTCalendarManager new];
        [self createMinAndMaxDate];
        _calendarManager.delegate = self;
        [_calendarManager setMenuView:self.menuView];
        [_calendarManager setContentView:self.horizontalCalendarView];
        
        [_calendarManager setDate:_selectedDate];
    }
    return _calendarManager;
}

//选中时间数组
-(NSMutableArray *)datesSelectedArray{
    if (!_datesSelectedArray) {
        _datesSelectedArray = [[NSMutableArray alloc]init];
    }
    return _datesSelectedArray;
}

-(JTCalendarMenuView *)menuView{
    if (!_menuView) {
        JTCalendarMenuView* menuView = [[JTCalendarMenuView alloc]init];
        menuView.backgroundColor = [UIColor whiteColor];
        _menuView = menuView;
        [self addSubview:menuView];
        [self loadNextPage];
        [self loadPrePage];
    }
    return _menuView;
}


#pragma mark - Date selection

- (BOOL)isInDatesSelected:(NSDate *)date
{
    for(NSDate *dateSelected in _datesSelectedArray){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - CalendarManager delegate - Page mangement

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSLog(@"Previous page loaded");
    
}

/**
 *  设置展示时间范围
 */
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    NSDate* newDate = [self getMonthBeginWith:date];
    NSDateComponents* components = [[NSDateComponents alloc]init];
    components.day = -1;
    return [_calendarManager.dateHelper date:newDate isEqualOrAfter:_minDate andEqualOrBefore:[self.calendarManager.dateHelper.calendar dateByAddingComponents:components toDate:_maxDate options:0]];
    //    return YES;
}

- (NSDate *)getMonthBeginWith:(NSDate *)newDate{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    double interval = 0;
    NSDate *beginDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit

    return beginDate;
}

- (void)createMinAndMaxDate
{
    if (_todayDate == nil) {
        _todayDate = [NSDate date];
    }
    
    
    // Min date will be 2 month before today
    if (!_minDate) {
        _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-50];
    }
    
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
}

//- (BOOL)haveEventForDay:(NSDate *)date
//{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//
////    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
////        return YES;
////    }
//
//    return NO;
//
//}

//时间展示格式
// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (UIButton *)loadNextPage{
    if (!_loadNextPage) {
        UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.tag = 1;
        nextBtn.frame = CGRectMake(self.frame.size.width - _menuView.frame.size.height, 0, _menuView.frame.size.height, _menuView.frame.size.height);
        [self addSubview:nextBtn];
        _loadNextPage = nextBtn;
    }
    return _loadNextPage;
}

- (UIButton *)loadPrePage{
    if (!_loadPrePage) {
        UIButton* preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [preBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
        [preBtn addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
        preBtn.tag = 0;
        preBtn.frame = CGRectMake(0, 0, _menuView.frame.size.height, _menuView.frame.size.height);
        [self addSubview:preBtn];
        _loadPrePage = preBtn;
    }
    return _loadPrePage;
}

- (void)pageChange:(UIButton*)btn{
    if (btn.tag == 0) {
        [_horizontalCalendarView loadPreviousPageWithAnimation];
    }else
        [_horizontalCalendarView loadNextPageWithAnimation];
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        UIView* view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        view.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.30f];
        [self addSubview:view];
        _backgroundView = view;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTap:)];
        [view addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (void)backgroundViewTap:(UIGestureRecognizer*)gesture{
    [UIView animateWithDuration:0.27 animations:^{
        //    (self.frame.size.height - CalendarHeight - 30)/2.0
        self.menuView.frame =  CGRectMake(0,kMainScreenHeight , self.frame.size.width, 50);
        self.horizontalCalendarView.frame = CGRectMake(0, CGRectGetMaxY(_menuView.frame), self.frame.size.width,CalendarHeight);
        
        self.loadPrePage.frame = CGRectMake(0, _menuView.frame.origin.y, _menuView.frame.size.height, _menuView.frame.size.height);
        self.loadNextPage.frame = CGRectMake(self.frame.size.width - _menuView.frame.size.height, _menuView.frame.origin.y, _menuView.frame.size.height,_menuView.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (_callBack) {
            _callBack(nil);
        }
        [self removeFromSuperview];
    }];
    
}


- (NSDate *)selectedDate{
    if (!_selectedDate) {
        _selectedDate = [NSDate date];
    }
    return _selectedDate;
}


@end
