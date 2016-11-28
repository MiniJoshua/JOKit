//
//  JOLodingView.m
//  JOKit
//
//  Created by 刘维 on 16/10/12.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOLoadingView.h"
#import "JOKit.h"

#pragma mark - JOTraceCircleBallLoadingView
#pragma mark -

@interface JOTraceCircleBallLoadingView : JOLoadingView

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@property (nonatomic, strong) CALayer *circleLayer;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIBezierPath *animationPath;
@property (nonatomic, strong) JOCircleBallLoadingItem *item;

@end

@implementation JOTraceCircleBallLoadingView

- (void)dealloc {

    [_displayLink invalidate];
    self.displayLink = nil;
}

- (JO_INSTANCETYPE)initWithItemBlock:(JOLoadingBlock)itemBlock {
    
    self = [super init];
    if (self) {
        self.replicatorLayer = [CAReplicatorLayer layer];
        [self.layer addSublayer:_replicatorLayer];
        
        self.item = [JOCircleBallLoadingItem new];
        _item.ballCount = 5;
        _item.startColor = JORGBAMake(255., 255., 255., 1.);
        _item.endColor = JORGBAMake(100., 100., 100., 0.4);
        _item.intervalTime = 0.12;
        _item.ballRadius = 5.;
        _item.animationDuration = 1.5;
        _item.animationIntervalTime = 1.833;
        
        if (itemBlock) {
            itemBlock(_item);
        }
        
        [_replicatorLayer setInstanceCount:_item.ballCount];
        [_replicatorLayer setInstanceColor:_item.startColor.CGColor];
        JORGB startRGBA = [_item.startColor joColorToJORGB];
        JORGB endRGBA = [_item.endColor joColorToJORGB];
        CGFloat redReduce = (endRGBA.r - startRGBA.r)/_item.ballCount;
        CGFloat greenReduce = (endRGBA.g - startRGBA.g)/_item.ballCount;
        CGFloat blueReduce = (endRGBA.b - startRGBA.b)/_item.ballCount;
        CGFloat alphaReduce = (endRGBA.a - startRGBA.a)/_item.ballCount;
        [_replicatorLayer setInstanceRedOffset:+redReduce];
        [_replicatorLayer setInstanceGreenOffset:+greenReduce];
        [_replicatorLayer setInstanceBlueOffset:+blueReduce];
        [_replicatorLayer setInstanceAlphaOffset:+alphaReduce];
        [_replicatorLayer setInstanceDelay:_item.intervalTime];
        
        self.circleLayer = [CALayer layer];
        [_circleLayer setBackgroundColor:[UIColor whiteColor].CGColor];
        [_circleLayer setFrame:CGRectMake(0., 0., _item.ballRadius*2., _item.ballRadius*2.)];
        [_circleLayer setCornerRadius:_item.ballRadius];
        [_replicatorLayer addSublayer:_circleLayer];
        
//        [self startLoadingAnimation];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startLoadingAnimation)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setFrameInterval:_item.animationIntervalTime*60.];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_replicatorLayer setFrame:self.bounds];
    self.animationPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
//    [self startLoadingAnimation];
}

- (void)startLoadingAnimation {
    
    [_circleLayer joLayerAnimationWithPath:_animationPath.CGPath
                                  duration:_item.animationDuration
                               repeatCount:1
                            animationBlock:^(CALayer *layer, CAAnimation *animation) {
                                animation.removedOnCompletion = NO;
                                animation.fillMode = kCAFillModeBoth;
//                                animation.autoreverses = YES;
                            }
                    animationDelegateBlock:^(CALayer *layer, CAAnimation *animation, BOOL finishState) {
//                        [layer setHidden:finishState];
                    }];
}

@end

#pragma mark - JOCricleDrawLineLodingView
#pragma mark -

@interface JOCricleDrawLineLodingView : JOLoadingView

@property (nonatomic, assign) CGFloat lineCount;

@property (nonatomic, strong) CAShapeLayer *circleOne;
@property (nonatomic, strong) CAShapeLayer *circleTwo;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *lineShapeLayer;
@property (nonatomic, strong) UIBezierPath *linePath;

@property (nonatomic, strong) JOCircleLineDrawLoadingItem *item;

@end

@implementation JOCricleDrawLineLodingView

- (void)dealloc {
    
    [_displayLink invalidate];
    self.displayLink = nil;
}

- (JO_INSTANCETYPE)initWithItemBlock:(JOLoadingBlock)itemBlock {
    
    self = [super init];
    if (self) {
    
        self.item = [JOCircleLineDrawLoadingItem new];
        _item.maxLineCount = 250;
        _item.lineWidth = 1.;
        _item.lineColor = [UIColor whiteColor];
        _item.ballOneRadius = 3.;
        _item.ballTwoRadius = 3.;
        _item.ballOneColor = [UIColor whiteColor];
        _item.ballTwoColor = [UIColor whiteColor];
        _item.ballOneDuration = 2.;
        _item.ballTwoDuration = 12.;
        _item.drawLineIntervalTime = 0.05;
        
        if (itemBlock) {
            itemBlock(_item);
        }
        
        self.circleOne = [CAShapeLayer layer];
        [_circleOne setFrame:CGRectMake(0., 0., _item.ballOneRadius*2., _item.ballOneRadius*2.)];
        [_circleOne setFillColor:_item.ballOneColor.CGColor];
        [_circleOne setPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0., 0., _item.ballOneRadius*2., _item.ballOneRadius*2.)].CGPath];
        [self.layer addSublayer:_circleOne];
        
        self.circleTwo = [CAShapeLayer layer];
        [_circleTwo setFrame:CGRectMake(0., 0., _item.ballTwoRadius*2., _item.ballTwoRadius*2.)];
        [_circleTwo setFillColor:_item.ballTwoColor.CGColor];
        [_circleTwo setPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0., 0., _item.ballTwoRadius*2., _item.ballTwoRadius*2.)].CGPath];
        [self.layer addSublayer:_circleTwo];
        
        self.lineShapeLayer = [CAShapeLayer layer];
        [_lineShapeLayer setStrokeColor:_item.lineColor.CGColor];
        [_lineShapeLayer setLineWidth:_item.lineWidth];
        [self.layer addSublayer:_lineShapeLayer];
        
        self.linePath = [UIBezierPath bezierPath];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawLine)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setFrameInterval:_item.drawLineIntervalTime*60.];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_lineShapeLayer setFrame:self.bounds];
    
    _lineCount = 0;
    [_linePath removeAllPoints];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2., self.frame.size.height/2.) radius:self.frame.size.width/2. startAngle:0 endAngle:2*M_PI clockwise:YES];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2., self.frame.size.height/2.) radius:self.frame.size.width/2. startAngle:M_PI endAngle:3*M_PI clockwise:YES];

    [_circleOne joLayerAnimationWithPath:path.CGPath duration:_item.ballOneDuration repeatCount:0.];
    [_circleTwo joLayerAnimationWithPath:path1.CGPath duration:_item.ballTwoDuration repeatCount:0.];
}

