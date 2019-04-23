//
//  SearchResultViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/21.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ChangeAddressTableViewCell.h"
#import "ChangeAddressViewController.h"
#import <Masonry/Masonry.h>

NSString * const SearchResultTableViewCellId = @"SearchAddressTableViewCellId";

@interface SearchResultViewController ()<UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, UISearchResultsUpdating>
@property(strong,nonatomic) UITableView                   *tableView;
@property(strong,nonatomic) NSMutableArray<AMapPOI *>     *poiArray;
@property(strong,nonatomic) AMapSearchAPI                 *search;
@property(strong,nonatomic) UILabel                       *noResultLabel;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
        
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _poiArray = [[NSMutableArray alloc] init];
}

- (void)removeData {
    [_poiArray removeAllObjects];
    [_tableView reloadData];
    _noResultLabel.hidden = YES;
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    
    [self removeData];
    
    if (searchController.searchBar.text.length == 0) {
        return;
    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = searchController.searchBar.text;
    request.city = _city;
    request.requireExtension = YES;
    request.cityLimit = YES;
    request.requireSubPOIs = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        [self removeData];
        NSLog(@"无结果");
        _noResultLabel.hidden = NO;
        return;
    }
    
    for (AMapPOI *poi in response.pois) {
        [_poiArray addObject:poi];
    }
    
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AMapPOI *poi = _poiArray[indexPath.row];
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@",poi.province,poi.city,poi.district,poi.address,poi.name];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    
    [_delegate didSelectTablViewWithAddress:address coordinate:coordinate];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchResultTableViewCellId forIndexPath:indexPath];
    
    cell.titleLabel.text = _poiArray[indexPath.row].name;
    cell.addressLabel.text = _poiArray[indexPath.row].address;
    
    return cell;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    
    return _search;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建控件
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_tableView registerClass:[ChangeAddressTableViewCell class] forCellReuseIdentifier:SearchResultTableViewCellId];
    [self.view addSubview:_tableView];
    
    _noResultLabel = [[UILabel alloc] init];
    _noResultLabel.text = @"未搜索到结果";
    _noResultLabel.textColor = [UIColor blackColor];
    _noResultLabel.font = [UIFont systemFontOfSize:20.f];
    _noResultLabel.textAlignment = NSTextAlignmentCenter;
    _noResultLabel.hidden = YES;
    [self.view addSubview:_noResultLabel];
    
    // 添加布局
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [_noResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight + 20 + [[UIApplication sharedApplication] statusBarFrame].size.height);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
}

@end
