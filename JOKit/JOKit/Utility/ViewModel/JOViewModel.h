//
//  JOViewModel.h
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOCommand.h"
#import "JOMacro.h"

@interface JOViewModel : NSObject

@property (nonatomic, strong) JOCommand *dataReqeustCommand;

- (void)configure;

@end
