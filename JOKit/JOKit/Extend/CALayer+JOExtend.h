//
//  CALayer+JOExtend.h
//  JOKit
//
//  Created by 刘维 on 16/9/29.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOMacro.h"

/*
struct CATransform3D
{
    CGFloat m11（x缩放）, m12（y切变）, m13（）, m14（）;
    CGFloat m21（x切变）, m22（y缩放）, m23（）, m24（）;
    CGFloat m31（）, m32（）, m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果.遵循现实中的情况,远离视点的小,近离视点的大）;
    CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
};
 */
static NSString *const kJOLayerKeyPathOpacity           = @"opacity";
static NSString *const kJOLayerKeyPathBackgoundColor    = @"backgroundColor";
static NSString *const kJOLayerKeyPathCornerRadius      = @"cornerRadius";
static NSString *const kJOLayerKeyPathBorderWidth       = @"borderWidth";
static NSString *const kJOLayerKeyPathBorderColor       = @"borderColor";
static NSString *const kJOLayerKeyPathPosition          = @"position";
static NSString *const kJOLayerKeyPathTransform         = @"transform";
static NSString *const kJOLayerKeyPathTranslation       = @"transform.translation";
static NSString *const kJOLayerKeyPathTranslationX      = @"transform.translation.x";
static NSString *const kJOLayerKeyPathTranslationY      = @"transform.translation.y";
static NSString *const kJOLayerKeyPathTranslationZ      = @"transform.translation.z";
static NSString *const kJOLayerKeyPathRotation          = @"transform.rotation";
static NSString *const kJOLayerKeyPathRotationX         = @"transform.rotation.x";
static NSString *const kJOLayerKeyPathRotationY         = @"transform.rotation.y";
static NSString *const kJOLayerKeyPathRotationZ         = @"transform.rotation.z";
static NSString *const kJOLayerKeyPathScale             = @"transform.scale";
static NSString *const kJOLayerKeyPathScaleX            = @"transform.scale.x";
static NSString *const kJOLayerKeyPathScaleY            = @"transform.scale.y";
static NSString *const kJOLayerKeyPathScaleZ            = @"transform.scale.z";
static NSString *const kJOLayerKeyPathBounds            = @"bounds";
static NSString *const kJOLayerKeyPathBoundsOrigin      = @"bounds.origin";
static NSString *const kJOLayerKeyPathBoundsSize        = @"bounds.size";

static NSString *const kJOShapeLayerKeyPathPath         = @"path";
static NSString *const kJOShapeLayerKeyPathFillColor    = @"fillColor";
static NSString *const kJOShapeLayerKeyPathStrokeColor  = @"strokeColor";
static NSString *const kJOShapeLayerKeyPathLineWidth    = @"lineWidth";

static NSString *const kJOGradientLayerKeyPathColors    = @"colors";
static NSString *const kJOGradientLayerKeyPathLocations = @"locations";
static NSString *const kJOGradientLayerKeyPathStartPoint= @"startPoint";
static NSString *const kJOGradientLayerKeyPathEndPoint  = @"endPoint";


/**
 动画的代理的Block,只会在动画开始跟结束才会调用.

 @param layer       执行动画的layer.
 @param anim        动画.
 @param finishState YES:则代表动画结束,NO:则代表动画开始.
 */
typedef void(^JOAnimationDelegateBlock) (CALayer *layer, CAAnimation *animation, BOOL finishState);

/**
 动画配置的会调用,用来给动画设置一些其他的属性.
 e.g:需要设置动画的fillMode: animation.removedOnCompletion = NO; animation.fillMode = kCAFillModeRemoved;
     需要设置动画延迟多久执行: animation.beginTime = CACurrentMediaTime() + 延迟的时间;
     需要设置动画的时间函数: animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
 
    kCAFillModeRemoved : Default样式 动画结束后会回到layer的开始的状态
    kCAFillModeForwards : 动画结束后,layer会保持结束状态
    kCAFillModeBackwards : layer会立即跳到fromValue的值处,然后从fromValue到toValue执行动画,最后回到layer的开始的状态
    kCAFillModeBoth : kCAFillModeForwards和kCAFillModeBackwards的结合,即动画结束后layer保持在结束状态

 @param layer 操作的layer.
 @param anim  动画.
 */
typedef void(^JOAnimationBlock) (CALayer *layer, CAAnimation *animation);

@interface CALayer(JOExtend)

#pragma mark  - CABasicAnimation
#pragma mark  -

/**
 给layer增加一个动画. 很多属性其他属性在animationBlock中去设置.

 @param keyPath         对应需要操作动画的属性。
 @param fromValue       最开始的值.
 @param toValue         需要到达的值.
 @param duration        持续的时间.
 @param repeatCount     重复的次数. 0为无限次.
 @param animationBlock  动画的block.
 @param block           动画的代理的block.
 */
- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                          fromValue:(id)fromValue
                            toValue:(id)toValue
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount
                     animationBlock:(JOAnimationBlock)animationBlock
             animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock;

- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                          fromValue:(id)fromValue
                            toValue:(id)toValue
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount;

#pragma mark  - CAKeyframeAnimation
#pragma mark  -


/**
 给layer增加一个给定path路径的动画.

 @param keyPath        对应需要操作动画的属性。 默认为postion的
 @param path           路径的path.
 @param duration       持续的时间.
 @param repeatCount    重复的次数. 0为一直循环下去.
 @param animationBlock JOAnimationBlock
 @param delegateBlock  JOAnimationDelegateBlock
 */
- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                               path:(CGPathRef)path
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount
                     animationBlock:(JOAnimationBlock)animationBlock
             animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock;

- (void)joLayerAnimationWithPath:(CGPathRef)path
                        duration:(NSTimeInterval)duration
                     repeatCount:(CGFloat)repeatCount
                  animationBlock:(JOAnimationBlock)animationBlock
          animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock;

- (void)joLayerAnimationWithPath:(CGPathRef)path
                        duration:(NSTimeInterval)duration
                     repeatCount:(CGFloat)repeatCount;

/**
 给某个layer的属性加一个动画. 动画的时间函数为线性的.

 @param kayPath         对应的属性.
 @param values          一系列的值的数组.
 @param duration        持续时间.
 @param repeatCount     重复次数.   0代表一直重复.
 @param timingFunctions 动画速度时间的函数. 默认为liner的
 @param animaionBlock   动画的代理的Block回调.
 */
- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                             values:(NSArray *)values
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount
                     animationBlock:(JOAnimationBlock)animationBlock
             animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock;

- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                             values:(NSArray *)values
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount;

//对背景颜色加一个动画. Array里面的对象为CGColorRef 请使用(__bridge id)进行转换再存入数组
- (void)joLayerAnimationWithBackgoundColors:(NSArray *)colors
                                   duration:(NSTimeInterval)duration
                                repeatCount:(CGFloat)repeatCount;

//对位置加一个动画. Array里面的对象为CGPoint的NSValue的对象.
- (void)joLayerAnimationWithPositions:(NSArray <NSValue *>*)positions
                             duration:(NSTimeInterval)duration
                          repeatCount:(CGFloat)repeatCount;

//对变化加一个动画. Array里面的对象为CATransform3D的NSValue的对象.
- (void)joLayerAnimationWithTransforms:(NSArray <NSValue *>*)transforms
                              duration:(NSTimeInterval)duration
                           repeatCount:(CGFloat)repeatCount;

//对位移加一个动画. Array里面的对象为CGpoint的NSValue的对象.
- (void)joLayerAnimationWithTranslations:(NSArray <NSValue *>*)translations
                                duration:(NSTimeInterval)duration
                             repeatCount:(CGFloat)repeatCount;

//对旋转加一个动画. Array里面的对象为角度的NSValue的对象.(转换为M_PI)
- (void)joLayerAnimationWithRotations:(NSArray <NSValue *>*)rotations
                             duration:(NSTimeInterval)duration
                          repeatCount:(CGFloat)repeatCount;

//对缩放加一个动画. Array里面的对象为缩放比例的NSValue的对象.
- (void)joLayerAnimationWithScales:(NSArray <NSValue *>*)scales
                          duration:(NSTimeInterval)duration
                       repeatCount:(CGFloat)repeatCount;

#pragma mark - CAAnimationGroup
#pragma mark -

/**
 执行一组动画.

 @param animationArray 动画的数组.
 @param duration       持续时间.
 @param repeatCount    重复的次数. 0为一直循环.
 @param animationBlock JOAnimationBlock.
 @param delegateBlock  JOAnimationDelegateBlock.
 */
- (void)joLayerAnimationWithArray:(NSArray <CAAnimation *>*)animationArray
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                   animationBlock:(JOAnimationBlock)animationBlock
           animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock;

- (void)joLayerAnimationWithArray:(NSArray <CAAnimation *>*)animationArray
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount;

#pragma mark - CASpringAnimation
#pragma mark -

/**
 执行一个弹簧性质的动画.为给定动画的持续时间:是因为这个最好是按其提供的结算时间(settlingDuration)去设置.

 @param keyPath        对应的属性.
 @param fromValue      初始值.
 @param toValue        到达的值.
 @param mass           质量. 默认值为1（影响弹簧的惯性，质量越大，弹簧惯性越大，运动的幅度越大）
 @param stiffness      弹性系数. 默认值为100（弹性系数越大，弹簧的运动越快）
 @param damping        阻尼系数. 默认值为10（阻尼系数越大，弹簧的停止越快)
 @param velocity       初始速率. 默认值为0（弹簧动画的初始速度大小，弹簧运动的初始方向与初始速率的正负一致，若初始速率为0，表示忽略该属性）
 @param animationBlock JOAnimationBlock
 @param delegateBlock  JOAnimationDelegateBlock
 */
- (void)joLayerSpringAnimationWithKeyPath:(NSString *)keyPath
                                fromValue:(id)fromValue
                                  toValue:(id)toValue
                                     mass:(CGFloat)mass
                                stiffness:(CGFloat)stiffness
                                  damping:(CGFloat)damping
                            startVelocity:(CGFloat)velocity
                           animationBlock:(JOAnimationBlock)animationBlock
                   animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock;

- (void)joLayerSpringAnimationWithKeyPath:(NSString *)keyPath
                                fromValue:(id)fromValue
                                  toValue:(id)toValue
                                     mass:(CGFloat)mass
                                stiffness:(CGFloat)stiffness
                                  damping:(CGFloat)damping
                            startVelocity:(CGFloat)velocity;
@end

#pragma mark - CAShapeLayer 的规则多边形
#pragma mark - 

@interface CAShapeLayer(JORegularPolygonalExtend)

/**
 生成规则的多边形.

 @param polygonals 需要生成的变数.
 */
- (void)joShapeLayerWithPolygonals:(NSInteger)polygonals;

@end
