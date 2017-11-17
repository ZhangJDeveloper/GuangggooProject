//
//  DataManager.m
//  GuangggooProject
//
//  Created by ZhangJie on 2017/9/18.
//  Copyright © 2017年 nuoyuan. All rights reserved.
//

#import "DataManager.h"
#import "TFHpple.h"
#import "AFNetWorking.h"
#import "Ono.h"
#import "HomeDataModel.h"

@interface DataManager()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;


@end

NSString const *BASE_URL = @"http://www.guanggoo.com";

@implementation DataManager

static dispatch_once_t onceToken;
static DataManager *manager;

+ (instancetype)manager {
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
        manager.httpManager = [[AFHTTPSessionManager alloc] init];
        //AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerializer = [AFHTTPRequestSerializer serializer];
        //manager.httpManager.requestSerializer = requestSerializer;
        
        // 设置接收数据自动JSON化
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        manager.httpManager.responseSerializer = serializer;
    });
    return manager;
}

-(void)getHomeDataPageNumber:(NSInteger)pageNumber success:(HttpSuccessBlock)sucessBlock failure:(HttpFailureBlock)failureBlock {
//    [self.httpManager GET:@"http://www.guanggoo.com"
//               parameters:nil
//                 progress:nil
//                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                      //NSString *html =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                      if (responseObject) {
//                          TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject];
//                          NSArray *divArr =[hpple searchWithXPathQuery:@"//div"];
//                          for (TFHppleElement *element in divArr) {
//                              if ([element.attributes[@"class"] isEqualToString:@"topic-item"]) {
//                                  NSArray *aArr  = [element searchWithXPathQuery:@"//a"];
//                                  for (TFHppleElement *subElement in aArr) {
//                                      if ([subElement.attributes[@"class"] isEqualToString:@"title"]) {
//                                          
//                                      }
//                                      [subElement searchWithXPathQuery:@""];
//                                  }
//                              }
//                          }
//                          
//                      }
//                      
//                  }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                      NSLog(@"%@",error);
//                  }
//     
//     ];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?p=%ld",BASE_URL,pageNumber];
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    if (!htmlData) {
        return;
    }
    NSMutableArray<HomeDataModel *> *dataArray = [NSMutableArray array];
    NSError *error;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:htmlData error:&error];
    if (error) {
        NSLog(@"error:%@",error);
        if (failureBlock) {
            failureBlock();
        }
    }
    ONOXMLElement *superElement = [doc firstChildWithXPath:@"//*[@class='topics container-box mt10']"];
    [superElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        /html/body/div[1]/div/div[1]/div[2]/div[2]/a/img
//        /html/body/div[1]/div/div[1]/div[2]/div[2]/div[1]/h3
        ONOXMLElement *subImgElement = [element firstChildWithXPath:@"a/img"];
        ONOXMLElement *subTitleElement = [element firstChildWithXPath:@"div[1]/h3/a"];
        //NSLog(@"%@--------",subImgElement);
        if (subImgElement && subTitleElement) {
            HomeDataModel *model = [[HomeDataModel alloc] init];
            model.title = [subTitleElement stringValue];
            model.iconUrl = [subImgElement valueForAttribute:@"src"];
            model.clickUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,[subTitleElement valueForAttribute:@"href"]];
          //  NSLog(@"icon--%@",[subImgElement valueForAttribute:@"src"]);
//            NSLog(@"href--%@",[subTitleElement valueForAttribute:@"href"]);
//            NSLog(@"title--%@",[subTitleElement stringValue]);
            [dataArray addObject:model];
        }
        
    }];
    
    if (sucessBlock) {
        sucessBlock(dataArray);
    }
    
}

@end
