//
//  FUDPageTabView.m
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/14.
//  Copyright © 2019 fudo. All rights reserved.
//

#import "FUDPageTabView.h"
#import "FUDPageTabCell.h"

@interface FUDPageTabView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *pageTabView;
@property (nonatomic, strong) UIScrollView *indicatorView;
@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGSize    tabItemSize;
@property (nonatomic, assign) CGSize    indicatorSize;

@end

@implementation FUDPageTabView

- (void)dealloc {
    [self.pageTabView removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"FUDPageTabView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        _selectedIndex = -1;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _pageTabView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_pageTabView registerClass:[FUDPageTabCell class] forCellWithReuseIdentifier:@"FUDPageTabCell"];
        _pageTabView.bounces = NO;
        _pageTabView.delegate = self;
        _pageTabView.dataSource = self;
        _pageTabView.backgroundColor = UIColor.whiteColor;
        _pageTabView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_pageTabView];
        
        _indicatorView = [[UIScrollView alloc] init];
        _indicatorView.bounces = NO;
        _indicatorView.delegate = self;
        _indicatorView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_indicatorView];
        
        _indicator = [[UIView alloc] init];
        _indicator.backgroundColor = UIColor.redColor;
        [_indicatorView addSubview:_indicator];
        
        [_pageTabView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_pageTabView addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
        
        _indicatorView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    
    if ([self.dataSource respondsToSelector:@selector(sizeForTabItemInPageTabView:)]) {
        self.tabItemSize = [self.dataSource sizeForTabItemInPageTabView:self];
    } else {
        self.tabItemSize = CGSizeMake(100., 40.);
    }
    if ([self.dataSource respondsToSelector:@selector(sizeForIndicatorInPageTabView:)]) {
        self.indicatorSize = [self.dataSource sizeForIndicatorInPageTabView:self];
    } else {
        self.indicatorSize = CGSizeMake(100., 40.);
    }
    
    self.pageTabView.frame = CGRectMake(0, 0, width, self.tabItemSize.height + self.indicatorSize.height);
    
    self.indicatorView.frame = CGRectMake(0, self.tabItemSize.height, width, self.indicatorSize.height);
    self.indicatorView.contentSize = CGSizeMake(self.titles.count * self.tabItemSize.width, self.indicatorSize.height);
    
    CGFloat indicatorX = self.selectedIndex * self.tabItemSize.width + (self.tabItemSize.width - self.indicatorSize.width) / 2;
    self.indicator.layer.cornerRadius = self.indicatorSize.height / 2;
    self.indicator.frame = CGRectMake(indicatorX, 0, self.indicatorSize.width, self.indicatorSize.height);
    
    [self selectItemAtIndex:self.defaultIndex animated:NO];
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.pageTabView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:self.pageTabView didSelectItemAtIndexPath:indexPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.pageTabView) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            [self.indicatorView setContentOffset:self.pageTabView.contentOffset animated:NO];
        } else if ([keyPath isEqualToString:@"backgroundColor"]) {
            self.indicatorView.backgroundColor = self.pageTabView.backgroundColor;
        }
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tabItemSize.width, self.tabItemSize.height + self.indicatorSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUDPageTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUDPageTabCell" forIndexPath:indexPath];
    cell.ancientView = self;
    cell.titleLabel.text = self.titles[indexPath.item];
    cell.indicator.backgroundColor = self.indicator.backgroundColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath.item) return;
    self.selectedIndex = indexPath.item;
    self.indicatorView.hidden = NO;
    
    CGFloat indicatorX = self.selectedIndex * self.tabItemSize.width + (self.tabItemSize.width - self.indicatorSize.width) / 2;
    [UIView animateWithDuration:0.2 animations:^{
        self.indicator.frame = CGRectMake(indicatorX, 0, self.indicatorSize.width, self.indicatorSize.height);
    } completion:^(BOOL finished) {
        self.indicatorView.hidden = YES;
    }];
    
    if ([self.delegate respondsToSelector:@selector(pageTabView:didSelectTabItemAtIndex:)]) {
        [self.delegate pageTabView:self didSelectTabItemAtIndex:self.selectedIndex];
    }
}

@end
