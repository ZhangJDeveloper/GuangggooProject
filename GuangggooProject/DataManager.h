//
//  DataManager.h
//  GuangggooProject
//
//  Created by ZhangJie on 2017/9/18.
//  Copyright © 2017年 nuoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpSuccessBlock)(NSArray *dataArray);
typedef void (^HttpFailureBlock)();

@interface DataManager : NSObject

+ (instancetype)manager;


- (void)getHomeDataPageNumber:(NSInteger) pageNumber success:(HttpSuccessBlock) sucessBlock failure:(HttpFailureBlock)failureBlock;
@end
