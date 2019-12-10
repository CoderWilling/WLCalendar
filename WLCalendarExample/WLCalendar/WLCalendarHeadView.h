//
//  WLCalendarHeadView.h
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLCalendarHeadView : UIView
/*从XIB中寻找 **/
+ (instancetype)viewForXib;
@property (weak, nonatomic) IBOutlet UILabel *nub1;
@property (weak, nonatomic) IBOutlet UILabel *nub2;
@property (weak, nonatomic) IBOutlet UILabel *nub3;
@property (weak, nonatomic) IBOutlet UILabel *nub4;
@property (weak, nonatomic) IBOutlet UILabel *nub5;
@property (weak, nonatomic) IBOutlet UILabel *nub6;
@property (weak, nonatomic) IBOutlet UILabel *nub7;
@end

NS_ASSUME_NONNULL_END
