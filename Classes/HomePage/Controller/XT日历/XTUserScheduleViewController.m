//
//  ViewController.m
//  LastCalendar
//
//  Created by xiaotei's on 15/12/11.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//
#import "XTUserScheduleViewController.h"
//#import "XTAddRemindController.h"
#import "JTCalendar.h"
#import "XTCalendarPageView.h"
#import "XTHorizontalCalendarView.h"
#import "XTScheduleContentView.h"
//#import "DataFactory+Main.h"
//#import "DataFactory+Customer.h"
#import "RemindResult.h"
//#import "CustomerEditViewController.h"
//#import "AppDelegate.h"
//add by xiaotei 2016-2-18
//#import "CustomerDetailViewController.h"
//#import "CustomerFollowDetailViewController.h"
#import "xiaoji-Swift.h"

//#import "XTHelpView.h"

#define WeekViewHeight 57.0f
#define kMainScreenWidth self.frame.size.width

CGFloat const gestureMinimumTranslation = 20.0 ;

typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;

@interface XTUserScheduleViewController ()<JTCalendarDelegate,UIGestureRecognizerDelegate>{
//    CGFloat ;
    CameraMoveDirection direction;
    
    BOOL _isGesture;
}
@property (nonatomic,assign)CGFloat contentViewPanStartY;

@property (nonatomic,strong)JTCalendarManager* calendarManager;

@property (nonatomic,weak)XTHorizontalCalendarView* pageView;

//选中的周
@property (nonatomic,weak)JTCalendarWeekView* selectedWeekView;
//选中时间
@property (nonatomic,copy)NSDate* selectedDate;

@property (nonatomic,copy)NSDate* currentDate;


@property (nonatomic,weak)UIView* calendarLineView;
//顶部视图
@property (nonatomic,weak)UILabel* menuLabel;
//返回时间格式
@property (nonatomic,strong)NSDateFormatter* inputFormatter;
//标题时间格式
@property (nonatomic,strong)NSDateFormatter* formatter;
//请求时间格式
@property (nonatomic,strong)NSDateFormatter* requestFormatter;
//小时，时间格式
@property (nonatomic,strong)NSDateFormatter* hourFormatter;

@property (nonatomic,strong)NSDateFormatter* monthDayFormatter;

//选中数据数组
@property (nonatomic,strong)NSMutableArray* datesSelectedArray;

@property (nonatomic,copy)NSDate* todayDate;
//内容容器视图
@property (nonatomic,weak)XTScheduleContentView* contentView;

//添加日程按钮
@property (nonatomic,weak)UIButton* addScheduleBtn;
//返回今天
@property (nonatomic,weak)UIButton* todayBtn;

//@property (nonatomic,strong)XTScheduleListResultModel* resultModel;

@property (nonatomic,strong)NSArray* scheduleEventsArray;

@property (nonatomic,strong)NSArray* eventDateArray;

@end

@implementation XTUserScheduleViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self calendarManager];

    [_pageView reload];
    [self reloadInfo];
    _scheduleEventsArray = nil;
    [self scheduleEventsArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    // Do any additional setup after loading the view, typically from a nib.
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    _calendarManager.date = [NSDate date];
////    //    UIView<JTCalendarWeekDay> * weekDayView =
    _selectedDate = [NSDate date];
    _currentDate = [NSDate date];

    XTHorizontalCalendarView* pageView = [[XTHorizontalCalendarView alloc]init];
    pageView.manager = _calendarManager;
    pageView.date = [NSDate date];
    _pageView = pageView;
    [self.view addSubview:pageView];
    pageView.frame = CGRectMake(0, 94, self.view.frame.size.width, WeekViewHeight * 6);
    [_calendarManager setContentView:pageView];
    [pageView reload];
  
    UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    maskView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [self.view addSubview:maskView];
    
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(_pageView.frame), self.view.frame.size.width, self.view.frame.size.height);
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];

    pan.delegate = self;
    [self.pageView addGestureRecognizer:pan];
    
    JTCalendarWeekDayView* weekDayView = [[JTCalendarWeekDayView alloc]init];
    weekDayView.manager = _calendarManager;
    weekDayView.frame = CGRectMake(0, 64, self.view.frame.size.width, 30);
    [weekDayView reload];
    [self.view addSubview:weekDayView];

    JTCalendarWeekView* weekView = [[JTCalendarWeekView alloc]init];
    weekView.manager = _calendarManager;
    [weekView setStartDate:[_calendarManager.dateHelper firstWeekDayOfWeek:_selectedDate] updateAnotherMonth:YES monthDate:_currentDate];

    weekView.frame = CGRectMake(0, 94,_pageView.frame.size.width, WeekViewHeight);
    weekView.hidden = YES;
    _selectedWeekView = weekView;
    [self.view addSubview:weekView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
    _todayDate = [NSDate date];

    [self todayBtn];
    [self addScheduleBtn];
    
    self.menuLabel.frame =  CGRectMake(0, 41.5, self.view.frame.size.width, 22.5);
    self.menuLabel.backgroundColor = [UIColor clearColor];
    [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];

    self.popGestureRecognizerEnable = YES;

    [self.view insertSubview:pageView belowSubview:maskView];
   
    self.title = @"我的日程";
    [self hasNetwork];
    
    [self addHelpView];
    

}



