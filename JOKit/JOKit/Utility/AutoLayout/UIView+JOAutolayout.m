//
//  UIView+JOAutolayout.m
//  JOKit
//
//  Created by 刘维 on 16/8/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "UIView+JOAutolayout.h"

@implementation UIView(JOAutolayout)

- (void)layoutWithItem:(JOLayoutItem *)item itemBlock:(JOViewLayoutBlock)block {
    
    if (block) {
        block(item);
    }
    [JOLayout layoutWithItem:item];
}

#pragma mark - 左边的约束相关
#pragma mark -

- (void)layoutLeft:(CGFloat)distance {
    [self layoutLeft:distance layoutItemHandler:nil];
}

- (void)layoutLeftView:(UIView *)leftView distance:(CGFloat)distance {
    [self layoutLeftView:leftView distance:distance layoutItemHandler:nil];
}

- (void)layoutLeftXView:(UIView *)leftView distance:(CGFloat)distance {
    [self layoutLeftXView:leftView distance:distance layoutItemHandler:nil];
}

- (void)layoutLeft:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutLeftDistance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
}

- (void)layoutLeftView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutLeftView:leftView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutLeftXView:(UIView *)leftView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutLeftXView:leftView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

#pragma mark - 右边的约束相关
#pragma mark -

- (void)layoutRight:(CGFloat)distance {
    [self layoutRight:distance layoutItemHandler:nil];
}

- (void)layoutRightView:(UIView *)rightView distance:(CGFloat)distance {
    [self layoutRightView:rightView distance:distance layoutItemHandler:nil];
}

- (void)layoutRightXView:(UIView *)rightView distance:(CGFloat)distance {
    [self layoutRightXView:rightView distance:distance layoutItemHandler:nil];
}

- (void)layoutRight:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutRightDistance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutRightView:(UIView *)rightView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutRightView:rightView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutRightXView:(UIView *)rightView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutRightXView:rightView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

#pragma mark - 头部的约束相关
#pragma mark -

- (void)layoutTop:(CGFloat)distance {
    [self layoutTop:distance layoutItemHandler:nil];
}

- (void)layoutTopView:(UIView *)topView distance:(CGFloat)distance {
    [self layoutTopView:topView distance:distance layoutItemHandler:nil];
}

- (void)layoutTopYView:(UIView *)topView distance:(CGFloat)distance {
    [self layoutTopYView:topView distance:distance layoutItemHandler:nil];
}

- (void)layoutTop:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutTopDistance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutTopView:(UIView *)topView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutTopView:topView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutTopYView:(UIView *)topView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutTopYView:topView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

#pragma mark - 底部的约束相关
#pragma mark -

- (void)layoutBottom:(CGFloat)distance {
    [self layoutBottom:distance layoutItemHandler:nil];
}

- (void)layoutBottomView:(UIView *)bottomView distance:(CGFloat)distance {
    [self layoutBottomView:bottomView distance:distance layoutItemHandler:nil];
}

- (void)layoutBottomYView:(UIView *)bottomView distance:(CGFloat)distance {
    [self layoutBottomYView:bottomView distance:distance layoutItemHandler:nil];
}

- (void)layoutBottom:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutBottomDistance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutBottomView:(UIView *)bottomView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutBottomView:bottomView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutBottomYView:(UIView *)bottomView distance:(CGFloat)distance layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutBottomYView:bottomView distance:distance view:self];
    [self layoutWithItem:item itemBlock:block];
};

#pragma mark - 宽度的约束相关
#pragma mark -

- (void)layoutWidth:(CGFloat)width {
    [self layoutWidth:width layoutItemHandler:nil];
}

- (void)layoutWidthView:(UIView *)widthView ratio:(CGFloat)ratio {
    [self layoutWidthView:widthView ratio:ratio layoutItemHandler:nil];
}

- (void)layoutWidth:(CGFloat)width layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutWidthDistance:width view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutWidthView:(UIView *)widthView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutWidthView:widthView ratio:ratio view:self];
    [self layoutWithItem:item itemBlock:block];
};

#pragma mark - 高度的约束相关
#pragma mark -

- (void)layoutHeight:(CGFloat)height {
    [self layoutHeight:height layoutItemHandler:nil];
}

- (void)layoutHeightView:(UIView *)heightView ratio:(CGFloat)ratio {
    [self layoutHeightView:heightView ratio:ratio layoutItemHandler:nil];
}

- (void)layoutHeight:(CGFloat)height layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutHeightDistance:height view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutHeightView:(UIView *)heightView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutHeightView:heightView ratio:ratio view:self];
    [self layoutWithItem:item itemBlock:block];
};

