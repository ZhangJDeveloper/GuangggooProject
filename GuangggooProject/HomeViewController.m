//
//  HomeViewController.m
//  GuangggooProject
//
//  Created by ZhangJie on 2017/9/18.
//  Copyright © 2017年 nuoyuan. All rights reserved.
//

#import "HomeViewController.h"
#import "DataManager.h"
#import "HomeDataModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "WebViewController.h"
#import "MBManager.h"

#define kBackgroundColor [UIColor colorWithRed:220/255.0 green:224/255.0 blue:228/255.0 alpha:1.0]

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate, UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"光谷社区";
    self.view.backgroundColor = kBackgroundColor;
    self.pageNumber = 1;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initSetup];
    
    [self.tableView.mj_header beginRefreshing];
    self.tabBarController.delegate = self;
    
}

- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)vc {
    if ([tbc.selectedViewController isEqual:vc] && tbc.selectedIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    return YES;
}



- (void)initSetup {
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.layer.cornerRadius = 5.0;
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
    headerView.backgroundColor = kBackgroundColor;
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
    footerView.backgroundColor = kBackgroundColor;
    self.tableView.tableFooterView = footerView;
    
    __weak __typeof__(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNumber = 1;
        [weakSelf requestHomeDataWithPageNum:self.pageNumber];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestHomeDataWithPageNum:self.pageNumber + 1];
    }];
}

- (void)requestHomeDataWithPageNum:(NSInteger)pageNum {
    __weak __typeof__(self) weakSelf = self;
    [[DataManager manager] getHomeDataPageNumber:pageNum success:^(NSArray *dataArray) {
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        if ([weakSelf.tableView.mj_footer isRefreshing]) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (pageNum == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        [weakSelf.dataArray addObjectsFromArray:dataArray];
        [weakSelf.tableView reloadData];
    } failure:^{
        // [MBProgressHUD HUDForView:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"homeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HomeDataModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDataModel *model = self.dataArray[indexPath.row];
    if (model.clickUrl) {
        WebViewController *webVC = [[WebViewController alloc] initWithURLString:model.clickUrl];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

// peek的代理方法，轻按即可触发弹出vc
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    //通过[previewingContext sourceView]拿到对应的cell的数据；
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    HomeDataModel *model = self.dataArray[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] initWithURLString:model.clickUrl];
    return webVC;
}

// 添加底部菜单(类似于 收藏 喜欢这样)
- (NSArray<id<UIPreviewActionItem>>*)previewActionItems {
    
    return nil;
}

// pop的代理方法，在此处可对将要进入的vc进行处理
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
