//
//  JOViewModel.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOMacro.h"

@class JOCommand;

@interface JOViewModel : NSObject

@property (nonatomic, strong) JOCommand *dataReqeustCommand;
@property (nonatomic, strong) JOCommand *viewUpdateCommand;

- (void)configure;

@end
