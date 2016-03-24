//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCalendarManager.h"

@implementation JTCalendarDayView

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
    self.clipsToBounds = YES;
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        _circleView.hidden = YES;
        
        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    
    {
        _blueCircleView = [UIView new];
        [self addSubview:_blueCircleView];
        
        _blueCircleView.backgroundColor = [UIColor clearColor];
        _blueCircleView.hidden = YES;
        
        _blueCircleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _blueCircleView.layer.shouldRasterize = YES;
    }
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        _dotView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        _dotView.hidden = YES;
        
        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView.layer.shouldRasterize = YES;
    }
    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor colorWithRed:0.40f green:0.41f blue:0.42f alpha:1.00f];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    
    {
        _lunarLabel = [UILabel new];
        [self addSubview:_lunarLabel];
        _lunarLabel.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.36f alpha:1.00f];
        _lunarLabel.textAlignment = NSTextAlignmentCenter;
        _lunarLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}

- (void)layoutSubviews
{
    //    _textLabel.frame = self.bounds;
    _textLabel.frame = CGRectMake(0, 10, self.frame.size.width , 18);
    
    _lunarLabel.frame = CGRectMake(0, CGRectGetMaxY(_textLabel.frame) + 4, self.frame.size.width, 11);
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    sizeCircle = 44.0f;
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _circleView.layer.cornerRadius = sizeCircle / 2.;
    
    _blueCircleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _blueCircleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _blueCircleView.layer.borderWidth = 1.0;
    _blueCircleView.layer.cornerRadius = sizeCircle / 2.;

    [_blueCircleView.layer setMasksToBounds:YES];
    _blueCircleView.layer.borderColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f].CGColor;
    
    _dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView.center = CGPointMake(self.frame.size.width / 2., CGRectGetMaxY(_circleView.frame) + 3);
    _dotView.layer.cornerRadius = sizeDot / 2.;
}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    
    
    self->_date = date;
    [self reload];
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
        [dateFormatter setDateFormat:@"dd"];
    }
    
    _lunarLabel.text = [self getChineseCalendarWithDate:_date];
    _textLabel.text = [dateFormatter stringFromDate:_date];
    
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
#if 0
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅",	@"丁卯",	@"戊辰",	@"己巳",	@"庚午",	@"辛未",	@"壬申",	@"癸酉",
                             @"甲戌",	@"乙亥",	@"丙子",	@"丁丑", @"戊寅",	@"己卯",	@"庚辰",	@"辛己",	@"壬午",	@"癸未",
                             @"甲申",	@"乙酉",	@"丙戌",	@"丁亥",	@"戊子",	@"己丑",	@"庚寅",	@"辛卯",	@"壬辰",	@"癸巳",
                             @"甲午",	@"乙未",	@"丙申",	@"丁酉",	@"戊戌",	@"己亥",	@"庚子",	@"辛丑",	@"壬寅",	@"癸丑",
                             @"甲辰",	@"乙巳",	@"丙午",	@"丁未",	@"戊申",	@"己酉",	@"庚戌",	@"辛亥",	@"壬子",	@"癸丑",
                             @"甲寅",	@"乙卯",	@"丙辰",	@"丁巳",	@"戊午",	@"己未",	@"庚申",	@"辛酉",	@"壬戌",	@"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
#endif
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSCalendar *localeCalendar = nil;
    unsigned unitFlags = 0;
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
        unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    }else {
        localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    }
    
    
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    //    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    //    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    //    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@",d_str];
    
    return chineseCal_str;
}


@end
