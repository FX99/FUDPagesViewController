//
//  FUDPageViewController.m
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/13.
//  Copyright © 2019 fudo. All rights reserved.
//

#import "FUDPageViewController.h"
#import "FUDScrollView.h"
#import "FUDPageTabCell.h"
#import "FUDPageTabView.h"

@interface FUDPageViewController () <FUDPageTabViewDataSource, FUDPageTabViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) CGSize layoutSize;

@property (nonatomic, strong) FUDScrollView  *contentView;    // 包裹整个页面的纵向滚动视图
@property (nonatomic, strong) FUDPageTabView *pageTabView;    // 各个 page 的选项卡视图
@property (nonatomic, strong) UIView         *separatorView;  // 分隔线
@property (nonatomic, strong) UIScrollView   *pagesView;      // 包裹每个 page 的横向滚动视图

@property (nonatomic, assign) CGFloat        headerHeight;
@property (nonatomic, assign) CGSize         tabItemSize;
@property (nonatomic, assign) CGSize         indicatorSize;
@property (nonatomic, assign) CGPoint        lastScrollOffset;
@property (nonatomic, weak)   UIScrollView   *currentScrollPage;

@end

@implementation FUDPageViewController

- (void)dealloc {
    NSLog(@"FUDPageViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    if (@available(iOS 11.0, *)) {
        self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self.dataSource respondsToSelector:@selector(heightForHeaderViewInPageController:)]) {
        self.headerHeight = [self.dataSource heightForHeaderViewInPageController:self];
    }
    if ([self.dataSource respondsToSelector:@selector(sizeForTabItemInPageController:)]) {
        self.tabItemSize = [self.dataSource sizeForTabItemInPageController:self];
    } else {
        self.tabItemSize = CGSizeMake(100., 40.);
    }
    if ([self.dataSource respondsToSelector:@selector(sizeForIndicatorInPageController:)]) {
        self.indicatorSize = [self.dataSource sizeForIndicatorInPageController:self];
    } else {
        self.indicatorSize = CGSizeMake(50., 3.);
    }
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.contentView];
    if (self.headerView) {
        [self.contentView addSubview:self.headerView];
    }
    
    [self.contentView addSubview:self.pageTabView];
    [self.contentView addSubview:self.separatorView];
    [self.contentView addSubview:self.pagesView];
    
    [self.pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.pagesView addSubview:controller.view];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!CGSizeEqualToSize(self.view.frame.size, self.layoutSize)) {
        self.layoutSize = self.view.frame.size;
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    CGFloat width = self.layoutSize.width;
    CGFloat height = self.layoutSize.height;
    CGFloat topMargin = self.topLayoutGuide.length;
    CGFloat contentH = height - topMargin;
    
    self.contentView.frame = CGRectMake(0, topMargin, width, contentH);
    
    if (self.headerView) {
        self.headerView.frame = CGRectMake(0, 0, width, self.headerHeight);
    } else {
        self.headerHeight = 0;
    }
    
    CGFloat headerH = self.headerHeight;
    CGFloat pageTabH = self.tabItemSize.height + self.indicatorSize.height;
    CGFloat separatorH = 1.;
    
    self.pageTabView.frame = CGRectMake(0, headerH, width, pageTabH);
    
    self.separatorView.frame = CGRectMake(0, headerH + pageTabH, width, separatorH);
    
    CGFloat pageH = contentH - pageTabH - separatorH;
    
    self.pagesView.frame = CGRectMake(0, headerH + pageTabH + separatorH, width, pageH);
    self.pagesView.contentSize = CGSizeMake(width * self.titles.count, pageH);
    
    [self.pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
        controller.view.frame = CGRectMake(idx * width, 0, width, pageH);
    }];
    
    self.contentView.contentSize = CGSizeMake(width, contentH + headerH);
}

#pragma mark - FUDPageTabViewDataSource & FUDPageTabViewDelegate

- (CGSize)sizeForTabItemInPageTabView:(FUDPageTabView *)pageTabView {
    return self.tabItemSize;
}

- (CGSize)sizeForIndicatorInPageTabView:(FUDPageTabView *)pageTabView {
    return self.indicatorSize;
}

- (void)pageTabView:(FUDPageTabView *)pageTabView didSelectTabItemAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(scrollViewAtPageIndex:inPageController:)]) {
        self.currentScrollPage = [self.dataSource scrollViewAtPageIndex:index inPageController:self];
    }
    
    CGFloat width = self.pagesView.bounds.size.width;
    CGFloat height = self.pagesView.bounds.size.height;
    [self.pagesView scrollRectToVisible:CGRectMake(index * width, 0, width, height) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        self.lastScrollOffset = scrollView.contentOffset;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentView && self.currentScrollPage) {
        if (self.contentView.contentOffset.y == 0 && self.currentScrollPage.contentOffset.y <=0) {
            
        } else if (self.lastScrollOffset.y >= 0 && self.lastScrollOffset.y < self.headerHeight) {
            self.currentScrollPage.contentOffset = CGPointMake(0, 0);
        } else if (self.currentScrollPage.contentOffset.y > 0) {
            self.contentView.contentOffset = CGPointMake(0, self.headerHeight);
        }
        
        self.lastScrollOffset = self.contentView.contentOffset;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pagesView) {
        CGPoint pageOffset = scrollView.contentOffset;
        CGFloat pageWidth = self.pagesView.bounds.size.width;
        NSInteger index = (NSInteger)(pageOffset.x / pageWidth);
        if (index == self.pageTabView.selectedIndex) return;
        
        if ([self.dataSource respondsToSelector:@selector(scrollViewAtPageIndex:inPageController:)]) {
            self.currentScrollPage = [self.dataSource scrollViewAtPageIndex:index inPageController:self];
        }
        
        [self.pageTabView selectItemAtIndex:index animated:YES];
    }
}

#pragma mark - Getters && Setters

- (FUDScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[FUDScrollView alloc] init];
        _contentView.delegate = self;
        _contentView.contentInset = UIEdgeInsetsZero;
        _contentView.bounces = NO;
        _contentView.showsVerticalScrollIndicator = NO;
    }
    return _contentView;
}

- (FUDPageTabView *)pageTabView {
    if (!_pageTabView) {
        _pageTabView = [[FUDPageTabView alloc] init];
        _pageTabView.dataSource   = self;
        _pageTabView.delegate     = self;
        _pageTabView.titles       = self.titles;
        _pageTabView.defaultIndex = self.defaultIndex;
    }
    return _pageTabView;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = UIColor.lightGrayColor;
    }
    return _separatorView;
}

- (UIScrollView *)pagesView {
    if (!_pagesView) {
        _pagesView = [[UIScrollView alloc] init];
        _pagesView.delegate = self;
        _pagesView.pagingEnabled = YES;
        _pagesView.bounces = NO;
        _pagesView.showsHorizontalScrollIndicator = NO;
    }
    return _pagesView;
}

@end
