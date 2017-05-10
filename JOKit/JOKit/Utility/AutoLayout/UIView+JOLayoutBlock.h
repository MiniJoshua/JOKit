//
//  UIView+JOLayoutBlock.h
//  JOKit
//
//  Created by 刘维 on 17/1/4.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+JOAutolayout.h"
#import "JOMacro.h"

/*
 在使用layoutItemHandler的block方法改变item的属性的时候 
 会默认保留原来的约束不会被移除,如果你需要移除,则需要设置layoutItem的stayConstraint为NO.
 */

typedef UIView *(^JOLayoutLeft)                     (CGFloat distance);
typedef UIView *(^JOLayoutLeftView)                 (UIView *leftView, CGFloat distance);
typedef UIView *(^JOLayoutLeftXView)                (UIView *leftView, CGFloat distance);
typedef UIView *(^JOLayoutLeft_item)                (CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutLeftView_item)            (UIView *leftView, CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutLeftXView_item)           (UIView *leftView, CGFloat distance, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutRight)                    (CGFloat distance);
typedef UIView *(^JOLayoutRightView)                (UIView *rightView, CGFloat distance);
typedef UIView *(^JOLayoutRightXView)               (UIView *rightView, CGFloat distance);
typedef UIView *(^JOLayoutRight_item)               (CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutRightView_item)           (UIView *lrightView, CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutRightXView_item)          (UIView *rightView, CGFloat distance, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutTop)                      (CGFloat distance);
typedef UIView *(^JOLayoutTopView)                  (UIView *topView, CGFloat distance);
typedef UIView *(^JOLayoutTopYView)                 (UIView *topView, CGFloat distance);
typedef UIView *(^JOLayoutTop_item)                 (CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutTopView_item)             (UIView *topView, CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutTopYView_item)            (UIView *topView, CGFloat distance, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutBottom)                   (CGFloat distance);
typedef UIView *(^JOLayoutBottomView)               (UIView *bottomView, CGFloat distance);
typedef UIView *(^JOLayoutBottomYView)              (UIView *bottomView, CGFloat distance);
typedef UIView *(^JOLayoutBottom_item)              (CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutBottomView_item)          (UIView *bottomView, CGFloat distance, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutBottomYView_item)         (UIView *bottomView, CGFloat distance, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutWidth)                    (CGFloat width);
typedef UIView *(^JOLayoutWidthView)                (UIView *widthView, CGFloat ratio);
typedef UIView *(^JOLayoutWidth_item)               (CGFloat width, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutWidthView_item)           (UIView *widthView, CGFloat ratio, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutHeight)                   (CGFloat height);
typedef UIView *(^JOLayoutHeightView)               (UIView *heightView, CGFloat ratio);
typedef UIView *(^JOLayoutHeight_item)              (CGFloat height, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutHeightView_item)          (UIView *heightView, CGFloat ratio, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutCenterXView)              (UIView *centerView);
typedef UIView *(^JOLayoutCenterYView)              (UIView *centerView);
typedef UIView *(^JOLayoutCenterView)               (UIView *centerView);
typedef UIView *(^JOLayoutCenterXView_item)         (UIView *centerView, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutCenterYView_item)         (UIView *centerView, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutCenterView_item)          (UIView *centerView, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutWidthHeightRatio)         (CGFloat ratio);
typedef UIView *(^JOLayoutHeightWidthRatio)         (CGFloat ratio);
typedef UIView *(^JOLayoutWidthHeightViewRatio)     (UIView *heightView, CGFloat ratio);
typedef UIView *(^JOLayoutHeightWidthViewRatio)     (UIView *widthView, CGFloat ratio);
typedef UIView *(^JOLayoutWidthHeightRatio_item)    (CGFloat ratio, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutHeightWidthRatio_item)    (CGFloat ratio, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutWidthHeightViewRatio_item)(UIView *heightView, CGFloat ratio, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutHeightWidthViewRatio_item)(UIView *widthView, CGFloat ratio, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutEdge)                     (UIEdgeInsets edge);
typedef UIView *(^JOLayoutEdge_item)                (UIEdgeInsets edge, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutSize)                     (CGSize size);
typedef UIView *(^JOLayoutSizeView)                 (UIView *sizeView);
typedef UIView *(^JOLayoutSize_item)                (CGSize size, JOViewLayoutBlock block);
typedef UIView *(^JOLayoutSizeView_item)            (UIView *sizeView, JOViewLayoutBlock block);

typedef UIView *(^JOLayoutSameView)                 (UIView *sameView);
typedef UIView *(^JOLayoutSameView_item)            (UIView *sameView, JOViewLayoutBlock block);

@interface UIView(JOLayoutBlock)

#pragma mark - property block
#pragma mark -

