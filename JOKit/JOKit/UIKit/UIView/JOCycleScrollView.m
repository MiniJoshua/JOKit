//
//  JOCycleScrollView.m
//  JOKit
//
//  Created by 刘维 on 2017/6/8.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import "JOCycleScrollView.h"

@interface JOCycleScrollView()<UIScrollViewDelegate> {
    
    UIView              *_leftView;     //左边的视图.
    UIView              *_midView;      //中间的视图.
    UIView              *_rightView;    //右边的视图.
    
    NSInteger           _currentIndex;  //真实的index
    NSInteger           _sourceIndex;   //需要填充数据源的index.  0~max
    NSInteger           _showIndex;     //调用者需要最先展现的index。
    CGFloat             _defaultOffsetX;//默认的scrollView的Content的offset的x
    NSInteger           _maxPages;      //最大的页数.
    
    CycleScrollViewType _cycleType;     //视图的类型 left/mid/right
}

@property (nonatomic, copy) void(^pagesChangeBlock)(CycleViewType type, NSInteger index);
@property (nonatomic, copy) void(^indexChangeBlock)(NSInteger index);

@end

@implementation JOCycleScrollView

+ (JOCycleScrollView *)cycleScrollViewWithFrame:(CGRect)frame cycleType:(CycleScrollViewType)type {
    
    JOCycleScrollView *scrollView = [[JOCycleScrollView alloc] initWithFrame:frame];
    [scrollView setCycleType:type];
    return scrollView;
}

- (void)setCycleType:(CycleScrollViewType)type {
    
    _cycleType = type;
    
    if (_cycleType == CycleScrollViewTypeInfinite) {
        _currentIndex       = 0;
        _sourceIndex        = 0;
        _defaultOffsetX     = self.frame.size.width;
        
    }else if (_cycleType == CycleScrollViewTypeLimited) {
        _currentIndex       = 0;
        _sourceIndex        = 0;
        _defaultOffsetX     = 0.;
    }
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
        
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., width, height)];
        [_leftView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_leftView];
        
        _midView = [[UIView alloc] initWithFrame:CGRectMake(width, 0., width, height)];
        [_midView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_midView];
        
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(width*2., 0., width, height)];
        [_rightView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rightView];
    }
    return self;
}

#pragma mark - public

