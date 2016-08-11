//
//  JOModel.m
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOModel.h"
#import "NSObject+JOExtend.h"

@implementation JOModel

- (NSDictionary *)modelDic {

    return [self joAllPropertyDicsWithKeyMapper:[[self class] propertyKeyMapper]];
}

+ (NSDictionary *)propertyKeyMapper {

    return nil;
}

@end
