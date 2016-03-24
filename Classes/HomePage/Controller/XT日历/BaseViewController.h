//
//  BaseViewController.h
//  MoShouBroker
//
//  Created by  NiLaisong on 15/5/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MobClick.h"
//#import "PLNavigationBar.h"
//#import "NetworkRequestFailed.h"
//#import "MyAlertView.h"
//#import "TipsView.h" //add by wangzz 150616

//#import "XSDatePickerView.h"
//#import "NSDate+MR.h"
@interface BaseViewController : UIViewController
/**
 *  DIY的导航条
 */
//@property(nonatomic,strong) PLNavigationBar * navigationBar;
//@property(retain,nonatomic) UIView *dateSelectedView;
//@property(retain,nonatomic) XSDatePickerView *picker;

//开启侧滑返回？ create by xiaotei 2015/11/23
@property (nonatomic,assign)BOOL popGestureRecognizerEnable;
@property(atomic,strong)UIImageView *animationImgView;
//显示无网络时的提示视图，并在有网络时可执行重新加载数据的block
//-(BOOL)createNoNetWorkViewWithReloadBlock:(ReloadDataBlock)reloadData;
//程序代理对象
-(id<UIApplicationDelegate>)appDelegate;
//程序根视图控制器
-(UIViewController*)rootViewController;
//加载动画loading，加载数据前调用
- (UIImageView *)setRotationAnimationWithView;
//移除动画loading，数据加载完成后移除
- (BOOL)removeRotationAnimationView:(UIImageView *)animationImgV;
- (void) showTips:(NSString *)info;//add by wangzz 150616
- (BOOL) isBlankString:(NSString*)string;//add by wangzz 150804
//-(void)setIQKeyboardEnable:(BOOL)enable;

//判断用户是否已绑定门店，如果没有提示用户需要绑定门店才有权进行一些操作
//可单独控制 是否需要跳转 需要跳转到设置页面设置isShouldJump =- YES 即可
- (BOOL)verifyTheRulesWithShouldJump:(BOOL)isShouldJump;
////初始化日期选择试图
//-(void)initDateSectedView;
//根据热点调整视图显示尺寸
-(void)adjustFrameForHotSpotChange;


- (void)leftBarButtonItemClick;

-(void)setUserInteractionWithEnabel:(BOOL)enable;


@end
