//
//  XTUserScheduleContentCell.h
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTUserScheduleCellFrame.h"

@interface XTUserScheduleContentCell : UITableViewCell



+ (instancetype)userScheduleContentCellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong)XTUserScheduleCellFrame* cellFrame;

@end
