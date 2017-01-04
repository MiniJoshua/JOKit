//
//  UIView+JOLayoutBlock.m
//  JOKit
//
//  Created by 刘维 on 17/1/4.
//  Copyright © 2017年 Joshua. All rights reserved.
//

#import "UIView+JOLayoutBlock.h"

@implementation UIView(JOLayoutBlock)

#pragma mark - property block
#pragma mark -

#pragma mark - Left

- (JOLayoutLeft)joLeft {
    
    @weakify(self);
    return ^(CGFloat distance) {
        @strongify(self);
        [self layoutLeft:distance];
        return self;
    };
}

- (JOLayoutLeftView)joLeftView {
    
    @weakify(self);
    return ^(UIView *leftView, CGFloat distance) {
        @strongify(self);
        [self layoutLeftView:leftView distance:distance];
        return self;
    };
}

- (JOLayoutLeftXView)joLeftXView {
    
    @weakify(self);
    return ^(UIView *leftView, CGFloat distance) {
        @strongify(self);
        [self layoutLeftXView:leftView distance:distance];
        return self;
    };
}

- (JOLayoutLeft_item)joLeft_item {
    
    @weakify(self);
    return ^(CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutLeft:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutLeftView_item)joLeftView_item {
    
    @weakify(self);
    return ^(UIView *leftView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutLeftView:leftView distance:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutLeftXView_item)joLeftXView_item {
    
    @weakify(self);
    return ^(UIView *leftView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutLeftXView:leftView distance:distance layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Right

- (JOLayoutRight)joRight {
    
    @weakify(self);
    return ^(CGFloat distance) {
        @strongify(self);
        [self layoutRight:distance];
        return self;
    };
}

- (JOLayoutRightView)joRightView {
    
    @weakify(self);
    return ^(UIView *rightView, CGFloat distance) {
        @strongify(self);
        [self layoutRightView:rightView distance:distance];
        return self;
    };
}

- (JOLayoutRightXView)joRightXView {
    
    @weakify(self);
    return ^(UIView *rightView, CGFloat distance) {
        @strongify(self);
        [self layoutRightXView:rightView distance:distance];
        return self;
    };
}

- (JOLayoutRight_item)joRight_item {
    
    @weakify(self);
    return ^(CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutRight:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutRightView_item)joRightView_item {
    
    @weakify(self);
    return ^(UIView *rightView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutLeftView:rightView distance:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutRightXView_item)joRightXView_item {
    
    @weakify(self);
    return ^(UIView *rightView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutRightXView:rightView distance:distance layoutItemHandler:block];
        return self;
    };
}

#pragma mark - top

- (JOLayoutTop)joTop {
    
    @weakify(self);
    return ^(CGFloat distance) {
        @strongify(self);
        [self layoutTop:distance];
        return self;
    };
}

- (JOLayoutTopView)joTopView {
    
    @weakify(self);
    return ^(UIView *topView, CGFloat distance) {
        @strongify(self);
        [self layoutTopView:topView distance:distance];
        return self;
    };
}

- (JOLayoutTopYView)joTopYView {
    
    @weakify(self);
    return ^(UIView *topView, CGFloat distance) {
        @strongify(self);
        [self layoutTopYView:topView distance:distance];
        return self;
    };
}

- (JOLayoutTop_item)joTop_item {
    
    @weakify(self);
    return ^(CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutTop:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutTopView_item)joTopView_item {
    
    @weakify(self);
    return ^(UIView *topView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutTopView:topView distance:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutTopYView_item)joTopYView_item {
    
    @weakify(self);
    return ^(UIView *topView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutTopYView:topView distance:distance layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Bottom

- (JOLayoutBottom)joBottom {
    
    @weakify(self);
    return ^(CGFloat distance) {
        @strongify(self);
        [self layoutBottom:distance];
        return self;
    };
}

- (JOLayoutBottomView)joBottomView {
    
    @weakify(self);
    return ^(UIView *bottomView, CGFloat distance) {
        @strongify(self);
        [self layoutBottomView:bottomView distance:distance];
        return self;
    };
}

- (JOLayoutBottomYView)joBottomYView {
    
    @weakify(self);
    return ^(UIView *bottomView, CGFloat distance) {
        @strongify(self);
        [self layoutBottomYView:bottomView distance:distance];
        return self;
    };
}

- (JOLayoutBottom_item)joBottom_item {
    
    @weakify(self);
    return ^(CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutBottom:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutBottomView_item)joBottomView_item {
    
    @weakify(self);
    return ^(UIView *bottomView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutBottomView:bottomView distance:distance layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutBottomYView_item)joBottomYView_item {
    
    @weakify(self);
    return ^(UIView *bottomView, CGFloat distance, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutBottomYView:bottomView distance:distance layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Width

- (JOLayoutWidth)joWidth {
    
    @weakify(self);
    return ^(CGFloat width) {
        @strongify(self);
        [self layoutWidth:width];
        return self;
    };
}

- (JOLayoutWidthView)joWidthView {
    
    @weakify(self);
    return ^(UIView *widthView, CGFloat ratio) {
        @strongify(self);
        [self layoutWidthView:widthView ratio:ratio];
        return self;
    };
}

- (JOLayoutWidth_item)joWidth_item {
    
    @weakify(self);
    return ^(CGFloat width, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutWidth:width layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutWidthView_item)joWidthView_item {
    
    @weakify(self);
    return ^(UIView *widthView, CGFloat ratio, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutWidthView:widthView ratio:ratio layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Height

- (JOLayoutHeight)joHeight {
    
    @weakify(self);
    return ^(CGFloat height) {
        @strongify(self);
        [self layoutHeight:height];
        return self;
    };
}

- (JOLayoutHeightView)joHeightView {
    
    @weakify(self);
    return ^(UIView *heightView, CGFloat ratio) {
        @strongify(self);
        [self layoutHeightView:heightView ratio:ratio];
        return self;
    };
}

- (JOLayoutHeight_item)joHeight_item {
    
    @weakify(self);
    return ^(CGFloat height, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutHeight:height layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutHeightView_item)joHeightView_item {
    
    @weakify(self);
    return ^(UIView *heightView, CGFloat ratio, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutHeightView:heightView ratio:ratio layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Center

- (JOLayoutCenterXView)joCenterXView {
    
    @weakify(self);
    return ^(UIView *centerView) {
        @strongify(self);
        [self layoutCenterXView:centerView];
        return self;
    };
}

- (JOLayoutCenterYView)joCenterYView {
    
    @weakify(self);
    return ^(UIView *centerView) {
        @strongify(self);
        [self layoutCenterYView:centerView];
        return self;
    };
}

- (JOLayoutCenterView)joCenterView {
    
    @weakify(self);
    return ^(UIView *centerView) {
        @strongify(self);
        [self layoutCenterView:centerView];
        return self;
    };
}

- (JOLayoutCenterXView_item)joCenterXView_item {
    
    @weakify(self);
    return ^(UIView *centerView, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutCenterXView:centerView layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutCenterYView_item)joCenterYView_item {
    
    @weakify(self);
    return ^(UIView *centerView, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutCenterYView:centerView layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutCenterView_item)joCenterView_item {
    
    @weakify(self);
    return ^(UIView *centerView, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutCenterView:centerView layoutItemHandler:block];
        return self;
    };
}

#pragma mark - height width

- (JOLayoutWidthHeightRatio)joWidthHeightRatio {
    
    @weakify(self);
    return ^(CGFloat ratio) {
        @strongify(self);
        [self layoutWidthHeightRatio:ratio];
        return self;
    };
}

- (JOLayoutHeightWidthRatio)joHeightWidthRatio {
    
    @weakify(self);
    return ^(CGFloat ratio) {
        @strongify(self);
        [self layoutHeightWidthRatio:ratio];
        return self;
    };
}

- (JOLayoutWidthHeightViewRatio)joWidthHeightViewRatio {
    
    @weakify(self);
    return ^(UIView *heightView, CGFloat ratio) {
        @strongify(self);
        [self layoutWidthHeightView:heightView ratio:ratio];
        return self;
    };
}

- (JOLayoutHeightWidthViewRatio)joHeightWidthViewRatio {
    
    @weakify(self);
    return ^(UIView *widthView, CGFloat ratio) {
        @strongify(self);
        [self layoutHeightWidthView:widthView ratio:ratio];
        return self;
    };
}

- (JOLayoutWidthHeightRatio_item)joWidthHeightRatio_item {
    
    @weakify(self);
    return ^(CGFloat ratio, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutWidthHeightRatio:ratio layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutHeightWidthRatio_item)joHeightWidthRatio_item {
    
    @weakify(self);
    return ^(CGFloat ratio, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutHeightWidthRatio:ratio layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutWidthHeightViewRatio_item)joWidthHeightViewRatio_item {
    
    @weakify(self);
    return ^(UIView *heightView, CGFloat ratio, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutWidthHeightView:heightView ratio:ratio layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutHeightWidthViewRatio_item)joHeightWidthViewRatio_item {
    
    @weakify(self);
    return ^(UIView *widthView, CGFloat ratio, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutHeightWidthView:widthView ratio:ratio layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Edge

- (JOLayoutEdge)joEdge {
    
    @weakify(self);
    return ^(UIEdgeInsets edge) {
        @strongify(self);
        [self layoutEdge:edge];
        return self;
    };
}

- (JOLayoutEdge_item)joEdge_item {
    
    @weakify(self);
    return ^(UIEdgeInsets edge, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutEdge:edge layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Size

- (JOLayoutSize)joSize {
    
    @weakify(self);
    return ^(CGSize size) {
        @strongify(self);
        [self layoutSize:size];
        return self;
    };
}

- (JOLayoutSizeView)joSizeView {
    
    @weakify(self);
    return ^(UIView *sizeView) {
        @strongify(self);
        [self layoutSizeView:sizeView];
        return self;
    };
}

- (JOLayoutSize_item)joSize_item {
    
    @weakify(self);
    return ^(CGSize size, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutSize:size layoutItemHandler:block];
        return self;
    };
}

- (JOLayoutSizeView_item)joSizeView_item {
    
    @weakify(self);
    return ^(UIView *sizeView, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutSizeView:sizeView layoutItemHandler:block];
        return self;
    };
}

#pragma mark - Same

- (JOLayoutSameView)joSameView {
    
    @weakify(self);
    return ^(UIView *sameView) {
        @strongify(self);
        [self layoutSameView:sameView];
        return self;
    };
}

- (JOLayoutSameView_item)joSameView_item {
    
    @weakify(self);
    return ^(UIView *sameView, JOViewLayoutBlock block) {
        @strongify(self);
        [self layoutSameView:sameView layoutItemHandler:block];
        return self;
    };
}


@end
