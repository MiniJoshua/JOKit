//
//  CALayer+JOExtend.m
//  JOKit
//
//  Created by 刘维 on 16/9/29.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "CALayer+JOExtend.h"

static NSString *const kJOAnimationValueKey = @"kJOAnimationValueKey";
static NSString *const kJOAnimationGroupKey = @"kJOAnimationGroupKey";

@interface CALayer()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableDictionary *animationBlockDic;

@end

@implementation CALayer(JOExtend)

JO_DYNAMIC_PROPERTY_OBJECT(animationBlockDic,setAnimationBlockDic,RETAIN,NSMutableDictionary *);

- (void)addBlockToDicWithKey:(NSString *)key block:(JOAnimationDelegateBlock)block {

    if (!self.animationBlockDic) {
        self.animationBlockDic = [NSMutableDictionary dictionary];
    }
    
    if (block) {
        [self.animationBlockDic setObject:block forKey:key];
    } 
}

- (JOAnimationDelegateBlock)blockWithKey:(NSString *)key {
    return [self.animationBlockDic objectForKey:key];
}

#define JOAnimationSetup \
[animation setValue:keyPath forKey:kJOAnimationValueKey]; \
animation.duration = duration; \
animation.delegate = self; \
if (animationBlock) { \
animationBlock(self,animation); \
} \
if (repeatCount == 0.) { \
    animation.repeatCount = INFINITY; \
}else { \
    animation.repeatCount = repeatCount; \
} \


#pragma mark  - CABasicAnimation
#pragma mark  -

- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                          fromValue:(id)fromValue
                            toValue:(id)toValue
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount
                     animationBlock:(JOAnimationBlock)animationBlock
             animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock {
    
    [self addBlockToDicWithKey:keyPath block:delegateBlock];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    JOAnimationSetup;
    [self addAnimation:animation forKey:nil];
}

- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                          fromValue:(id)fromValue
                            toValue:(id)toValue
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

#pragma mark  - CAKeyframeAnimation
#pragma mark  -

- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                               path:(CGPathRef)path
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount
                     animationBlock:(JOAnimationBlock)animationBlock
             animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock {

    [self addBlockToDicWithKey:keyPath block:delegateBlock];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.path = path;
    JOAnimationSetup;
    [self addAnimation:animation forKey:nil];
}

- (void)joLayerAnimationWithPath:(CGPathRef)path
                        duration:(NSTimeInterval)duration
                     repeatCount:(CGFloat)repeatCount
                  animationBlock:(JOAnimationBlock)animationBlock
          animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock {

    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathPosition
                                 path:path
                             duration:duration
                          repeatCount:repeatCount
                       animationBlock:animationBlock
               animationDelegateBlock:delegateBlock];
}

- (void)joLayerAnimationWithPath:(CGPathRef)path
                        duration:(NSTimeInterval)duration
                     repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathPosition
                                 path:path
                             duration:duration
                          repeatCount:repeatCount
                       animationBlock:nil
               animationDelegateBlock:nil];
}

- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                             values:(NSArray *)values
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount
                     animationBlock:(JOAnimationBlock)animationBlock
             animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock {

    [self addBlockToDicWithKey:keyPath block:delegateBlock];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 0.005; // 透视效果 远的小 近的大
    [self setTransform:transform];
    [self setZPosition:80.];//为了查看完整的旋转效果视图
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.values = values;
    JOAnimationSetup;
    [self addAnimation:animation forKey:nil];
}

- (void)joLayerAnimationWithKeyPath:(NSString *)keyPath
                             values:(NSArray *)values
                           duration:(NSTimeInterval)duration
                        repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:keyPath values:values duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

- (void)joLayerAnimationWithBackgoundColors:(NSArray *)colors duration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathBackgoundColor values:colors duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

- (void)joLayerAnimationWithPositions:(NSArray <NSValue *>*)positions duration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathPosition values:positions duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

- (void)joLayerAnimationWithTransforms:(NSArray <NSValue *>*)transforms duration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathTransform values:transforms duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

- (void)joLayerAnimationWithTranslations:(NSArray <NSValue *>*)translations duration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathTranslation values:translations duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

- (void)joLayerAnimationWithRotations:(NSArray <NSValue *>*)rotations duration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathRotation values:rotations duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

- (void)joLayerAnimationWithScales:(NSArray <NSValue *>*)scales duration:(NSTimeInterval)duration repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithKeyPath:kJOLayerKeyPathScale values:scales duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

#undef JOAnimationSetup

#pragma mark - CAAnimationGroup
#pragma mark -

- (void)joLayerAnimationWithArray:(NSArray <CAAnimation *>*)animationArray
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                   animationBlock:(JOAnimationBlock)animationBlock
           animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock {

    [self addBlockToDicWithKey:kJOAnimationGroupKey block:delegateBlock];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setValue:kJOAnimationGroupKey forKey:kJOAnimationValueKey];
    animationGroup.animations = animationArray;
    animationGroup.duration = duration;
    animationGroup.delegate = self;
    if (repeatCount == 0.) {
        animationGroup.repeatCount = INFINITY;
    }else {
        animationGroup.repeatCount = repeatCount;
    }
    if (animationBlock) {
        animationBlock(self,animationGroup);
    }
    [self addAnimation:animationGroup forKey:nil];
}

