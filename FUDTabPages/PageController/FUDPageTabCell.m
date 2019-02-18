//
//  FUDPageTabCell.m
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/13.
//  Copyright © 2019 fudo. All rights reserved.
//

#import "FUDPageTabCell.h"
#import "FUDPageTabView.h"

@implementation FUDPageTabCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _indicator = [[UIView alloc] init];
        _indicator.backgroundColor = UIColor.redColor;
        _indicator.hidden = YES;
        [self.contentView addSubview:_indicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    CGSize indicatorSize = self.ancientView.indicatorSize;
    
    self.titleLabel.frame = CGRectMake(0, 0, width, height - indicatorSize.height);
    
    CGFloat indicatorX = (width - indicatorSize.width) / 2;
    self.indicator.frame = CGRectMake(indicatorX, height - indicatorSize.height, indicatorSize.width, indicatorSize.height);
    self.indicator.layer.cornerRadius = indicatorSize.height / 2;
}

#pragma mark - Setters & Getters

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.indicator.hidden = NO;
        self.titleLabel.font = self.ancientView.selectedTitleFont;
        self.titleLabel.textColor = self.ancientView.selectedTitleColor ? : UIColor.redColor;
    } else {
        self.indicator.hidden = YES;
        self.titleLabel.font = self.ancientView.normalTitleFont;
        self.titleLabel.textColor = self.ancientView.normalTitleColor;
    }
}

- (void)setAncientView:(FUDPageTabView *)ancientView {
    _ancientView = ancientView;
    if (self.isSelected) {
        self.titleLabel.font = ancientView.selectedTitleFont;
        self.titleLabel.textColor = ancientView.selectedTitleColor ? : UIColor.redColor;
    } else {
        self.titleLabel.font = ancientView.normalTitleFont;
        self.titleLabel.textColor = ancientView.normalTitleColor;
    }
}

@end