- (void)drawLine {

    CGPoint startPoint  = [[_circleOne.presentationLayer valueForKeyPath:@"position"] CGPointValue];
    CGPoint endPoint    = [[_circleTwo.presentationLayer valueForKeyPath:@"position"] CGPointValue];
    
    _lineCount ++;
    
    if (_lineCount > _item.maxLineCount) {
        _lineCount = 0;
        [_linePath removeAllPoints];
    }
    
    [_linePath moveToPoint:startPoint];
    [_linePath addLineToPoint:endPoint];
    [_lineShapeLayer setPath:_linePath.CGPath];
}

@end

#pragma mark - JOSixPolygonalsLoadingView
#pragma mark -

static const NSInteger kPolygonalsCount = 7;

@interface JOSixPolygonalsLoadingView : JOLoadingView

@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) JOSixPolygonalsLoadingItem *item;
@property (nonatomic, assign) BOOL showState;

@end

@implementation JOSixPolygonalsLoadingView

- (void)dealloc {
    
    [_displayLink invalidate];
    self.displayLink = nil;
}

- (JO_INSTANCETYPE)initWithItemBlock:(JOLoadingBlock)itemBlock {
    
    self = [super init];
    if (self) {
        
        _showState = NO;
        self.layers = [NSMutableArray arrayWithCapacity:kPolygonalsCount];
        
        self.item = [JOSixPolygonalsLoadingItem new];
        _item.polygonalColor = JORGBAMake(150., 150., 150., 1.);
        _item.polygonalBorderColor = [UIColor clearColor];
        _item.polygonalBorderWidth = 1.;
        _item.duration = 4.;
        _item.offset = 0.;
        _item.softState = YES;
        
        if (itemBlock) {
            itemBlock(_item);
        }
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startLoadingAnimation)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setFrameInterval:_item.duration*30.+10];
    }
    return self;
}

