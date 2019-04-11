//
//  OldChapViewController.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/8.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "OldChapViewController.h"
#import "OldCurOrderViewController.h"

@interface OldChapViewController ()
@property(strong,nonatomic) UIView                *chooseLineView;
@property(strong,nonatomic) UIScrollView          *scrollView;

@end

@implementation OldChapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)clickButton:(UIButton *)btn {
    NSInteger tag = btn.tag;
    CGFloat offsetX = (tag - 100) * MainScreenWith / 2;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.chooseLineView.frame = CGRectMake(offsetX, getRectNavAndStatusHeight, MainScreenWith / 2, 3);
    }];
    
}

- (void)setupUI {
    // 创建控件
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWith - 20, 45)];
    self.navigationItem.titleView = titleView;
    
    UIButton *currentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currentButton setTitle:@"当前订单" forState:UIControlStateNormal];
    [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    currentButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    currentButton.tag = 100;
    [currentButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    currentButton.frame = CGRectMake(0, 0, MainScreenWith / 2 - 20, 45);
    [titleView addSubview:currentButton];

    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [orderButton setTitle:@"订单列表" forState:UIControlStateNormal];
    [orderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    orderButton.tag = 101;
    [orderButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    orderButton.frame = CGRectMake((MainScreenWith - 20) / 2, 0, (MainScreenWith - 20) / 2, 45);
    [titleView addSubview:orderButton];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWith - 20) / 2, 15, 1, 15)];
    lineView.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.00];
    [titleView addSubview:lineView];
    
    _chooseLineView = [[UIView alloc] init];
    _chooseLineView.backgroundColor = [UIColor colorWithRed:0.41 green:0.77 blue:0.84 alpha:1.00];
    _chooseLineView.frame = CGRectMake(0, getRectNavAndStatusHeight, MainScreenWith / 2, 3);
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
    _scrollView.contentSize = CGSizeMake(MainScreenWith * 2, CGRectGetHeight(_scrollView.frame));
    [self.view addSubview:_scrollView];
    
    OldCurOrderViewController *oldCurOrderViewController = [[OldCurOrderViewController alloc] init];
    [self addChildViewController:oldCurOrderViewController];
    oldCurOrderViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [_scrollView addSubview:oldCurOrderViewController.view];
    
    [self.view bringSubviewToFront:_chooseLineView];
}

@end
