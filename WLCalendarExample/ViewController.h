//
//  ViewController.h
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
// 弱引用
#define ac_WeakSelf    __weak typeof(self) weakSelf = self;
#define WLScreenW [UIScreen mainScreen].bounds.size.width
#define WLScreenH [UIScreen mainScreen].bounds.size.height
@end

