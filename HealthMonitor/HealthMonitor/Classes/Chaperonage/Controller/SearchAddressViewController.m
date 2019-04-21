//
//  SearchAddressViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/21.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "SearchAddressViewController.h"
#import "ChangeAddressTableViewCell.h"
#import "ChangeAddressViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>

NSString * const SearchAddressTableViewCellId = @"SearchAddressTableViewCellId";

@interface SearchAddressViewController ()<UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, ChangeAddressViewControllerDelegate>
@property(strong,nonatomic) UITableView                   *tableView;
@property(strong,nonatomic) NSMutableArray<AMapPOI *>     *poiArray;
@property(strong,nonatomic) AMapSearchAPI                 *search;
@property(strong,nonatomic) UILabel                       *noResultLabel;

@end

@implementation SearchAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _poiArray = [[NSMutableArray alloc] init];
}

- (void)removeData {
    [_poiArray removeAllObjects];
    [_tableView reloadData];
    _noResultLabel.hidden = YES;
}

- (void)didCleanText {
    [self removeData];
}

- (void)didClickCancelButton {
   [self removeData];
}

- (void)didClickSearchWithAddress:(NSString *)address City:(nonnull NSString *)city{
    [self removeData];
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = address;
    request.city = city;
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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchAddressTableViewCellId forIndexPath:indexPath];
    
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
    [_tableView registerClass:[ChangeAddressTableViewCell class] forCellReuseIdentifier:SearchAddressTableViewCellId];
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
        make.edges.equalTo(self.view);
    }];
    
    [_noResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20.f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
}

@end