- (void)setMaxPages:(NSInteger)pages showIndex:(NSInteger)index{
    _maxPages = pages;
    
    if (index > pages) {
        _showIndex = pages;
    }else {
        _showIndex = index;
    }
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if(_cycleType == CycleScrollViewTypeLimited) {
        [self setContentSize:CGSizeMake(width*_maxPages, height)];
        [self scrollRectToVisible:CGRectMake(width*(_showIndex-1), 0., width, height) animated:NO];
        
        if (_showIndex == 1 || _showIndex == 2) {
            [self exchangeViewWithOffsetX:self.frame.size.width];
            !self.indexChangeBlock?:self.indexChangeBlock(_showIndex);
        }
        
        if (_maxPages < 3) {
            [_rightView setHidden:YES];
        }else {
            [_rightView setHidden:NO];
        }
    }else if(_cycleType == CycleScrollViewTypeInfinite){
        [self setContentSize:CGSizeMake(width*3., height)];
        [self scrollRectToVisible:CGRectMake(width, 0., width, height) animated:NO];
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

- (void)pagesChanged:(void(^)(CycleViewType type, NSInteger index))block {
    
    self.pagesChangeBlock = nil;
    self.pagesChangeBlock = block;
}

- (void)indexChanged:(void(^)(NSInteger index))block {
    
    self.indexChangeBlock = nil;
    self.indexChangeBlock = block;
}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    if (_cycleType == CycleScrollViewTypeLimited) {
        
        CGFloat result = contentOffsetX/self.frame.size.width;
        float intNum;
        float floatNum;
        floatNum = modff(result, &intNum);
        if (floatNum > 0.5) {
            intNum += 1;
        }
        
        _sourceIndex = intNum;
        !self.indexChangeBlock?:self.indexChangeBlock(intNum+1);
        
        if (_maxPages > 2) {
            if (contentOffsetX < (_maxPages-2) * self.frame.size.width && contentOffsetX > self.frame.size.width) {
                [self exchangeViewWithOffsetX:contentOffsetX];
            }else if (contentOffsetX >= (_maxPages-2) * self.frame.size.width) {
                [self exchangeViewWithOffsetX:(_maxPages-2) * self.frame.size.width];
            }
        }
        
    }else if(_cycleType == CycleScrollViewTypeInfinite){
        
        [scrollView setContentInset:UIEdgeInsetsMake(0., _defaultOffsetX - contentOffsetX, 0, - (_defaultOffsetX - contentOffsetX))];
        
        CGFloat result = (contentOffsetX - _defaultOffsetX)/self.frame.size.width;
        float intNum;
        float floatNum;
        floatNum = modff(result, &intNum);
        
        if (floatNum > 0.5) {
            intNum += 1;
        }else if (floatNum < -0.5) {
            intNum -= 1;
        }
        if (intNum < 0) {
            intNum += _maxPages * 10000;
        }
        
        NSInteger tmp = ((int)intNum+_showIndex)%_maxPages;
        if (tmp == 0) {
            tmp = _maxPages;
        }
        
        _sourceIndex = tmp-1;
        !self.indexChangeBlock?:self.indexChangeBlock(tmp);
        
        [self exchangeViewWithOffsetX:contentOffsetX];
    }
}

#pragma mark - private

- (void)exchangeViewWithOffsetX:(CGFloat)offsetX{
    
    CGFloat defalutOffsetX = self.frame.size.width;
    
    CGFloat result = offsetX/defalutOffsetX;
    float intNum;
    float floatNum;
    floatNum = modff(result, &intNum);
    
    if (floatNum > 0.5) {
        intNum += 1;
    }else if (floatNum < -0.5) {
        intNum -= 1;
    }
    
    if (_currentIndex != intNum) {
        _currentIndex = intNum;
        
        NSInteger tmp = (_currentIndex + 3*10000)%3;
        
        NSInteger leftIndex = 0;
        NSInteger midIndex  = 0;
        NSInteger rightIndex= 0;
        
        switch (tmp) {
            case 0: {
                //312
                [self setViewXPoint:(_currentIndex-1)*defalutOffsetX view:_rightView];
                [self setViewXPoint:_currentIndex*defalutOffsetX view:_leftView];
                [self setViewXPoint:(_currentIndex+1)*defalutOffsetX view:_midView];
                
                if (_cycleType == CycleScrollViewTypeLimited) {
                    
                    if (_maxPages == 1) {
                        leftIndex   = 0;
                        midIndex    = 0;
                        rightIndex  = 0;
                    }else if (_maxPages == 2) {
                        leftIndex   = 1;
                        midIndex    = 0;
                        rightIndex  = 0;
                    }else {
                        
                        if (_sourceIndex + 1 == _maxPages) {
                            leftIndex   = _maxPages - 2;
                            midIndex    = _maxPages - 1;
                            rightIndex  = _maxPages - 3;
                        }else if (_sourceIndex-1 < 0) {
                            leftIndex   = 1;
                            midIndex    = 2;
                            rightIndex  = 0;
                        }else {
                            leftIndex   = _sourceIndex;
                            midIndex    = _sourceIndex + 1;
                            rightIndex  = _sourceIndex - 1;
                        }
                    }
                    
                }else if (_cycleType == CycleScrollViewTypeInfinite) {
                    leftIndex   = _sourceIndex;
                    midIndex    = (_sourceIndex + 1 == _maxPages)?0:_sourceIndex+1;
                    rightIndex  = (_sourceIndex-1<0)?_maxPages-1:_sourceIndex-1;
                }
            }
                break;
            case 1: {
                //123
                [self setViewXPoint:(_currentIndex-1)*defalutOffsetX view:_leftView];
                [self setViewXPoint:_currentIndex*defalutOffsetX view:_midView];
                [self setViewXPoint:(_currentIndex+1)*defalutOffsetX view:_rightView];
                
                if (_cycleType == CycleScrollViewTypeLimited) {
                    
                    if (_maxPages == 1) {
                        leftIndex   = 0;
                        midIndex    = 0;
                        rightIndex  = 0;
                    }else if (_maxPages == 2) {
                        leftIndex   = 0;
                        midIndex    = 1;
                        rightIndex  = 0;
                    }else {
                        if (_sourceIndex + 1 == _maxPages) {
                            leftIndex   = _maxPages - 3;
                            midIndex    = _maxPages - 2;
                            rightIndex  = _maxPages - 1;
                        }else if (_sourceIndex-1 < 0) {
                            leftIndex   = 0;
                            midIndex    = 1;
                            rightIndex  = 2;
                        }else {
                            leftIndex   = _sourceIndex-1;
                            midIndex    = _sourceIndex;
                            rightIndex  = _sourceIndex + 1;
                        }
                    }
                    
                }else if (_cycleType == CycleScrollViewTypeInfinite) {
                    leftIndex   = (_sourceIndex-1<0)?_maxPages-1:_sourceIndex-1;
                    midIndex    = _sourceIndex;
                    rightIndex  = (_sourceIndex + 1 == _maxPages)?0:_sourceIndex+1;
                }
            }
                break;
            case 2:{
                //231
                [self setViewXPoint:(_currentIndex-1)*defalutOffsetX view:_midView];
                [self setViewXPoint:_currentIndex*defalutOffsetX view:_rightView];
                [self setViewXPoint:(_currentIndex+1)*defalutOffsetX view:_leftView];
                
                if (_cycleType == CycleScrollViewTypeLimited) {
                    if (_maxPages == 1) {
                        leftIndex   = 0;
                        midIndex    = 0;
                        rightIndex  = 0;
                    }else if (_maxPages == 2) {
                        leftIndex   = 0;
                        midIndex    = 0;
                        rightIndex  = 1;
                    }else {
                        if (_sourceIndex + 1 == _maxPages) {
                            leftIndex   = _maxPages - 1;
                            midIndex    = _maxPages - 3;
                            rightIndex  = _maxPages - 2;
                        }else if (_sourceIndex-1 < 0) {
                            leftIndex   = 2;
                            midIndex    = 0;
                            rightIndex  = 1;
                        }else {
                            leftIndex   = _sourceIndex + 1;
                            midIndex    = _sourceIndex - 1;
                            rightIndex  = _sourceIndex;
                        }
                    }
                }else if (_cycleType == CycleScrollViewTypeInfinite) {
                    leftIndex   = (_sourceIndex + 1 == _maxPages)?0:_sourceIndex+1;
                    midIndex    = (_sourceIndex-1<0)?_maxPages-1:_sourceIndex-1;
                    rightIndex  = _sourceIndex;
                }
            }
                break;
            default:
                break;
        }
        
        !self.pagesChangeBlock?:self.pagesChangeBlock(CycleViewTypeLeft,leftIndex);
        !self.pagesChangeBlock?:self.pagesChangeBlock(CycleViewTypeMid,midIndex);
        !self.pagesChangeBlock?:self.pagesChangeBlock(CycleViewTypeRight,rightIndex);
    }
}

- (void)setViewXPoint:(CGFloat)x view:(UIView *)view{
    
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

@end
