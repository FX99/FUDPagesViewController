//
//  FUDPageTabCell.h
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/13.
//  Copyright © 2019 fudo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUDPageTabView;

@interface FUDPageTabCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, weak)   FUDPageTabView *ancientView; // 主要用来配置 cell 的样式

@end

NS_ASSUME_NONNULL_END
