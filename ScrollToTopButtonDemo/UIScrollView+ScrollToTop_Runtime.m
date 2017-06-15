//
//  UIScrollView+ScrollToTop_Runtime.m
//  UDPhone
//
//  Created by 江顺金 on 2017/6/7.
//  Copyright © 2017年 115.com. All rights reserved.
//

#import "UIScrollView+ScrollToTop_Runtime.h"
#import <objc/runtime.h>
#import "ScrollToTopButtonDemo-Swift.h"

@implementation UIView (ScrollToTop_Runtime)

+ (void)load {
    Method ori_Method = class_getInstanceMethod([UIView class], @selector(didMoveToSuperview));
    
    Method ud_Mothod = class_getInstanceMethod([UIView class], @selector(ud_didMoveToSuperview));
    
    method_exchangeImplementations(ori_Method, ud_Mothod);
}

- (void)ud_didMoveToSuperview {
    [self ud_didMoveToSuperview];
    
    if (self.superview && ([self isMemberOfClass:[UITableView class]])) {
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:[ScrollToTopButton class]]) {
                return;
            }
        }
        ScrollToTopButton *scrollToTopBtn = [[ScrollToTopButton alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.size.height, 48, 48) scrollView:(UIScrollView *)self];
        NSLog(@"%@", scrollToTopBtn);
    }
}

@end
