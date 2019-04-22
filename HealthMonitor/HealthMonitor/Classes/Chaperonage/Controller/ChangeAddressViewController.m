//
//  ChangeAddressViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/21.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChangeAddressViewController.h"
#import "ChangeAddressTableViewCell.h"
#import "SearchAddressViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <Masonry/Masonry.h>

NSString * const ChangeAddressTableViewCellId = @"ChangeAddressTableViewCellId";

@interface ChangeAddressViewController ()<MAMapViewDelegate , UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, UISearchControllerDelegate> {
    NSIndexPath          *_preIndexPath;
}
@property(strong,nonatomic) UISearchController          *searchController;
@property(strong,nonatomic) UITableView                 *topTableView;
@property(strong,nonatomic) MAMapView                   *mapView;
@property(strong,nonatomic) UITableView                 *tableView;
@property(strong,nonatomic) AMapSearchAPI               *search;
@property(strong,nonatomic) NSMutableArray<AMapPOI *>   *poiArray;
//@property(strong,nonatomic) UIBarButtonItem             *returnButton;
//@property(strong,nonatomic) UIBarButtonItem             *chooseButton;
//@property(strong,nonatomic) UIView                      *titleView;

@end

@implementation ChangeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _poiArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = self.userCoordinate;
    [_mapView addAnnotation:annotation];
    
    _mapView.centerCoordinate = annotation.coordinate;
    
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.userCoordinate.latitude longitude:self.userCoordinate.longitude];
    request.sortrule = 0;
    request.requireExtension = YES;
    
    [self.search AMapPOIAroundSearch:request];
    
    SearchAddressViewController *vc = (SearchAddressViewController *) _searchController.searchResultsController;
    vc.city = _city;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)clickChoose {
    NSLog(@"确定");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_searchBar resignFirstResponder];
//}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    
    if (response.pois.count == 0) {
        return;
    }
    
    for (AMapPOI *poi in response.pois) {
        [_poiArray addObject:poi];
    }
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChangeAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChangeAddressTableViewCellId forIndexPath:indexPath];
    
    cell.titleLabel.text = _poiArray[indexPath.row].name;
    cell.addressLabel.text = _poiArray[indexPath.row].address;
    if (indexPath != _preIndexPath) {
        cell.chooseImageView.hidden = YES;
    }else {
        cell.chooseImageView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_preIndexPath != nil) {
        ChangeAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:_preIndexPath];
        cell.chooseImageView.hidden = YES;
    }
    
    ChangeAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.chooseImageView.hidden = NO;
    _preIndexPath = indexPath;
    
    [_mapView removeAnnotations:_mapView.annotations];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(_poiArray[indexPath.row].location.latitude, _poiArray[indexPath.row].location.longitude);
    [_mapView addAnnotation:annotation];
    
    [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (searchBar.text.length == 0 || (_preLength != 0 && _preLength > searchBar.text.length)) {
//        [_delegate didCleanText];
//    }
//
//    _preLength = searchBar.text.length;
//}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    _searchBar.showsCancelButton = NO;
//    _searchBar.text = @"";
//    self.childViewControllers[0].view.hidden = YES;
//    [_delegate didClickCancelButton];
//    self.navigationItem.leftBarButtonItem = _returnButton;
//    self.navigationItem.rightBarButtonItem = _chooseButton;
////    [_titleView removeFromSuperview];
//    _titleView.hidden = YES;
//    [_searchBar removeFromSuperview];
//    [self.view addSubview:_searchBar];
//
//    [_searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.mas_equalTo(44.f);
//    }];
//
////    [_searchBar resignFirstResponder];
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _searchController.searchBar.showsCancelButton = YES;
    UIButton *btn = [_searchController.searchBar valueForKey:@"cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [_delegate didClickSearchWithAddress:searchBar.text City:_city];
//
//    [_searchBar resignFirstResponder];
//}

- (void)willPresentSearchController:(UISearchController *)searchController {
    [_mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(300.f);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [_mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight + CGRectGetHeight(self.searchController.searchBar.frame));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(300.f);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"locationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"location"];
        
        return annotationView;
    }
    
    return nil;
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
    self.title = @"修改地址";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrows_left"] style:UIBarButtonItemStylePlain target:self action:@selector(clickReturn)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickChoose)];
    
    // 创建控件
//    _searchBar = [[UISearchBar alloc] init];
//    _searchBar.placeholder = @"搜索地点";
//    _searchBar.delegate = self;
//    _searchBar.backgroundImage = [UIImage imageNamed:@"background"];
//    _searchBar.barStyle = UISearchBarStyleDefault;
//    _searchBar.tintColor = [UIColor blackColor];
//    [self.view addSubview:_searchBar];
    
    SearchAddressViewController *vc = [[SearchAddressViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
    _searchController.searchResultsUpdater = (id<UISearchResultsUpdating>)vc;
    _searchController.delegate = self;
    [self.view addSubview:_searchController.searchBar];
    
    _searchController.searchBar.backgroundImage = [UIImage imageNamed:@"background"];
    _searchController.searchBar.tintColor = [UIColor blackColor];
    _searchController.searchBar.placeholder = @"搜索地点";
    _searchController.searchBar.delegate = self;
    
    _topTableView = [[UITableView alloc] init];
    _topTableView.scrollEnabled = NO;
    _topTableView.tableFooterView = [[UIView alloc] init];
    _topTableView.tableHeaderView = _searchController.searchBar;
    [self.view addSubview:_topTableView];
    
    _mapView = [[MAMapView alloc] init];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.showsUserLocation = NO;
    _mapView.delegate = self;
    [_mapView setZoomLevel:15.f];
    [self.view addSubview:_mapView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[ChangeAddressTableViewCell class] forCellReuseIdentifier:ChangeAddressTableViewCellId];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
//    SearchAddressViewController *vc = [[SearchAddressViewController alloc] init];
//    [self addChildViewController:vc];
//    self.delegate = (id<ChangeAddressViewControllerDelegate>)vc;
//    vc.view.hidden = YES;
//    [self.view addSubview:vc.view];
    
    // 添加布局
    [_topTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(CGRectGetHeight(self.searchController.searchBar.frame));
    }];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTableView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(300.f);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
//    [_searchController.searchResultsController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.searchController.view);
//    }];
}

@end

