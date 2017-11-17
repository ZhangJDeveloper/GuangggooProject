//
//  TodayViewController.m
//  GuanggoWidget
//
//  Created by ZhangJie on 2017/10/11.
//  Copyright © 2017年 nuoyuan. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>


@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif
    
    [self.view addSubview:self.button];
    [self.view addSubview:self.imageView];
    
}

- (void)clickButton {
    [self.extensionContext openURL:[NSURL URLWithString:@"demo.guanggoo.com://1"] completionHandler:nil];
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        _button.frame = CGRectMake(10, 10, 110, 35);
    }
    return _button;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(120, 10, 100, 100);
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh-mm-ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    [self.button setTintColor:[UIColor grayColor]];
    [self.button setTitle:dateStr forState:UIControlStateNormal];
    //网络请求图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://a1.jikexueyuan.com/home/201508/03/3697/55bee50b58c8b.jpg"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageDate];
            self.imageView.image = image;
        });
    });

}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    switch (activeDisplayMode) {
        case NCWidgetDisplayModeCompact:
            self.preferredContentSize = CGSizeMake(maxSize.width,100);
            //ios10以后，widget的关闭时高度为固定值，设置没效果。
            break;
        case NCWidgetDisplayModeExpanded:
            self.preferredContentSize = CGSizeMake(maxSize.width,400);
            break;
        default:
            break;
    }
    
}
#endif

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh-mm-ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    [self.button setTintColor:[UIColor grayColor]];
    [self.button setTitle:dateStr forState:UIControlStateNormal];
    completionHandler(NCUpdateResultNewData);
    
}

@end
