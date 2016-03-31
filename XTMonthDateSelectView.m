//
//  XTMonthDateSelectView.m
//  MoShou2
//
//  Created by xiaotei's on 16/3/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMonthDateSelectView.h"
#import "UUDatePicker.h"

#define kMainScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface XTMonthDateSelectView()

@property (nonatomic,weak)UIView* backgroundView;

@property (nonatomic,strong)NSDateFormatter* yearDateFormatter;

@property (nonatomic,weak)UILabel* yearLabel;
//确认按钮
@property (nonatomic,weak)UIButton*  fixButton;

@property (nonatomic,weak)UIButton* cancelButton;

@property (nonatomic,weak)UUDatePicker* datePicker;

@property (nonatomic,weak)UIView* topContentView;
@end

@implementation XTMonthDateSelectView


- (instancetype)initWithCallBack:(XTMonthSelectEventCallBack)callBack{
    if (self = [super init]) {
        self.callBack = callBack;
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    [self backgroundView];
    NSDate *now = [NSDate date];
    if (_selectedDate) {
        now = _selectedDate;
    }
    
    __weak typeof(self) weakSelf = self;
    UUDatePicker *datePicker
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width, 216)
                             PickerStyle:UUDateStyle_YearMonth
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 NSString* timeStr = [NSString stringWithFormat:@"%@-%@",year,month];
                                 NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                                 formatter.dateFormat =  @"yyyy-MM";
                                 NSDate* date = [formatter dateFromString:timeStr];
                                 weakSelf.selectedDate = date;
                             }];
    //    datePicker.maxLimitDate = [now dateByAddingTimeInterval:2222];
    datePicker.ScrollToDate = now;
    
    _datePicker = datePicker;
    //    picker.locale = [NSLocale currentLocale];
    
    _selectedDate = now;
//    datePicker.minLimitDate = [NSDate date];
    [self addSubview:_datePicker];
    
    _datePicker.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
    _datePicker.frame = CGRectMake(0, kMainScreenHeight + 30, kMainScreenWidth, 236);
    //        _datePicker.frame = CGRectMake(0, self.frame.size.height - 216, self.frame.size.width, 216);
        self.topContentView.frame = CGRectMake(0, _datePicker.frame.origin.y - 35, kMainScreenWidth, 35);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (_selectedDate) {
        _datePicker.ScrollToDate = _selectedDate;
    }
}


- (void)didMoveToSuperview{
    [UIView animateWithDuration:0.35 animations:^{
        _datePicker.frame = CGRectMake(0, kMainScreenHeight - 216, kMainScreenWidth, 236);
        //        _datePicker.frame = CGRectMake(0, self.frame.size.height - 216, self.frame.size.width, 216);
        self.topContentView.frame = CGRectMake(0, _datePicker.frame.origin.y - 35, kMainScreenWidth, 35);
    }];
}

- (void)layoutSubviews{
    _backgroundView.frame = self.bounds;
    
}

- (void)tapAction:(UIGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:self];
    
    if (point.y < _datePicker.frame.origin.y || point.y > CGRectGetMaxY(_datePicker.frame)) {
        [UIView animateWithDuration:0.35 animations:^{
            _datePicker.frame = CGRectMake(0, kMainScreenHeight + 30, kMainScreenWidth, 236);
        self.topContentView.frame = CGRectMake(0, _datePicker.frame.origin.y - 35, kMainScreenWidth, 35);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.30f];
        [self addSubview:view];
        _backgroundView = view;
    }
    return _backgroundView;
}

- (NSDateFormatter *)yearDateFormatter{
    if (!_yearDateFormatter) {
        _yearDateFormatter = [[NSDateFormatter alloc]init];
        _yearDateFormatter.dateFormat = @"yyyy";
    }
    return _yearDateFormatter;
}


- (UIView *)topContentView{
    if (!_topContentView) {
        UIView* view = [[UIView alloc]init];
        [view addSubview:self.yearLabel];
        [view addSubview:self.fixButton];
        [view addSubview:self.cancelButton];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        _topContentView = view;
    }
    return _topContentView;
}

- (UILabel *)yearLabel{
    if (!_yearLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, kMainScreenWidth - 100, 20)];
        label.text = @"选择提醒时间";
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        _yearLabel = label;
    }
    return _yearLabel;
}

- (UIButton *)fixButton{
    if (!_fixButton) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kMainScreenWidth - 50, 15, 50, 20);
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(fixButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateHighlighted];
        
        _fixButton = button;
    }
    return _fixButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 15, 50, 20);
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateHighlighted];
        
        _cancelButton = button;
    }
    return _cancelButton;
}

- (void)fixButtonClick:(UIButton*)button{
    if (_callBack) {
        _callBack(self,_selectedDate);
    }
    [UIView animateWithDuration:0.35 animations:^{
        _datePicker.frame = CGRectMake(0, kMainScreenHeight + 30, kMainScreenWidth, 236);
        self.topContentView.frame = CGRectMake(0, _datePicker.frame.origin.y - 35, kMainScreenWidth, 35);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancelButtonClick:(UIButton*)button{
    [UIView animateWithDuration:0.35 animations:^{
        _datePicker.frame = CGRectMake(0, kMainScreenHeight + 30, kMainScreenWidth, 236);
        self.topContentView.frame = CGRectMake(0, _datePicker.frame.origin.y - 35, kMainScreenWidth, 35);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
