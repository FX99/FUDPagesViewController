//
//  FUDScrollView.m
//  FUDTabPages
//
//  Created by 兰福东 on 2019/2/13.
//  Copyright © 2019 fudo. All rights reserved.
//

#import "FUDScrollView.h"

@interface FUDScrollView () <UIGestureRecognizerDelegate>

@end

@implementation FUDScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
