//
//  ViewController.m
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/11.
//  Copyright © 2019 fudo. All rights reserved.
//

#import "ViewController.h"
#import "FUDPageTabView.h"
#import "FUDTableViewController.h"
#import "FUDPageViewController.h"

@interface ViewController () <FUDPageViewControllerDataSource>

@property (nonatomic, copy) NSArray<UIViewController *> *pages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pages = @[[FUDTableViewController new], [FUDTableViewController new], [FUDTableViewController new], [FUDTableViewController new], [FUDTableViewController new], [FUDTableViewController new], [FUDTableViewController new], [FUDTableViewController new]];
}

- (IBAction)buttonTapped:(id)sender {
    FUDPageViewController *vc = [[FUDPageViewController alloc] init];
    vc.dataSource = self;
    vc.titles = @[@"Home", @"Circle", @"Me", @"asdfsd", @"srergedfd", @"Hahah", @"Er", @"5566"];
    vc.pages = self.pages;
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = UIColor.cyanColor;
    vc.headerView = header;
    //    vc.headerHeight = 200;
    vc.defaultIndex = 0;
    //    vc.pageTabView.normalTitleFont    = [UIFont systemFontOfSize:16.];
    //    vc.pageTabView.selectedTitleFont  = [UIFont boldSystemFontOfSize:16];
    //    vc.pageTabView.normalTitleColor   = UIColor.lightGrayColor;
    //    vc.pageTabView.selectedTitleColor = UIColor.orangeColor;
    //    vc.pageTabView.indicator.backgroundColor = UIColor.orangeColor;
    vc.pageTabView.pageTabView.backgroundColor = UIColor.greenColor;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)heightForHeaderViewInPageController:(FUDPageViewController *)pageController {
    return 150.;
}

- (CGSize)sizeForTabItemInPageController:(FUDPageViewController *)pageController {
    return CGSizeMake(100, 30);
}

- (CGSize)sizeForIndicatorInPageController:(FUDPageViewController *)pageController {
    return CGSizeMake(20, 3);
}

- (UIScrollView *)scrollViewAtPageIndex:(NSInteger)index inPageController:(FUDPageViewController *)pageController {
    return self.pages[index].view.subviews[0];
}

@end
