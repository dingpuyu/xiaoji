//
//  XTUserScheduleCell.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTUserScheduleCell.h"



@interface XTUserScheduleCell()

@property (nonatomic,weak)UILabel* timeLabel;

//提醒内容label
@property (nonatomic,weak)UILabel* remindContentLabel;
//提醒内容
@property (nonatomic,copy)NSString* remindContent;

@end

@implementation XTUserScheduleCell

+ (instancetype)userScheduleCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTUserScheduleCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        [tableView registerClass:[self class] forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
        NSLog(@"注册，注册，注册XTUserScheduleCell");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self timeLabel];
    [self remindContentLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    _timeLabel.frame = CGRectMake(CellMargin,0, self.frame.size.width - CellMargin * 2, 15);
    
    _remindContentLabel.frame = CGRectMake(CellMargin, CGRectGetMaxY(_timeLabel.frame), self.frame.size.width - CellMargin * 2, 50);
}


#pragma mark - getter

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        UILabel* timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLabel];
        
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (UILabel *)remindContentLabel{
    if (!_remindContentLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        _remindContentLabel = label;
    }
    return _remindContentLabel;
}

//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    if(_callBtn){
//    CGContextSetRGBStrokeColor(context, 0.90, 0.90, 0.90, 0.9);//线条颜色
//    CGContextMoveToPoint(context, CellMargin, 50);
//    CGContextAddLineToPoint(context, self.frame.size.width,_callBtn.frame.origin.y - 20);
//    CGContextStrokePath(context);
//    }
//    CGContextSetRGBStrokeColor(context, 0.90, 0.90, 0.90, 0.9);//线条颜色
//    CGContextMoveToPoint(context, 0, self.frame.size.height - 1);
//    CGContextAddLineToPoint(context, self.frame.size.width,self.frame.size.height - 1);
//    CGContextStrokePath(context);
//
//}
@end