- (void)panAction:(UIPanGestureRecognizer*)gesture{
    if (_pageView.contentOffset.x != self.view.frame.size.width) {
        [self.view setNeedsLayout];
        return;
    }
    CGPoint translation;
    
    translation = [gesture translationInView:self.view];
    
    
    if (gesture.state == UIGestureRecognizerStateBegan )
        
    {
        _isGesture = YES;
        direction = kCameraMoveDirectionNone;
        _contentViewPanStartY = round(_contentView.frame.origin.y);
        
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone)
        
    {
        
        direction = [self determineCameraDirectionIfNeeded:translation];
    }
    
    else if (gesture.state == UIGestureRecognizerStateEnded )
        
    {
        _isGesture = NO;
        [self.view setNeedsLayout];
    }
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGFloat offsetY = translation.y *(1 - (_pageView.frame.origin.y / self.view.frame.size.height) + 0.2);
    
    NSUInteger index = [_pageView weekIndexWithDate:_selectedDate];
    if (_pageView.frame.origin.y + offsetY + WeekViewHeight * index < 94) {
        NSUInteger index = [_pageView weekIndexWithDate:_selectedDate];
        _pageView.center = CGPointMake(_pageView.center.x, _pageView.center.y + 94 - WeekViewHeight * index - _pageView.frame.origin.y);
    }else  {
        if ((_pageView.frame.origin.y + offsetY < 94 && _contentView.frame.origin.y >= CGRectGetMaxY(_pageView.frame)) || (_contentView.frame.origin.y >= 94 + WeekViewHeight * 6)) {
            _pageView.center = CGPointMake(_pageView.center.x, _pageView.center.y + offsetY);
        }
        
        
    }
    if (_contentView.frame.origin.y + offsetY > 94 + WeekViewHeight) {
        _contentView.center = CGPointMake(_contentView.center.x,_contentView.center.y + offsetY);
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView{
    _selectedDate = dayView.date;
    if(![_calendarManager.dateHelper date:_pageView.date isTheSameMonthThan:dayView.date]){
        if([_pageView.date compare:dayView.date] == NSOrderedAscending){
            [_pageView loadNextPageWithAnimation];
        }
        else{
            [_pageView loadPreviousPageWithAnimation];
        }
    }
    [_pageView reload];
    [self reloadInfo];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!_contentViewPanStartY)return;
    CGFloat duration = 0.2;
    if (_contentView.frame.origin.y == 145) {
        duration = 0;
    }
    
    [UIView animateWithDuration:duration animations:^{
        if (_contentViewPanStartY - 1 <= 94 + WeekViewHeight && _contentView.frame.origin.y >= 94 + WeekViewHeight * 1.5) {
            _pageView.frame = CGRectMake(0, 94, self.view.frame.size.width, WeekViewHeight * 6);
            _contentView.frame = CGRectMake(0, CGRectGetMaxY(_pageView.frame) + 1, self.view.frame.size.width, self.view.frame.size.height - 94 - WeekViewHeight);
        }else if(_contentViewPanStartY - 1 <= 94 + WeekViewHeight && _contentView.frame.origin.y < 94 + WeekViewHeight * 1.5){
            NSUInteger index = [_pageView weekIndexWithDate:_selectedDate];
            _pageView.frame = CGRectMake(0, 94 - WeekViewHeight * index , self.view.frame.size.width, WeekViewHeight * 6);
            _contentView.frame = CGRectMake(0, 94 + WeekViewHeight + 1, self.view.frame.size.width, self.view.frame.size.height - 94 - WeekViewHeight);
            _contentView.scrollEnable = YES;
        }
        
        if (_contentViewPanStartY >= 94 + WeekViewHeight * 6 && _contentView.frame.origin.y >= 94 + WeekViewHeight * 6 - WeekViewHeight * 0.5) {
            _pageView.frame = CGRectMake(0, 94, self.view.frame.size.width, WeekViewHeight * 6);
            _contentView.frame = CGRectMake(0, CGRectGetMaxY(_pageView.frame) + 1, self.view.frame.size.width, self.view.frame.size.height  - 94 - WeekViewHeight);
        }else if(_contentViewPanStartY >= 94 + WeekViewHeight * 6 && _contentView.frame.origin.y < 94 + WeekViewHeight * 6 - WeekViewHeight * 0.5){
            NSUInteger index = [_pageView weekIndexWithDate:_selectedDate];
            _pageView.frame = CGRectMake(0, 94 - WeekViewHeight * index , self.view.frame.size.width, WeekViewHeight * 6);
            
            _contentView.frame = CGRectMake(0, 94 + WeekViewHeight + 1, self.view.frame.size.width, self.view.frame.size.height - 94 - WeekViewHeight);
            _contentView.scrollEnable = YES;
        }
        
    }];
    if (_contentView.frame.origin.y < 94 + WeekViewHeight * 3) {
        _pageView.scrollEnabled = YES;
    }else     if (_contentView.frame.origin.y > 94 + WeekViewHeight * 3) {
        _pageView.scrollEnabled = YES;
    }
}

- ( CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation

{
    
    if (direction != kCameraMoveDirectionNone)
        
        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    
    if (fabs(translation.x) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
            
            gestureHorizontal = YES;
        
        else
            
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        
        if (gestureHorizontal)
            
        {
            
            if (translation.x > 0.0 )
                
                return kCameraMoveDirectionRight;
            
            else
                
                return kCameraMoveDirectionLeft;
            
        }
        
    }
    
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if (fabs(translation.y) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
            
            gestureVertical = YES;
        
        else
            
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        
        if (gestureVertical)
            
        {
            
            if (translation.y > 0.0 )
                
                return kCameraMoveDirectionDown;
            
            else
                
                return kCameraMoveDirectionUp;
            
        }
        
    }
    
    return direction;
    
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    NSDate* sameDate = _pageView.date;
    // Today
    // Today
    dayView.blueCircleView.hidden = YES;
    dayView.circleView.hidden = YES;
    dayView.dotView.hidden = YES;
    dayView.circleView.backgroundColor = [UIColor clearColor];
    dayView.dotView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.87f alpha:1.00f];
    dayView.textLabel.textColor = [UIColor colorWithRed:0.32f green:0.32f blue:0.32f alpha:1.00f];
    dayView.lunarLabel.textColor = [UIColor colorWithRed:0.32f green:0.32f blue:0.32f alpha:1.00f];
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.blueCircleView.hidden = NO;
        if ([_calendarManager.dateHelper date:_selectedDate isTheSameDayThan:[NSDate date]]) {
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = [UIColor colorWithRed:0.17f green:0.80f blue:0.80f alpha:1.00f];
            //        dayView.dotView.backgroundColor = [UIColor whiteColor];
            dayView.textLabel.textColor = [UIColor whiteColor];
            dayView.lunarLabel.textColor = [UIColor whiteColor];
        }
    }
    else if([_calendarManager.dateHelper date:_selectedDate isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:0.17f green:0.80f blue:0.80f alpha:1.00f];
        //        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.lunarLabel.textColor = [UIColor whiteColor];
    }
    else if(sameDate){
        if (![_calendarManager.dateHelper date:_pageView.date isTheSameMonthThan:dayView.date]) {
            dayView.circleView.hidden = YES;
            dayView.dotView.backgroundColor = [UIColor redColor];
            dayView.textLabel.textColor = [UIColor lightGrayColor];
            dayView.lunarLabel.textColor = [UIColor lightGrayColor];
        }
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    for (int i = 0; i < self.eventDateArray.count; i++) {
        NSDate* date = _eventDateArray[i];
        if ([_calendarManager.dateHelper date:date isTheSameDayThan:dayView.date]) {
            dayView.dotView.hidden = NO;
        }
    }
}


- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar{
    
    if (![_calendarManager.dateHelper date:_selectedDate isTheSameMonthThan:_pageView.date]) {
        _selectedDate = [_calendarManager.dateHelper addToDate:_selectedDate months:1];
        [_pageView reload];
        [self.view setNeedsLayout];
    }
    [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
    [self reloadInfo];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar{
    if (![_calendarManager.dateHelper date:_selectedDate isTheSameMonthThan:_pageView.date]) {
        _selectedDate = [_calendarManager.dateHelper addToDate:_selectedDate months:-1];
        [_pageView reload];
        [self.view setNeedsLayout];
    }
    [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
    [self reloadInfo];
}

-(JTCalendarManager *)calendarManager{
    if (!_calendarManager) {
        _calendarManager = [JTCalendarManager new];
        _calendarManager.delegate = self;
        
        [_calendarManager setDate:[NSDate date]];
        
        [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
    }
    return _calendarManager;
}

#pragma mark - getter
- (NSArray *)scheduleEventsArray{
    if (!_scheduleEventsArray) {
        __weak typeof(self) weakSelf = self;
//        [[DataFactory sharedDataFactory]getAllScheduleListWithCallBack:^(XTScheduleListResultModel *result) {
//            weakSelf.scheduleEventsArray = result.remindList;
//            NSMutableArray* arrayM = [NSMutableArray array];
//            for (int i = 0; i < result.remindList.count; i++) {
//                RemindResult* result = weakSelf.scheduleEventsArray[i];
//                if ([result isKindOfClass:[RemindResult class]]) {
//                    [arrayM addObject:[weakSelf.inputFormatter dateFromString:result.datetime]];
//                }
//            }
//            weakSelf.eventDateArray = arrayM;
//            [weakSelf.pageView reload];
//        }];
    }
    return _scheduleEventsArray;
}

- (NSDateFormatter *)inputFormatter{
    if (!_inputFormatter) {
        _inputFormatter = [[NSDateFormatter alloc]init];
        _inputFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return _inputFormatter;
}

-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"yyyy年MM月";
    }
    return _formatter;
}

- (NSDateFormatter *)hourFormatter{
    if (!_hourFormatter) {
        _hourFormatter = [[NSDateFormatter alloc]init];
        _hourFormatter.dateFormat = @"HH:mm";
    }
    return _hourFormatter;
}


- (NSDateFormatter *)requestFormatter{
    if (!_requestFormatter) {
        _requestFormatter = [[NSDateFormatter alloc]init];
        _requestFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _requestFormatter;
}

- (NSDateFormatter *)monthDayFormatter{
    if (!_monthDayFormatter) {
        _monthDayFormatter  = [[NSDateFormatter alloc]init];
        _monthDayFormatter.dateFormat = @"MM-dd";
    }
    return _monthDayFormatter;
}

- (UILabel *)menuLabel{
    if (!_menuLabel) {
        UILabel* label = [[UILabel alloc]init];
        [label setTextColor:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f]];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.textAlignment = NSTextAlignmentCenter;
//        [self.navigationBar addSubview:label];
        _menuLabel = label;
    }
    return _menuLabel;
}

- (XTScheduleContentView *)contentView{
    if (!_contentView) {
        XTScheduleContentView * view = [[XTScheduleContentView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];

        __weak typeof(self) weakSelf = self;
        view.callBack = ^(UITableView* tableView,CGPoint contentOffset){
            weakSelf.contentViewPanStartY = weakSelf.contentView.startY;
            if (weakSelf.contentView.frame.origin.y - tableView.contentOffset.y > 94 + WeekViewHeight) {

                tableView.contentOffset = CGPointZero;
            } else if(weakSelf.contentView.frame.origin.y <= 94 + WeekViewHeight && tableView.contentOffset.y <= 0){

            }
            CGFloat offsetY = -contentOffset.y;
            
            NSUInteger index = [weakSelf.pageView weekIndexWithDate:weakSelf.selectedDate];
            if (weakSelf.contentView.frame.origin.y + offsetY <= 94) {
                weakSelf.contentView.center = CGPointMake(weakSelf.contentView.center.x, 95 + WeekViewHeight + weakSelf.contentView.frame.size.height / 2.0f);
            }
            if (weakSelf.pageView.frame.origin.y + offsetY + WeekViewHeight * index < 94) {

                NSUInteger index = [weakSelf.pageView weekIndexWithDate:weakSelf.selectedDate];
                weakSelf.pageView.center = CGPointMake(weakSelf.pageView.center.x, weakSelf.pageView.center.y + 94 - WeekViewHeight * index - weakSelf.pageView.frame.origin.y);
                
            }else  {
                if ((weakSelf.pageView.frame.origin.y + offsetY < 94 && weakSelf.contentView.frame.origin.y >= CGRectGetMaxY(weakSelf.pageView.frame)) || (weakSelf.contentView.frame.origin.y >= 94 + WeekViewHeight * 6)) {
                    weakSelf.pageView.center = CGPointMake(weakSelf.pageView.center.x, weakSelf.pageView.center.y + offsetY);
                }
                
                
            }
            if (weakSelf.contentView.frame.origin.y + offsetY > 94 + WeekViewHeight) {
                weakSelf.contentView.center = CGPointMake(weakSelf.contentView.center.x,weakSelf.contentView.center.y + offsetY);
            }
        };
        
        view.draggingEvent = ^(NSUInteger integer){
            if (integer) {
                [weakSelf.view setNeedsLayout];
            }
        };
        
        view.deleteCallBack = ^(NSInteger remindID){
            if (remindID) {
                
            }
        };
//
        view.customerCallBack = ^(XTUserScheduleInfoCellEvent event,RemindResult* customer){
            switch (event) {
                case XTUserScheduleInfoCellCallEvent:
                {
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",customer.phone];
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [weakSelf.view addSubview:callWebview];
                }
                    break;
                case XTUserScheduleInfoCellAddFollow:{
//                    CustomerEditViewController *editVC = [[CustomerEditViewController alloc] init];
//                    editVC.customerMsgType = kAddCustomerFollowMsg;
//                    editVC.customerMsdId = customer.customerId;
//                    
//                    [editVC returnCustomerEditResultBlock:^() {
//
////                        [[DataFactory sharedDataFactory]getCustomerDetailWithId:customer.customerId withCallBack:^(Customer *result) {
////                            
////                        }];
//                    }];
//                    
//                    [weakSelf.navigationController pushViewController:editVC animated:YES];
                }
                    break;
                case XTUserScheduleInfoCellAddSchedule:
                {
                    [weakSelf addScheduleBtnClick:weakSelf.addScheduleBtn];
                }
                    break;
                case XTUserScheduleInfoCellDetailInfo:
                {
                    [weakSelf showCustomerDetail:customer];
                }
                    break;
                default:
                    break;
            }
        };
        
        [weakSelf.view addSubview:view];
        _contentView = view;
        _contentView.inputFormatter = self.inputFormatter;
        _contentView.hourFormatter = self.hourFormatter;
    }
    return _contentView;
}

-  (UIButton *)todayBtn{
    if (!_todayBtn) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(goBackToday:) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationBar addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"today"] forState:UIControlStateNormal];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 79, 20, 32, 44);
        _todayBtn = btn;
    }
    return _todayBtn;
}

- (UIButton *)addScheduleBtn{
    if (!_addScheduleBtn) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"icon_tianjia_h"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addScheduleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationBar addSubview:btn];
        btn.frame =CGRectMake([UIScreen mainScreen].bounds.size.width - 47, 20, 47, 44);
        _addScheduleBtn = btn;
    }
    return _addScheduleBtn;
}