- (void)joLayerAnimationWithArray:(NSArray <CAAnimation *>*)animationArray
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount {
    [self joLayerAnimationWithArray:animationArray duration:duration repeatCount:repeatCount animationBlock:nil animationDelegateBlock:nil];
}

#pragma mark - CASpringAnimation
#pragma mark -

- (void)joLayerSpringAnimationWithKeyPath:(NSString *)keyPath
                                fromValue:(id)fromValue
                                  toValue:(id)toValue
                                     mass:(CGFloat)mass
                                stiffness:(CGFloat)stiffness
                                  damping:(CGFloat)damping
                            startVelocity:(CGFloat)velocity
                           animationBlock:(JOAnimationBlock)animationBlock
                   animationDelegateBlock:(JOAnimationDelegateBlock)delegateBlock {
    
    [self addBlockToDicWithKey:keyPath block:delegateBlock];
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:keyPath];
    [springAnimation setValue:keyPath forKey:kJOAnimationValueKey];
    springAnimation.fromValue = fromValue;
    springAnimation.toValue = toValue;
    springAnimation.mass = mass;
    springAnimation.stiffness = stiffness;
    springAnimation.damping = damping;
    springAnimation.initialVelocity = velocity;
    springAnimation.duration = springAnimation.settlingDuration;
    springAnimation.delegate = self;
    if (animationBlock) {
        animationBlock(self,springAnimation);
    }
    [self addAnimation:springAnimation forKey:nil];
}

- (void)joLayerSpringAnimationWithKeyPath:(NSString *)keyPath
                                fromValue:(id)fromValue
                                  toValue:(id)toValue
                                     mass:(CGFloat)mass
                                stiffness:(CGFloat)stiffness
                                  damping:(CGFloat)damping
                            startVelocity:(CGFloat)velocity {
    
    [self joLayerSpringAnimationWithKeyPath:keyPath
                                  fromValue:fromValue
                                    toValue:toValue
                                       mass:mass
                                  stiffness:stiffness
                                    damping:damping
                              startVelocity:velocity
                             animationBlock:nil
                     animationDelegateBlock:nil];
}

#pragma mark - Animation Delegate
#pragma mark -

- (void)animationDidStart:(CAAnimation *)anim {
    
    JOAnimationDelegateBlock block = [self blockWithKey:[anim valueForKey:kJOAnimationValueKey]];
    if (block) {
        block(self,anim,NO);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    JOAnimationDelegateBlock block = [self blockWithKey:[anim valueForKey:kJOAnimationValueKey]];
    if (block && flag) {
        block(self,anim,YES);
    }
}

@end

@implementation CAShapeLayer(JORegularPolygonalExtend)

- (void)joShapeLayerWithPolygonals:(NSInteger)polygonals oddEven:(BOOL)oddEven{
    
    if (polygonals > 2) {
        
        UIBezierPath *shaperPath = [UIBezierPath bezierPath];
        
        CGFloat angle = 2*M_PI/polygonals;
        CGFloat startAngle = -M_PI/2.;
        
        if (oddEven) {
            BOOL oddState = polygonals%2;
            if (!oddState) {
                startAngle = -M_PI/2. - angle/2.;
            }
        }else {
            
            startAngle = -M_PI/2.;
        }
        
        NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:polygonals];
        for (int i = 0; i < polygonals; i++) {
            
            CAShapeLayer *tempLayer = [CAShapeLayer layer];
            [tempLayer setFrame:CGRectMake(0., 0., 4., 4.)];
            [self addSublayer:tempLayer];
            
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2., self.frame.size.height/2.) radius:MIN(self.frame.size.width/2., self.frame.size.height/2.) startAngle:startAngle-0.01 endAngle:startAngle clockwise:YES];
            
            startAngle += angle;
            
            [tempLayer joLayerAnimationWithPath:path.CGPath duration:0.0001 repeatCount:1 animationBlock:^(CALayer *layer, CAAnimation *animation) {
                animation.removedOnCompletion = NO;
                animation.fillMode = kCAFillModeBoth;
            } animationDelegateBlock:^(CALayer *layer, CAAnimation *animation, BOOL finishState) {
                if (finishState) {
                    
                    [pointArray addObject:[tempLayer.presentationLayer valueForKeyPath:@"position"]];

                    if ([pointArray count] == polygonals) {
                        for (int i = 0 ; i < polygonals ; i++) {
                            
                            if (i == 0) {
                                [shaperPath moveToPoint:[[pointArray objectAtIndex:0] CGPointValue]];
                            }else {
                                [shaperPath addLineToPoint:[[pointArray objectAtIndex:i] CGPointValue]];
                            }
                        }
                        [shaperPath addLineToPoint:[[pointArray objectAtIndex:0] CGPointValue]];
                        [self setPath:shaperPath.CGPath];
                    }
                }
            }];
        }
    }else {
        JOThrowException(@"CAShapeLayer exception", @"joShapeLayerWithPolygonalCount: 多边形最小值应为3");
    }
}

@end
