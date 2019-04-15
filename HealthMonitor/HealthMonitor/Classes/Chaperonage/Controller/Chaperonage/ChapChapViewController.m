//
//  ChapChapViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/15.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "ChapChapViewController.h"
#import "ChapCurOrderViewController.h"

@interface ChapChapViewController ()
@property(strong,nonatomic) UIView                *chooseLineView;
@property(strong,nonatomic) UIScrollView          *scrollView;

@end

@implementation ChapChapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickButton:(UIButton *)btn {
    NSInteger tag = btn.tag;
    CGFloat offsetX = (tag - 100) * MainScreenWith / 3;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.chooseLineView.frame = CGRectMake(offsetX, getRectNavAndStatusHeight, MainScreenWith / 3, 3);
    }];
    
//    CGFloat scrollOffsetX = (tag - 100) * MainScreenWith;
//    [_scrollView setContentOffset:CGPointMake(scrollOffsetX, 0) animated:YES];
    
}

- (void)setupUI {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWith, 45)];
    self.navigationItem.titleView = titleView;
    
    UIButton *currentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currentButton setTitle:@"当前订单" forState:UIControlStateNormal];
    [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    currentButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    currentButton.tag = 100;
    [currentButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    currentButton.frame = CGRectMake(0, 0, (MainScreenWith - 20) / 3, 45);
    [titleView addSubview:currentButton];
    
    UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [receiveButton setTitle:@"接单" forState:UIControlStateNormal];
    [receiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    receiveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    receiveButton.tag = 101;
    [receiveButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    receiveButton.frame = CGRectMake((MainScreenWith - 20) / 3, 0, (MainScreenWith - 20) / 3, 45);
    [titleView addSubview:receiveButton];
    
    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [orderButton setTitle:@"订单列表" forState:UIControlStateNormal];
    [orderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    orderButton.tag = 102;
    [orderButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    orderButton.frame = CGRectMake((MainScreenWith - 20) / 3 * 2, 0, (MainScreenWith - 20) / 3, 45);
    [titleView addSubview:orderButton];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWith - 20) / 3, 15, 1, 15)];
    leftLineView.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00];
    [titleView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWith - 20) / 3 * 2, 15, 1, 15)];
    rightLineView.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00];
    [titleView addSubview:rightLineView];
    
    _chooseLineView = [[UIView alloc] init];
    _chooseLineView.backgroundColor = [UIColor colorWithRed:0.41 green:0.77 blue:0.84 alpha:1.00];
    _chooseLineView.frame = CGRectMake(0, getRectNavAndStatusHeight, MainScreenWith / 3, 3);
    [self.view addSubview:_chooseLineView];
    
    CGFloat navAndStatusHeight = getRectNavAndStatusHeight;
    CGFloat tabBarHeight = TabBarHeight;
    CGFloat screenHeight = MainScreenHeight;
    CGFloat height = screenHeight - tabBarHeight - navAndStatusHeight;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHeight, MainScreenWith, height)];
    _scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    _scrollView.layer.borderWidth = 0.5;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.contentSize = CGSizeMake(MainScreenWith * 3, CGRectGetHeight(_scrollView.frame));
    [self.view addSubview:_scrollView];
    
    [self.view bringSubviewToFront:_chooseLineView];
    
    ChapCurOrderViewController *chapCurOrderViewController = [[ChapCurOrderViewController alloc] init];
    [self addChildViewController:chapCurOrderViewController];
    chapCurOrderViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [_scrollView addSubview:chapCurOrderViewController.view];
}

@end
