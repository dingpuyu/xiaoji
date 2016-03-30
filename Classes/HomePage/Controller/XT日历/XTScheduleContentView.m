//
//  XTScheduleContentView.m
//  LastCalendar
//
//  Created by xiaotei's on 15/12/14.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "XTScheduleContentView.h"
#import "XTUserScheduleInfoCell.h"
#import "UITableViewRowAction+JZExtension.h"
#import "XTScheduleInfoTableView.h"
#import "XTUserScheduleContentCell.h"

#import "XTUserScheduleCellFrame.h"
//#import "DataFactory+Main.h"

//#import "CustomerEditViewController.h"
#import "NSString+Extension.h"

//addby xiaotei 2016-2-25
//#import "ScheduleDateInfoCell.h"
#import "xiaoji-Swift.h"

#define WeekViewHeight 50.0f

#define kMainScreenWidth self.frame.size.width

@interface XTScheduleContentView() <UITableViewDelegate,UITableViewDataSource>




@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UIView* lineView2;

@property (nonatomic,assign)BOOL noResult;

@property (nonatomic,weak)UIView* noDataTipsView;

@end

@implementation XTScheduleContentView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    [self tableView];

}

//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    __weak typeof(self) weakSelf = self;
//    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
////        [weakSelf.tableView setEditing:false animated:true];
////        XTUserScheduleCellFrame* cellFrame = weakSelf.cellModelArray[indexPath.row - 1];        
////        if (weakSelf.deleteCallBack) {
////            weakSelf.deleteCallBack(cellFrame.remindResult.remindId);
////        }
//        
//    };
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"xiaoxi删除"] handler:rowActionHandler];
//    
//    return @[action1];
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0|| indexPath.row % 2 ==0 ) {
//        return NO;
//    }else return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.tableView setEditing:false animated:true];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellModelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XTNoteItemShowCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XTNoteItemShowCell class])];
    if (!cell) {
        cell = [[XTNoteItemShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([XTNoteItemShowCell class])];
    }
    
    if (_cellModelArray.count > indexPath.row) {
        cell.noteItemModel = _cellModelArray[indexPath.row];
    }
    return cell;
}

- (void)layoutSubviews{
    self.lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 0.5);
    self.lineView2.frame = CGRectMake(0, 9.5, kMainScreenWidth, 0.5);
    self.tableView.frame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 10);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startY = round(self.frame.origin.y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    
    if (_draggingEvent) {
        _draggingEvent(1);
    }
//
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_draggingEvent) {
        _draggingEvent(1);
    }
}

- (XTScheduleInfoTableView *)tableView{
    if (!_tableView) {              
        XTScheduleInfoTableView* tableView = [[XTScheduleInfoTableView alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 10)];
        [self addSubview:tableView];
    
        tableView.dataSource = self;
        tableView.delegate = self;
//        tableView.scrollEnabled = NO;
        _tableView = tableView;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat scale = kMainScreenWidth / 375.0;
    
    if (_cellModelArray.count < indexPath.row) {
        return 100;
    }
    
    CGFloat height = [XTNoteItemShowCell heightWithModel:_cellModelArray[indexPath.row]];

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0 && indexPath.row %2 == 0) {
        if (_cellModelArray.count < indexPath.row)return;
//        XTUserScheduleCellFrame* result = _cellModelArray[indexPath.row - 1];
//        if (_customerCallBack && result != nil) {
//            _customerCallBack(XTUserScheduleInfoCellDetailInfo,result.remindResult);
//        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_callBack) {
        _callBack(_tableView,scrollView.contentOffset);
    }
}

- (void)setScrollEnable:(BOOL)scrollEnable{
    _scrollEnable = scrollEnable;
    _tableView.scrollEnabled = scrollEnable;
}

- (void)setContentOffsetZero{
    [_tableView setContentOffset:CGPointZero];
}

- (void)drawRect:(CGRect)rect{

}



#pragma mark - getter
- (UIView *)lineView{
    if (!_lineView) {
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
        [self addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}

- (UIView *)lineView2{
    if (!_lineView2) {
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
        [self addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}


- (void)reloadInfo{
    if (!_cellModelArray) return;
    
    [_tableView reloadData];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadInfo];
}

- (UIView *)noDataTipsView{
    if (!_noDataTipsView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth , 100)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton* requestMoneyBtn = [[UIButton alloc]init];
        [requestMoneyBtn addTarget:self action:@selector(addScheduleAction) forControlEvents:UIControlEventTouchUpInside];
        [requestMoneyBtn setTitle:@"去添加吧！" forState:UIControlStateNormal];
        requestMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [requestMoneyBtn setTitleColor:[UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [self addSubview:view];
        UILabel* label = [[UILabel alloc]init];
        label.text = @"今天无事件提醒，";
        label.font = [UIFont systemFontOfSize:14];
        NSString* titleString = @"今天无事件提醒，去添加吧！";
        CGSize size = [titleString sizeWithfont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat x = (kMainScreenWidth - size.width) / 2.0;
        CGFloat y = (100 - size.height) / 2.0;
        label.frame = CGRectMake(x, y,112, 14);
        requestMoneyBtn.frame = CGRectMake(CGRectGetMaxX(label.frame), label.frame.origin.y, 70, 14);
        UIView* blueLineView = [[UIView alloc]init];
        blueLineView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        blueLineView.frame = CGRectMake(requestMoneyBtn.frame.origin.x, requestMoneyBtn.frame.origin.y + 16, 60, 1);
        [view addSubview:blueLineView];
        [view addSubview:requestMoneyBtn];
        [view addSubview:label];
        _noDataTipsView = view;
        view.hidden = YES;
    }
    return _noDataTipsView;
}

//添加提醒
- (void)addScheduleAction{
    if (_customerCallBack) {
        _customerCallBack(XTUserScheduleInfoCellAddSchedule,nil);
    }
}

- (void)setCellModelArray:(NSArray *)cellModelArray{
    _cellModelArray = cellModelArray;
    [self.tableView reloadData];
}

- (void)dealloc{

}

@end