#pragma mark - setter
//- (void)setResultModel:(XTScheduleListResultModel *)resultModel{
//    _resultModel = resultModel;
//    
//    _contentView.resultModel = resultModel;
//    
//    NSArray* weekDay = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
//    
//    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
//    
//    NSDateComponents *theComponents = [_calendarManager.dateHelper.calendar components:calendarUnit fromDate:_selectedDate];
//    NSString* dateStr = [self.monthDayFormatter stringFromDate:_selectedDate];
//    NSInteger weekD = [theComponents weekday];
//    if (weekD >= 0 && weekD <= 7){
//        resultModel.formatDateString = [NSString stringWithFormat:@"%@ %@",dateStr,weekDay[weekD - 1]];
//    }else resultModel.formatDateString = dateStr;
//    
//
//}

#pragma mark - 返回今日
- (void)goBackToday:(UIButton*)btn{
    _selectedDate = _todayDate;
    [_calendarManager setDate:_todayDate];
//    if (![_calendarManager.dateHelper date:_selectedDate isTheSameMonthThan:_todayDate]) {
    
//    }
    [self.view setNeedsLayout];
    [self.menuLabel setText:[self.formatter stringFromDate:[_calendarManager date]]];
    [self reloadInfo];
}

#pragma mark - 添加日程
- (void)addScheduleBtnClick:(UIButton*)btn{
//    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
//        [self showTips:@"网络不给力，请稍后重试"];
//        return;
//    }
//    
//    XTAddRemindController* addVC = [[XTAddRemindController alloc]init];
//    addVC.inputFormatter = self.inputFormatter;
//
//    if ([_calendarManager.dateHelper date:_selectedDate isEqualOrBefore:[NSDate date]]) {
//        addVC.selectedDate = [NSDate date];
//    }else  addVC.selectedDate = _selectedDate;
//    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - 展示客户详细
- (void)showCustomerDetail:(RemindResult*)result{
//    if (![NetworkSingleton sharedNetWork].isNetworkConnection) {
//        [self showTips:@"网络不给力，请稍后重试"];
//        return;
//    }
//    CustomerDetailViewController* detailVc = [[CustomerDetailViewController alloc]init];
//    detailVc.custId = result.customerId;
//    
//    [self.navigationController pushViewController:detailVc animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    if ((_pageView.frame.origin.y == 94 || _contentView.frame.origin.y == 152) && _contentView.frame.origin.y  != 152 ) {
        return YES;
    }
    return NO;
}

