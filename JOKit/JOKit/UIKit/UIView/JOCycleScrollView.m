//
//  JOCycleScrollView.m
//  JOKit
//
//  Created by 刘维 on 2017/6/8.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import "JOCycleScrollView.h"

@interface JOCycleView : UIView
@property (nonatomic, assign) NSInteger index;
@end

@implementation JOCycleView
@end

@interface JOCycleScrollView()<UIScrollViewDelegate> {

    JOCycleView  *_leftView;
    JOCycleView  *_midView;
    JOCycleView  *_rightView;

    NSInteger _currentIndex;
    CGFloat _defaultOffsetX;

    NSInteger _maxPages;
    
    CycleScrollViewType _cycleType;
}

@property (nonatomic, copy) void(^pagesChangeBlock)(CycleViewType type, NSInteger index);

@end

@implementation JOCycleScrollView

+ (JOCycleScrollView *)cycleScrollViewWithFrame:(CGRect)frame cycleType:(CycleScrollViewType)type {

    JOCycleScrollView *scrollView = [[JOCycleScrollView alloc] initWithFrame:frame];
    [scrollView setCycleType:type];
    return scrollView;
}

- (void)setCycleType:(CycleScrollViewType)type {

    _cycleType = type;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (_cycleType == CycleScrollViewTypeInfinite) {
        
        [self setContentSize:CGSizeMake(width*3., height)];
        _currentIndex       = 1;
        _defaultOffsetX     = width;
        [self scrollRectToVisible:CGRectMake(width, 0., width, height) animated:NO];

    }else if (_cycleType == CycleScrollViewTypeLimited) {
        _currentIndex       = 0;
        _defaultOffsetX     = 0;
    }
}

- (void)setViewWithLeft:(UIView *)leftView mid:(UIView *)midView right:(UIView *)rightView {

    CGRect leftRect = {CGPointZero,_leftView.frame.size};
    CGRect midRect = {CGPointZero,_midView.frame.size};
    CGRect rightRect = {CGPointZero,_rightView.frame.size};
    [leftView setFrame:leftRect];
    [midView setFrame:midRect];
    [rightView setFrame:rightRect];
    
    [_leftView addSubview:leftView];
    [_midView addSubview:midView];
    [_rightView addSubview:rightView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        [self setDelegate:self];
        [self setPagingEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        
        _leftView = [[JOCycleView alloc] initWithFrame:CGRectMake(0., 0., width, height)];
        [_leftView setBackgroundColor:[UIColor clearColor]];
        [_leftView setIndex:0];
        [self addSubview:_leftView];
        
        _midView = [[JOCycleView alloc] initWithFrame:CGRectMake(width, 0., width, height)];
        [_midView setBackgroundColor:[UIColor clearColor]];
        [_midView setIndex:1];
        [self addSubview:_midView];
        
        _rightView = [[JOCycleView alloc] initWithFrame:CGRectMake(width*2., 0., width, height)];
        [_rightView setBackgroundColor:[UIColor clearColor]];
        [_rightView setIndex:2];
        [self addSubview:_rightView];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (_cycleType == CycleScrollViewTypeLimited) {
        
        if (contentOffsetX < (_maxPages-1) * self.frame.size.width && contentOffsetX > self.frame.size.width) {
            [self exchangeViewWithOffsetX:contentOffsetX];
        }
        
    }else if(_cycleType == CycleScrollViewTypeInfinite){
    
        [scrollView setContentInset:UIEdgeInsetsMake(0., _defaultOffsetX - scrollView.contentOffset.x, 0, - (_defaultOffsetX - scrollView.contentOffset.x))];
        [self exchangeViewWithOffsetX:contentOffsetX];
    }
}

#pragma mark - public

- (void)setMaxPages:(NSInteger)pages {
    _maxPages = pages;
    if(_cycleType == CycleScrollViewTypeLimited) {
        [self setContentSize:CGSizeMake(self.frame.size.width*_maxPages, self.frame.size.height)];
    }
}

- (void)pagesChanged:(void(^)(CycleViewType type, NSInteger index))block {

    self.pagesChangeBlock = nil;
    self.pagesChangeBlock = block;
    
    [self blockOperation];
}

#pragma mark - private

- (void)exchangeViewWithOffsetX:(CGFloat)offsetX {

    CGFloat defalutOffsetX = self.frame.size.width;
    
    NSInteger index = (NSInteger)(offsetX / defalutOffsetX);
    
    if (_currentIndex != index) {
        _currentIndex = index;
//        NSLog(@"index:%ld",_currentIndex);
        
        NSInteger tmp = (_currentIndex + 3*1000)%3;
        
        switch (tmp) {
            case 0: {
                //312
                [_rightView  setIndex:_currentIndex-1];
                [_leftView   setIndex:_currentIndex];
                [_midView setIndex:_currentIndex+1];
                [self setViewXPoint:(_currentIndex-1)*defalutOffsetX view:_rightView];
                [self setViewXPoint:_currentIndex*defalutOffsetX view:_leftView];
                [self setViewXPoint:(_currentIndex+1)*defalutOffsetX view:_midView];
            }
                break;
            case 1: {
                //123
                [_leftView  setIndex:_currentIndex-1];
                [_midView   setIndex:_currentIndex];
                [_rightView setIndex:_currentIndex+1];
                [self setViewXPoint:(_currentIndex-1)*defalutOffsetX view:_leftView];
                [self setViewXPoint:_currentIndex*defalutOffsetX view:_midView];
                [self setViewXPoint:(_currentIndex+1)*defalutOffsetX view:_rightView];
            }
                break;
            case 2:{
                //231
                [_midView  setIndex:_currentIndex-1];
                [_rightView   setIndex:_currentIndex];
                [_leftView setIndex:_currentIndex+1];
                [self setViewXPoint:(_currentIndex-1)*defalutOffsetX view:_midView];
                [self setViewXPoint:_currentIndex*defalutOffsetX view:_rightView];
                [self setViewXPoint:(_currentIndex+1)*defalutOffsetX view:_leftView];
            }
                break;
            default:
                break;
        }
        
        [self blockOperation];
    }
}

- (void)setViewXPoint:(CGFloat)x view:(UIView *)view{

    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

- (void)blockOperation {

    !self.pagesChangeBlock?:self.pagesChangeBlock(CycleViewTypeLeft,_leftView.index);
    !self.pagesChangeBlock?:self.pagesChangeBlock(CycleViewTypeMid,_midView.index);
    !self.pagesChangeBlock?:self.pagesChangeBlock(CycleViewTypeRight,_rightView.index);
}

@end