- (void)startLoadingAnimation{

    for (int i = 0; i < [_layers count]; i++) {
        
        CAShapeLayer *shapeLayer = [_layers objectAtIndex:i];
        
        NSValue *fromValue;
        NSValue *toValue;
        NSValue *fromValue1;
        NSValue *toValue1;
        
        if (_showState) {
            fromValue = @(1);
            toValue = @(0);
            fromValue1 = @(1);
            toValue1 = @(0.3);
        }else {
            fromValue = @(0);
            toValue = @(1);
            fromValue1 = @(0.3);
            toValue1 = @(1.);
        }
        
        CGFloat duration = _item.duration/(kPolygonalsCount*2.);
        if (_item.softState) {
            duration =_item.duration/kPolygonalsCount;
        }
        [shapeLayer joLayerAnimationWithKeyPath:kJOLayerKeyPathOpacity fromValue:fromValue toValue:toValue duration:duration repeatCount:1 animationBlock:^(CALayer *layer, CAAnimation *animation) {
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeBoth;
            animation.beginTime = CACurrentMediaTime() + _item.duration/(kPolygonalsCount*2)*i;
        } animationDelegateBlock:nil];
        
        [shapeLayer joLayerAnimationWithKeyPath:kJOLayerKeyPathScale fromValue:fromValue1 toValue:toValue1 duration:duration repeatCount:1 animationBlock:^(CALayer *layer, CAAnimation *animation) {
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeBoth;
            animation.beginTime = CACurrentMediaTime() + _item.duration/(kPolygonalsCount*2)*i;
        } animationDelegateBlock:nil];
    }
    
    _showState? (_showState = NO):(_showState = YES);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (![_layers count] ) {
        
        CGFloat width = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        for (int i = 0; i< kPolygonalsCount; i++) {
            
            CAShapeLayer *polygonalShapeLayer = [CAShapeLayer layer];
            [polygonalShapeLayer setFillColor:_item.polygonalColor.CGColor];
            [polygonalShapeLayer setStrokeColor:_item.polygonalBorderColor.CGColor];
            [polygonalShapeLayer setLineWidth:_item.polygonalBorderWidth];
            [self.layer addSublayer:polygonalShapeLayer];
            
            CGPoint center = JORectCenter(self.bounds);
            [polygonalShapeLayer setFrame:CGRectMake(center.x - width/6., center.y - width/6., width/3., width/3.)];
            [polygonalShapeLayer joShapeLayerWithPolygonals:kPolygonalsCount-1 oddEven:NO];
            
            CGFloat xOffset = 0;
            CGFloat yOffset = 0;
            if (_item.offset >= 0) {
                
                xOffset = yOffset = _item.offset;
            }else {
            
                yOffset = _item.offset;
                xOffset = 0.;
            }
            
            if (i == 0) {
                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(-width/6.-xOffset, -width/3.-yOffset, 0)];
                //[polygonalShapeLayer setTransform:CATransform3DMakeTranslation(0., -width/3.-yOffset, 0)];
            }else if (i == 1) {
                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(width/6.+xOffset, -width/3.-yOffset, 0)];
//                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(width/3.+xOffset, -width/6.-yOffset, 0)];
            }else if (i == 2) {
                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(width/3.+xOffset, 0., 0)];
                //[polygonalShapeLayer setTransform:CATransform3DMakeTranslation(width/3.+xOffset, width/6.+yOffset, 0)];
            }else if (i == 3) {
                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(width/6.+xOffset, width/3.+yOffset, 0)];
                //[polygonalShapeLayer setTransform:CATransform3DMakeTranslation(0., width/3.+xOffset, 0)];
            }else if (i == 4) {
                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(-width/6.-xOffset, width/3.+yOffset, 0)];
//                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(-width/3.-xOffset, width/6.+yOffset, 0)];
            }else if (i == 5) {
                //[polygonalShapeLayer setTransform:CATransform3DMakeTranslation(-width/3.-xOffset, -width/6.-yOffset, 0)];
                [polygonalShapeLayer setTransform:CATransform3DMakeTranslation(-width/3.-xOffset, 0., 0)];
            }
            [_layers addObject:polygonalShapeLayer];
        }
    }
}

