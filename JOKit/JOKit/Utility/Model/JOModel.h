//
//  JOModel.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JOExtend.h"

@interface JOModel : NSObject

/**
 *  模型转换为字典类型.
 *
 *  @return NSDictionary.
 */
- (NSDictionary *)modelDic;

/**
 *  需要替换的Property的key值.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary *)propertyKeyMapper;

@end
