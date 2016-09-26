//
//  UIView+JOExtend.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOMacro.h"

@interface UIView(JOExtend)

/**
 创建一个自动使用autolayout功能的对象.
 
 @return - 带有autolayout的对象.
 */
+ (instancetype)newAutoLayoutView;

/**
 @see 跟+ (instancetype)newAutoLayoutView功能一样.
 */
- (instancetype)initAutoLayout;

/**
 *  获取View的截图
 *
 *  @return Image
 */
- (UIImage *)joViewSnapshotImage;


/**
 获取到View所在的ViewController的类

 @return ViewController  PS:有可能为nil.
 */
- (UIViewController *)joViewController;

/**
 *  移除视图上面所有的子视图
 */
- (void)removeAllSubviews;

/*设置view的圆角*/
- (void)joViewCornerRadius:(CGFloat)radius;

/*设置view的border的宽度跟颜色*/
- (void)joViewBorderWidth:(CGFloat)width color:(UIColor *)color;

@end

@interface UIView(JOFrameExtend)

#define JOViewBottomY(view)     view.frame.origin.y+view.frame.size.height
#define JOViewRightX(view)      view.frame.origin.x+view.frame.size.width
#define JOViewWidth(view)       view.frame.size.width
#define JOViewHeight(view)      view.frame.size.height
#define JOViewX(view)           view.frame.origin.x
#define JOViewY(view)           view.frame.origin.y
#define JOViewOrigin(view)      view.frame.origin
#define JOViewSize(view)        view.frame.size
#define JOViewCenterX(view)     view.center.x
#define JOViewCenterY(view)     view.center.y

@property (nonatomic) CGFloat       y;
@property (nonatomic) CGFloat       x;
@property (nonatomic) CGFloat       bottomY;
@property (nonatomic) CGFloat       rightX;
@property (nonatomic) UIEdgeInsets  edge;
@property (nonatomic) CGFloat       width;
@property (nonatomic) CGFloat       height;
@property (nonatomic) CGFloat       centerX;
@property (nonatomic) CGFloat       centerY;
@property (nonatomic) CGPoint       origin;
@property (nonatomic) CGSize        size;


/**
 中心点的位移.

 @param point 给定的x y坐标的位移量.
 */
- (void)joViewMoveByPoint:(CGPoint)point;

/**
 对View的宽度按一定比例缩放.

 @param scale 缩放的比例.
 */
- (void)joViewScale:(CGFloat)scale;

/**
 让视图不失真的情况下在Size里面缩放.

 @param size 给定的Size.
 */
- (void)joSizeToFit:(CGSize)size;


@end