#pragma mark - 中心的约束相关
#pragma mark -

- (void)layoutCenterXView:(UIView *)centerView {
    [self layoutCenterXView:centerView layoutItemHandler:nil];
}

- (void)layoutCenterYView:(UIView *)centerView {
    [self layoutCenterYView:centerView layoutItemHandler:nil];
}

- (void)layoutCenterView:(UIView *)centerView {
    [self layoutCenterView:centerView layoutItemHandler:nil];
}

- (void)layoutCenterXView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutCenterXView:centerView view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutCenterYView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutCenterYView:centerView view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutCenterView:(UIView *)centerView layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutCenterXView:centerView view:self];
    JOLayoutItem *item2 = [JOLayoutItem layoutCenterYView:centerView view:self];
    [self layoutWithItem:item itemBlock:block];
    [self layoutWithItem:item2 itemBlock:block];
};

#pragma mark - 宽高的约束相关.
#pragma mark -

- (void)layoutWidthHeightRatio:(CGFloat)ratio {
    [self layoutWidthHeightRatio:ratio layoutItemHandler:nil];
}

- (void)layoutHeightWidthRatio:(CGFloat)ratio {
    [self layoutHeightWidthRatio:ratio layoutItemHandler:nil];
}

- (void)layoutWidthHeightView:(UIView *)heightView ratio:(CGFloat)ratio {
    [self layoutWidthHeightView:heightView ratio:ratio layoutItemHandler:nil];
}

- (void)layoutHeightWidthView:(UIView *)widthView ratio:(CGFloat)ratio {
    [self layoutHeightWidthView:widthView ratio:ratio layoutItemHandler:nil];
}

- (void)layoutWidthHeightRatio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutWidthHeightRatio:ratio view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutHeightWidthRatio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutHeightWidthRatio:ratio view:self];
    [self layoutWithItem:item itemBlock:block];
}

- (void)layoutWidthHeightView:(UIView *)heightView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutWidthHeightView:heightView ratio:ratio view:self];
    [self layoutWithItem:item itemBlock:block];
};

- (void)layoutHeightWidthView:(UIView *)widthView ratio:(CGFloat)ratio layoutItemHandler:(JOViewLayoutBlock)block {
    
    JOLayoutItem *item = [JOLayoutItem layoutWidthHeightView:widthView ratio:ratio view:self];
    [self layoutWithItem:item itemBlock:block];
};

#pragma mark - 四周的约束相关.
#pragma mark -

- (void)layoutEdge:(UIEdgeInsets)edge {
    [self layoutEdge:edge layoutItemHandler:nil];
}

- (void)layoutEdge:(UIEdgeInsets)edge layoutItemHandler:(JOViewLayoutBlock)block {
    
    [self layoutTop:edge.top layoutItemHandler:block];
    [self layoutLeft:edge.left layoutItemHandler:block];
    [self layoutBottom:edge.bottom layoutItemHandler:block];
    [self layoutRight:edge.right layoutItemHandler:block];
}

#pragma mark - size的约束相关.
#pragma mark -

- (void)layoutSize:(CGSize)size {
    [self layoutSize:size layoutItemHandler:nil];
}

- (void)layoutSizeView:(UIView *)sizeView {
    [self layoutSizeView:sizeView layoutItemHandler:nil];
}

- (void)layoutSize:(CGSize)size layoutItemHandler:(JOViewLayoutBlock)block {
    
    [self layoutWidth:size.width layoutItemHandler:block];
    [self layoutHeight:size.height layoutItemHandler:block];
}

- (void)layoutSizeView:(UIView *)sizeView layoutItemHandler:(JOViewLayoutBlock)block {
    
    [self layoutWidthView:sizeView ratio:1. layoutItemHandler:block];
    [self layoutHeightView:sizeView ratio:1. layoutItemHandler:block];
}

#pragma mark - same的约束相关.
#pragma mark -

- (void)layoutSameView:(UIView *)sameView {

    [self layoutSameView:sameView layoutItemHandler:nil];
}

- (void)layoutSameView:(UIView *)sameView layoutItemHandler:(JOViewLayoutBlock)block {
    
    [self layoutTopYView:sameView distance:0. layoutItemHandler:block];
    [self layoutBottomYView:sameView distance:0. layoutItemHandler:block];
    [self layoutLeftXView:sameView distance:0. layoutItemHandler:block];
    [self layoutRightXView:sameView distance:0. layoutItemHandler:block];
}

@end
