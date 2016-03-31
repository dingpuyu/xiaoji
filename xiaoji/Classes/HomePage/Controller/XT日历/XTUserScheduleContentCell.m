//
//  XTUserScheduleContentCell.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTUserScheduleContentCell.h"

@interface XTUserScheduleContentCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic,weak)UIView* lineView;

@end

@implementation XTUserScheduleContentCell

+ (instancetype)userScheduleContentCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTUserScheduleContentCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:className bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews  {
    [super layoutSubviews];
    
    if (!_cellFrame)return;
    
//    _dateLabel.frame = _cellFrame.timeLabelFrame;
    
//    _contentLabel.frame = _cellFrame.contentFrame;
    
    self.lineView.frame = CGRectMake(16, self.frame.size.height - 1, self.frame.size.width - 16, 1);
}

- (void)awakeFromNib {
    // Initialization code
    [self reloadInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadInfo{
    if (!_cellFrame)return;
    
    _dateLabel.text = _cellFrame.remindResult.datetime;
    
    _contentLabel.text = _cellFrame.remindResult.content;
    
    [self layoutSubviews];
}

- (void)setCellFrame:(XTUserScheduleCellFrame *)cellFrame{
    _cellFrame = cellFrame;
    
    [self reloadInfo];
}
//
//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 0.93f, 0.93f, 0.94f, 1.0f);//线条颜色
//    CGContextSetLineWidth(context, 1);
//    CGContextMoveToPoint(context,16,self.frame.size.height - 1);
//    CGContextAddLineToPoint(context, kMainScreenWidth,self.frame.size.height - 1);
//    CGContextStrokePath(context);
//}


- (UIView *)lineView{
    if (!_lineView) {
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
        _lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return _lineView;
}



@end
