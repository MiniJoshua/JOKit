//
//  JOFileDownloadConfig.m
//  JOKit
//
//  Created by 刘维 on 16/8/8.
//  Copyright © 2016年 Joshua. All rights reserved.
//

#import "JOFileDownloadConfig.h"
#import "JOExceptionHelper.h"

@implementation JOFileDownloadConfig

- (void)setFilePath:(NSString *)savePath fileName:(NSString *)fileName isClean:(BOOL)isClean {

    self.fileSaveName = nil;
    self.fileSaveName = fileName;
    
    self.fileSavePath = nil;
    self.fileSavePath = savePath;
    
    _isCleanExistFile = isClean;
}

@end