- (void)reloadInfo{
    if (!_selectedDate)return;
    __weak typeof(self) weakSelf = self;
    
    NSArray* titleModelArray = [XTDB selectTitleAndItemsWithDateStr:[self.requestFormatter stringFromDate:_selectedDate]];
    
    NSMutableArray* arrayM = [NSMutableArray array];
    for(TitleModel* model in titleModelArray){
        [arrayM addObjectsFromArray:model.itemModelArray];
    }
    self.contentView.cellModelArray = [arrayM copy];
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
//        UIImageView* loadingImageView = [self setRotationAnimationWithView];
//        [[DataFactory sharedDataFactory]getScheduleListWithDate:[self.requestFormatter stringFromDate:_selectedDate] withCallBack:^(XTScheduleListResultModel *result) {
//            [weakSelf removeRotationAnimationView:loadingImageView];
//            weakSelf.resultModel = result;
//        }];
//    }

    
}

- (void)hasNetwork{
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
//
//        [self reloadInfo];
//
//    }else{
//        [self createNoNetWorkViewWithReloadBlock:^{
//            [self scheduleEventsArray];
//            [self hasNetwork];
//            
//        }];
//    }
}


-(void)addHelpView
{
    
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstSchedule"])
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstSchedule"];
//        CGFloat scale = kMainScreenWidth/375.0;
//        NSString* prefixStr = @"iPhone";
//        if(iPhone4 ||  CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)))
//        {
//            prefixStr = @"iPhone4";
//            XTHelpView* helpView1 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help7",prefixStr] buttonY:244];
//            helpView1.frame = self.view.bounds;
//            [self.view addSubview:helpView1];
//            XTHelpView* helpView2 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help6",prefixStr] buttonY:388];
//            helpView2.frame = self.view.bounds;
//            [self.view addSubview:helpView2];
//            XTHelpView* helpView3 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help5",prefixStr] buttonY:239];
//            helpView3.frame = self.view.bounds;
//            [self.view addSubview:helpView3];
//        }else
//        {
//            XTHelpView* helpView1 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help7",prefixStr] buttonY:546 * scale];
//            helpView1.frame = self.view.bounds;
//            [self.view addSubview:helpView1];
//            XTHelpView* helpView2 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help6",prefixStr] buttonY:456 * scale];
//            helpView2.frame = self.view.bounds;
//            [self.view addSubview:helpView2];
//            XTHelpView* helpView3 = [XTHelpView helpViewWithImageName:[NSString stringWithFormat:@"%@_help5",prefixStr] buttonY:282 * scale];
//            helpView3.frame = self.view.bounds;
//            [self.view addSubview:helpView3];
//        }
//    }
//    
//    
}

- (void)dealloc{
    _calendarManager = nil;
    [_pageView removeFromSuperview];
    _pageView = nil;
    //选中的周
    _selectedWeekView = nil;
    //选中时间
    _selectedDate = nil;
    _currentDate = nil;
    _calendarLineView = nil;
    //顶部视图
   _menuLabel = nil;
    //返回时间格式
    _inputFormatter = nil;
    //标题时间格式
    _formatter = nil;
    //请求时间格式
    _requestFormatter = nil;
    //小时，时间格式
    _hourFormatter = nil;
    
    _monthDayFormatter = nil;
    //选中数据数组
    _datesSelectedArray = nil;
    
    _todayDate = nil;
    //内容容器视图
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    //添加日程按钮
    _addScheduleBtn = nil;
    //返回今天
    _todayBtn = nil;
    
//    _resultModel = nil;
    
    _scheduleEventsArray = nil;
    
    _eventDateArray = nil;
}


@end
