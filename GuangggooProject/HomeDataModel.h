//
//  HomeDataModel.h
//  GuangggooProject
//
//  Created by ZhangJie on 2017/9/18.
//  Copyright © 2017年 nuoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDataModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *clickUrl;
@property (nonatomic, copy) NSString *contentType; //  类型
@property (nonatomic, copy) NSString *auther;
@property (nonatomic, copy) NSString *lastDate;
@property (nonatomic, copy) NSString *lastReplyer; // 最后回复人
@property (nonatomic, assign) NSInteger replyCount;

@end
