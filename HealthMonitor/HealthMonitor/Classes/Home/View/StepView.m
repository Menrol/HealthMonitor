//
//  StepView.m
//  HealthMonitor
//
//  Created by WRQ on 2019/4/10.
//  Copyright © 2019 WRQ. All rights reserved.
//

#import "StepView.h"
#import "HistogramCollectionViewCell.h"
#import <HealthKit/HealthKit.h>
#import <Masonry/Masonry.h>

NSString *HistogramCollectionViewCellID = @"HistogramCollectionViewCellID";

@interface StepView()<UICollectionViewDataSource>
@property(strong,nonatomic) UILabel             *stepCountLabel;

@end

@implementation StepView

- (instancetype)init {
    self = [super init];
    if (self) {
        _stepArray = [[NSMutableArray alloc] init];
        // TODO: 测试数据
        [_stepArray addObject:@"20000"];
        [_stepArray addObject:@"1000"];
        [_stepArray addObject:@"1000"];
        [_stepArray addObject:@"3000"];
        [_stepArray addObject:@"4000"];
        [_stepArray addObject:@"11000"];
        [_stepArray addObject:@"2000"];
        [_stepArray addObject:@"3000"];
        [_stepArray addObject:@"3000"];
        [_stepArray addObject:@"3000"];
        [_stepArray addObject:@"1500"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        [_stepArray addObject:@"6000"];
        
        [self setupUI];
    }
    
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stepArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistogramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HistogramCollectionViewCellID forIndexPath:indexPath];
    int stepCount = [_stepArray[indexPath.row] intValue];
    CGFloat height = stepCount / 20000.f * CGRectGetHeight(cell.frame);
    cell.hostogramView.frame = CGRectMake(0, CGRectGetHeight(cell.frame) - height, CGRectGetWidth(cell.frame), height);
    
    return cell;
}


- (void)setupUI {
    // 创建控件
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"今日步数";
    titleLabel.font = [UIFont systemFontOfSize:25.f];
    [self addSubview:titleLabel];
    
    _stepCountLabel = [[UILabel alloc]init];
    _stepCountLabel.text = @"3201";
    _stepCountLabel.font = [UIFont boldSystemFontOfSize:45.f];
    [self addSubview:_stepCountLabel];
    
    UILabel *stepLabel = [[UILabel alloc] init];
    stepLabel.text = @"步";
    stepLabel.font = [UIFont systemFontOfSize:25.f];
    [self addSubview:stepLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(15, 180);
    layout.minimumInteritemSpacing = 5;
    
    _histogramView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _histogramView.dataSource = self;
    _histogramView.showsHorizontalScrollIndicator = NO;
    _histogramView.backgroundColor = [UIColor whiteColor];
    [_histogramView registerClass:[HistogramCollectionViewCell class] forCellWithReuseIdentifier:HistogramCollectionViewCellID];
    [self addSubview:_histogramView];
    
    
    // 设置布局
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15.f);
        make.left.equalTo(self.mas_left).offset(15.f);
        make.height.mas_equalTo(25.f);
    }];
    
    [_stepCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10.f);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(45.f);
    }];
    
    [stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepCountLabel.mas_right).offset(10.f);
        make.top.equalTo(titleLabel.mas_top);
        make.height.mas_equalTo(25.f);
    }];
    
    [_histogramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15.f);
        make.left.equalTo(self.mas_left).offset(15.f);
        make.right.equalTo(self.mas_right).offset(-15.f);
        make.height.mas_equalTo(180.f);
    }];
}

@end
