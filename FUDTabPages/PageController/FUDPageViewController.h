//
//  FUDPageViewController.h
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/13.
//  Copyright © 2019 fudo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUDPageTabView;
@class FUDPageViewController;

@protocol FUDPageViewControllerDataSource <NSObject>

- (CGFloat)heightForHeaderViewInPageController:(FUDPageViewController *)pageController;
- (CGSize)sizeForTabItemInPageController:(FUDPageViewController *)pageController;
- (CGSize)sizeForIndicatorInPageController:(FUDPageViewController *)pageController;

@required
// 返回每个 page 的主要 scrollView，没有 scrollView 则返回 nil
- (UIScrollView *)scrollViewAtPageIndex:(NSInteger)index inPageController:(FUDPageViewController *)pageController;

@end

@interface FUDPageViewController : UIViewController

@property (nonatomic, weak)             id<FUDPageViewControllerDataSource> dataSource;
@property (nonatomic, strong)           UIView                              *headerView;     // 头部视图
@property (nonatomic, strong, readonly) FUDPageTabView                      *pageTabView;    // 各个 page 的选项卡视图
@property (nonatomic, strong, readonly) UIView                              *separatorView;  // 分隔线
@property (nonatomic, copy)             NSArray<NSString *>                 *titles;
@property (nonatomic, copy)             NSArray<UIViewController *>         *pages;
@property (nonatomic, assign)           NSInteger                           defaultIndex;

@end


