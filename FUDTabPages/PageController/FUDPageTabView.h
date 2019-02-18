//
//  FUDPageTabView.h
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/14.
//  Copyright © 2019 fudo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUDPageTabView;

@protocol FUDPageTabViewDataSource <NSObject>

- (CGSize)sizeForTabItemInPageTabView:(FUDPageTabView *)pageTabView;
- (CGSize)sizeForIndicatorInPageTabView:(FUDPageTabView *)pageTabView;

@end

@protocol FUDPageTabViewDelegate <NSObject>

- (void)pageTabView:(FUDPageTabView *)pageTabView didSelectTabItemAtIndex:(NSInteger)index;

@end

@interface FUDPageTabView : UIView

@property (nonatomic, weak)   id<FUDPageTabViewDataSource> dataSource;
@property (nonatomic, weak)   id<FUDPageTabViewDelegate>   delegate;
@property (nonatomic, strong) NSArray<NSString *>          *titles;
@property (nonatomic, assign) NSInteger                    defaultIndex;
@property (nonatomic, strong) UIColor                      *normalTitleColor;
@property (nonatomic, strong) UIColor                      *selectedTitleColor;
@property (nonatomic, strong) UIFont                       *normalTitleFont;
@property (nonatomic, strong) UIFont                       *selectedTitleFont;

@property (nonatomic, assign, readonly) CGSize           indicatorSize;
@property (nonatomic, assign, readonly) NSInteger        selectedIndex;
@property (nonatomic, strong, readonly) UICollectionView *pageTabView;
@property (nonatomic, strong, readonly) UIScrollView     *indicatorView;
@property (nonatomic, strong, readonly) UIView           *indicator;

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
