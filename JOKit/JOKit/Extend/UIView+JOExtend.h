//
//  UIView+JOExtend.h
//  JOProjectBaseSDK
//
//  Created by 刘维 on 16/6/23.
//  Copyright © 2016年 刘维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOMacro.h"

#define JOClangWarningConcat(warning_name) JOArgToCharStr(clang diagnostic ignored warning_name)
#define JOBeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(JOClangWarningConcat(#warningName))

#define JOEndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define JOIgnoreRetainCycles JOBeginIgnoreClangWarning(-Warc-retain-cycles)

/*
 不会发生循环引用的情况
 该宏用来忽略掉有循环引用警告的布局
 */
#ifndef JOAtuoLayout
#define JOAtuoLayout(_layout_) \
^(UIView *view) { \
JOIgnoreRetainCycles \
view._layout_; \
JOEndIgnoreClangWarning \
}
#endif

@interface UIView(JOExtend)

@property (nonatomic, copy) JOArgcBlock layoutBlock;

/**
 创建一个自动使用autolayout功能的对象.
 可以将布局的代码写在block里面,他将会在addSubview之后调用执行

 @param layoutBlock 带被add的view参数的Block
 @return 带有autolayout的对象
 */
+ (instancetype)newAutoLayout:(void(^)(UIView *view))layoutBlock;

/**
 创建一个自动使用autolayout功能的对象.
 
 @return - 带有autolayout的对象.
 */
+ (instancetype)newAutoLayoutView;

/**
 @see 跟+ (instancetype)newAutoLayout：(void(^)(UIView *view))layoutBlock功能一样.
 */
- (instancetype)initWithAutoLayout:(void(^)(UIView *view))layoutBlock;

/**
 @see 跟+ (instancetype)newAutoLayoutView功能一样.
 */
- (instancetype)initAutoLayout;

/**
 当某些UI类不能直接使用上面提供的功能直接生成的时候,那么可以调用该方法去添加布局
 PS:一定要在视图被add前调用该方法,否则无效果.
    会将视图设置成为支持自动布局的模式:translatesAutoresizingMaskIntoConstraints = NO.

 @param layoutBlock 带被add的view参数的Block
 */
- (void)addAutoLayout:(void(^)(UIView *view))layoutBlock;

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

/**
 给视图View增加毛玻璃的效果.

 @param style 模糊的样式.
 */
- (void)joViewBlurWithEffectStyle:(UIBlurEffectStyle)style;

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

@interface UIView(JOMotionEffectExtend)

//@property (nonatomic, strong, readonly) UIMotionEffectGroup *motionEffectGroup;

/**
 添加X轴跟Y轴上面的位移距离使其达到动态展现的效果.

 @param offsetX X轴的位移距离.
 @param offsetY Y轴的位移距离.
 */
- (void)joAddMotionEffectWithXAxisOffset:(CGFloat)offsetX YAxisOffset:(CGFloat)offsetY;

/**
 移除动态展现的效果.
 */
- (void)joRemoveMotionEffectExtend;

@end

typedef NS_ENUM(NSUInteger, JOAnimation){
    
    JOAnimationFade,                    //淡入淡出
    JOAnimationPush,                    //推入
    JOAnimationReveal,                  //揭开
    JOAnimationMoveIn,                  //覆盖
    JOAnimationCube,                    //立方体的效果
    JOAnimationOglFlip,                 //翻转
    JOAnimationSuckEffect,              //吸收
    JOAnimationRippleEffect,            //波纹
    JOAnimationPageCurl,                //翻页
    JOAnimationUnPageCurl,              //反翻页
    JOAnimationCameraIrisHollowOpen,    //镜头打开的效果
    JOAnimationCameraIrisHollowClose,   //镜头关闭的效果
    JOAnimationCurlDown,                //下翻页
    JOAnimationCurlUp,                  //上翻页
    JOAnimationFlipFromLeft,            //左翻转
    JOAnimationFlipFromRight,           //右翻转
};

typedef NS_ENUM(NSUInteger, JODirection) {
    
    JODirectionLeft,
    JODirectionRight,
    JODirectionTop,
    JODirectionBottom,
};

typedef NS_ENUM(NSUInteger, JOAnimationCurve) {
    JOAnimationCurveEaseInOut,
    JOAnimationCurveEaseIn,
    JOAnimationCurveEaseOut,
    JOAnimationCurveLinear,
};

@interface UIView(JOAnimationExtend)

/**
 执行一个系统提供的动画.

 @param duration      动画的时长. 默认的时长:0.5s.
 @param animation 动画的类型. 具体的动画类型参考JOAnimation.
 @param direction 动画的方向. e.g:MoveIn的动画是从左进入的还是从右进入的...  默认的方向是:从左进入 JODirectionLeft
 @param animationCurve 线性的函数. 默认:UIViewAnimationOptionCurveEaseInOut
 */
- (void)joAnimationWithDuration:(NSTimeInterval)duration
                      animation:(JOAnimation)animation
                      direction:(JODirection)direction
                 animationCurve:(JOAnimationCurve)animationCurve;
- (void)joAnimationWithDuration:(NSTimeInterval)duration
                      animation:(JOAnimation)animation
                      direction:(JODirection)direction;
- (void)joAnimationWithDuration:(NSTimeInterval)duration animation:(JOAnimation)animation;
- (void)joAnimationWithAnimation:(JOAnimation)animation;


@end
