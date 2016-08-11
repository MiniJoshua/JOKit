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

- (NSDictionary *)modelDic;

+ (NSDictionary *)propertyKeyMapper;

@end
