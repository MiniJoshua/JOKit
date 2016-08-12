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

    Class tempClass = [self class];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    do{
        [dic setValuesForKeysWithDictionary:[tempClass propertyKeyMapper]];
        tempClass = [tempClass superclass];
    }while (![tempClass isEqual:[JOModel class]]);
    return [self joAllPropertyDicsWithKeyMapper:dic];
}

+ (NSDictionary *)propertyKeyMapper {

    return nil;
}

@end
