//
//  WLCalendarCollectionViewCell.h
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Height_NavBar (iPhoneX_later ? 88.0f: 64.0f)
#define WLScreenW [UIScreen mainScreen].bounds.size.width
#define WLScreenH [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN
@class WLCalendarItem;
@interface WLCalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (nonatomic, strong) WLCalendarItem *item;
@property (nonatomic, assign) NSInteger chooseType;
@property (nonatomic, strong) UIColor * selectedColor;//选中色
@property (nonatomic, strong) UIColor * normalColor;//默认色

@end

NS_ASSUME_NONNULL_END