@end

#pragma mark - JOCircleLineLoadingView
#pragma mark -

@interface JOCircleLineLoadingView : JOLoadingView

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) JOCircleLineLoadingItem *item;

@end

@implementation JOCircleLineLoadingView

- (JO_INSTANCETYPE)initWithItemBlock:(JOLoadingBlock)itemBlock {
    
    self = [super init];
    if (self) {
        
        self.item = [JOCircleLineLoadingItem new];
        _item.lineWidth = 8.;
        _item.colors = @[(__bridge id)[UIColor grayColor].CGColor,(__bridge id)[UIColor grayColor].CGColor];
        _item.locations = @[@(0.),@(1.)];
        _item.duration = 2.;
        _item.startPoint = CGPointMake(0.0, 0.0);
        _item.endPoint = CGPointMake(1., 1.);
        
        if (itemBlock) {
            itemBlock(_item);
        }
        self.gradientLayer = [CAGradientLayer layer];
        
        [_gradientLayer setStartPoint:_item.startPoint];
        [_gradientLayer setEndPoint:_item.endPoint];
        [_gradientLayer setColors:_item.colors];
        [_gradientLayer setLocations:_item.locations];
        [self.layer addSublayer:_gradientLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        [_shapeLayer setLineWidth:_item.lineWidth];
        [_shapeLayer setStrokeColor:[UIColor whiteColor].CGColor];
        [_shapeLayer setFillColor:[UIColor clearColor].CGColor];
        [_shapeLayer setLineCap:kCALineJoinRound];
        [_gradientLayer setMask:_shapeLayer];
        
        [self startLoadingAnimation];
    }
    return self;
}

- (void)startLoadingAnimation {

    @weakify(self);
    [_shapeLayer joLayerAnimationWithKeyPath:kJOShapeLayerKeyPathStrokeEnd fromValue:@(0.) toValue:@(1.) duration:_item.duration/2. repeatCount:1. animationBlock:nil animationDelegateBlock:^(CALayer *layer, CAAnimation *animation, BOOL finishState) {
        @strongify(self);
        if (finishState) {
            [self.shapeLayer joLayerAnimationWithKeyPath:kJOShapeLayerKeyPathStrokeStart fromValue:@(0) toValue:@(1) duration:_item.duration/2. repeatCount:1 animationBlock:nil animationDelegateBlock:^(CALayer *layer, CAAnimation *animation, BOOL finishState) {
                if (finishState) {
                    [self startLoadingAnimation];
                }
            }];
        }
    }];
}

- (void)layoutSubviews {

    [super layoutSubviews];

    [_gradientLayer setFrame:self.bounds];
    [_shapeLayer setFrame:self.bounds];
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:JORectCenter(self.bounds) radius:MIN(self.bounds.size.width/2., self.bounds.size.height/2.)-_item.lineWidth startAngle:-M_PI/2.-_item.angle endAngle:-M_PI/2. clockwise:YES];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:JORectCenter(self.bounds) radius:MIN(self.bounds.size.width/2., self.bounds.size.height/2.)-_item.lineWidth startAngle:0. endAngle:2*M_PI clockwise:YES];
    [_shapeLayer setPath:path.CGPath];
}

@end

@interface JOLoadingView()

@property (nonatomic, copy) JOLoadingBlock loadingBlock;

@end

@implementation JOLoadingView

+ (instancetype)loadingViewWithModel:(JOLoadingStyle)style loadingItemBlock:(JOLoadingBlock)loadingBlock {

    JOLoadingView *loadingView = nil;
    if (style == JOLoadingStyleTraceCircleBall) {
        loadingView = [[JOTraceCircleBallLoadingView alloc] initWithItemBlock:loadingBlock];
    }else if (style == JOLoadingStyleCircleDrawLine) {
        loadingView = [[JOCricleDrawLineLodingView alloc] initWithItemBlock:loadingBlock];
    }else if (style == JOLoadingStyleSixPolygonals) {
        loadingView = [[JOSixPolygonalsLoadingView alloc] initWithItemBlock:loadingBlock];
    }else if (style == JOLoadingStyleCircleLine) {
        loadingView = [[JOCircleLineLoadingView alloc] initWithItemBlock:loadingBlock];
    }
    [loadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return loadingView;
}

@end

