//
//  JOViewControllerConstans.h
//  JOKit
//
//  Created by 刘维 on 16/11/16.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef JOViewControllerConstans_h
#define JOViewControllerConstans_h

typedef NS_ENUM(NSUInteger, JOActivityHUDStyle) {
    
    JOActivityHUDStyleIndicator,        //显示菊花 默认
    JOActivityHUDStyleCircleBall,       //显示小球的圆的轨迹运动
    JOActivityHUDStyleCircleLine,       //圆形的圆的轨迹运动
    JOActivityHUDStyleSixPolygonals,    //六边形
    JOActivityHUDStyleCircleDrawLine,   //无聊蛋疼写的动画
};

#endif /* JOViewControllerConstans_h */
