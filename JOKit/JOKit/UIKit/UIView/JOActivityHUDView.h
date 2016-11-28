//
//  JOActivityHUDView.h
//  JOKit
//
//  Created by 刘维 on 16/11/17.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOViewControllerConstans.h"

@interface JOActivityHUDView : UIView

@property (nonatomic, strong) UIColor *activityHUDBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 根据Style生成JOActivityHUDView对象

 @param style JOActivityHUDStyle
 @return JOActivityHUDView
 */
- (instancetype)initWithActivityHUDStyle:(JOActivityHUDStyle)style;
+ (instancetype)activityHUDViewWithStyle:(JOActivityHUDStyle)style;

/**
 在哪个视图上面显示.

 @param view    需要显示的视图
 @param style   JOActivityHUDStyle
 @param size    大小
 */
+ (instancetype)showInView:(UIView *)view;
+ (instancetype)showInView:(UIView *)view style:(JOActivityHUDStyle)style;
+ (instancetype)showInView:(UIView *)view style:(JOActivityHUDStyle)style size:(CGSize)size;


/**
 隐藏视图上面的Activity HUD View.

 @param view 需要隐藏哪个视图上面的.
 */
+ (void)hiddenInView:(UIView *)view;

@end