@property (nonatomic, copy, readonly) JOLayoutLeft                          joLeft;
@property (nonatomic, copy, readonly) JOLayoutLeftView                      joLeftView;
@property (nonatomic, copy, readonly) JOLayoutLeftXView                     joLeftXView;
@property (nonatomic, copy, readonly) JOLayoutLeft_item                     joLeft_item;
@property (nonatomic, copy, readonly) JOLayoutLeftView_item                 joLeftView_item;
@property (nonatomic, copy, readonly) JOLayoutLeftXView_item                joLeftXView_item;

@property (nonatomic, copy, readonly) JOLayoutRight                         joRight;
@property (nonatomic, copy, readonly) JOLayoutRightView                     joRightView;
@property (nonatomic, copy, readonly) JOLayoutRightXView                    joRightXView;
@property (nonatomic, copy, readonly) JOLayoutRight_item                    joRight_item;
@property (nonatomic, copy, readonly) JOLayoutRightView_item                joRightView_item;
@property (nonatomic, copy, readonly) JOLayoutRightXView_item               joRightXView_item;

@property (nonatomic, copy, readonly) JOLayoutTop                           joTop;
@property (nonatomic, copy, readonly) JOLayoutTopView                       joTopView;
@property (nonatomic, copy, readonly) JOLayoutTopYView                      joTopYView;
@property (nonatomic, copy, readonly) JOLayoutTop_item                      joTop_item;
@property (nonatomic, copy, readonly) JOLayoutTopView_item                  joTopView_item;
@property (nonatomic, copy, readonly) JOLayoutTopYView_item                 joTopYView_item;

@property (nonatomic, copy, readonly) JOLayoutBottom                        joBottom;
@property (nonatomic, copy, readonly) JOLayoutBottomView                    joBottomView;
@property (nonatomic, copy, readonly) JOLayoutBottomYView                   joBottomYView;
@property (nonatomic, copy, readonly) JOLayoutBottom_item                   joBottom_item;
@property (nonatomic, copy, readonly) JOLayoutBottomView_item               joBottomView_item;
@property (nonatomic, copy, readonly) JOLayoutBottomYView_item              joBottomYView_item;

@property (nonatomic, copy, readonly) JOLayoutWidth                         joWidth;
@property (nonatomic, copy, readonly) JOLayoutWidthView                     joWidthView;
@property (nonatomic, copy, readonly) JOLayoutWidth_item                    joWidth_item;
@property (nonatomic, copy, readonly) JOLayoutWidthView_item                joWidthView_item;

@property (nonatomic, copy, readonly) JOLayoutHeight                        joHeight;
@property (nonatomic, copy, readonly) JOLayoutHeightView                    joHeightView;
@property (nonatomic, copy, readonly) JOLayoutHeight_item                   joHeight_item;
@property (nonatomic, copy, readonly) JOLayoutHeightView_item               joHeightView_item;

@property (nonatomic, copy, readonly) JOLayoutCenterXView                   joCenterXView;
@property (nonatomic, copy, readonly) JOLayoutCenterYView                   joCenterYView;
@property (nonatomic, copy, readonly) JOLayoutCenterView                    joCenterView;
@property (nonatomic, copy, readonly) JOLayoutCenterXView_item              joCenterXView_item;
@property (nonatomic, copy, readonly) JOLayoutCenterYView_item              joCenterYView_item;
@property (nonatomic, copy, readonly) JOLayoutCenterView_item               joCenterView_item;

@property (nonatomic, copy, readonly) JOLayoutWidthHeightRatio              joWidthHeightRatio;
@property (nonatomic, copy, readonly) JOLayoutHeightWidthRatio              joHeightWidthRatio;
@property (nonatomic, copy, readonly) JOLayoutWidthHeightViewRatio          joWidthHeightViewRatio;
@property (nonatomic, copy, readonly) JOLayoutHeightWidthViewRatio          joHeightWidthViewRatio;
@property (nonatomic, copy, readonly) JOLayoutWidthHeightRatio_item         joWidthHeightRatio_item;
@property (nonatomic, copy, readonly) JOLayoutHeightWidthRatio_item         joHeightWidthRatio_item;
@property (nonatomic, copy, readonly) JOLayoutWidthHeightViewRatio_item     joWidthHeightViewRatio_item;
@property (nonatomic, copy, readonly) JOLayoutHeightWidthViewRatio_item     joHeightWidthViewRatio_item;

@property (nonatomic, copy, readonly) JOLayoutEdge                          joEdge;
@property (nonatomic, copy, readonly) JOLayoutEdge_item                     joEdge_item;

@property (nonatomic, copy, readonly) JOLayoutSize                          joSize;
@property (nonatomic, copy, readonly) JOLayoutSizeView                      joSizeView;
@property (nonatomic, copy, readonly) JOLayoutSize_item                     joSize_item;
@property (nonatomic, copy, readonly) JOLayoutSizeView_item                 joSizeView_item;

@property (nonatomic, copy, readonly) JOLayoutSameView                      joSameView;
@property (nonatomic, copy, readonly) JOLayoutSameView_item                 joSameView_item;

@end
