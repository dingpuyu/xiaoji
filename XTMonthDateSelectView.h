//
//  XTMonthDateSelectView.h
//  MoShou2
//
//  Created by xiaotei's on 16/3/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XTMonthDateSelectView;

typedef void(^XTMonthSelectEventCallBack)(XTMonthDateSelectView* selectView,NSDate* selectedDate);

@interface XTMonthDateSelectView : UIView

- (instancetype)initWithCallBack:(XTMonthSelectEventCallBack)callBack;

@property (nonatomic,copy)XTMonthSelectEventCallBack callBack;

@property (nonatomic,strong)NSDate* selectedDate;

@property (nonatomic,copy)NSString* dateStr;
@end
