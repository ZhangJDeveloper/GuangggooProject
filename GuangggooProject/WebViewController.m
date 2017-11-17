//
//  WebViewController.m
//  GuangggooProject
//
//  Created by ZhangJie on 2017/9/19.
//  Copyright © 2017年 nuoyuan. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlString;
@end

@implementation WebViewController

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [super init]) {
        _urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:self.progressView];
    
    if (self.urlString) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        [self.webView loadRequest:request];
    }
}

- (UIProgressView*)progressView {
    if (!_progressView ) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.frame = CGRectMake(0, 64, self.view.frame.size.width, 1);
    }
    
    return _progressView;
}

- (void)observeValueForKeyPath:(NSString* )keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object ==_webView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            
            if(self.webView.estimatedProgress >=1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}

- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    
//    if (loadCount == 0) {
//        self.progressView.hidden = YES;
//        [self.progressView setProgress:0 animated:NO];
//    }else {
//        self.progressView.hidden = NO;
//        CGFloat oldP = self.progressView.progress;
//        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
//        if (newP > 0.95) {
//            newP = 0.95;
//        }
//        [self.progressView setProgress:newP animated:YES];
    
//    }
}

// 页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    self.loadCount ++;
//}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"%f",self.progressView.progress);
//    self.progressView.hidden = YES;
//}
// 内容返回时
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    self.loadCount --;
//}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.loadCount --;
    NSLog(@"%@",error);
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.frame = self.view.bounds;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
