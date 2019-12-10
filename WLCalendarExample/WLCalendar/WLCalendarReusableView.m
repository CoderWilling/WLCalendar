//
//  WLCalendarReusableView.m
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import "WLCalendarReusableView.h"
@interface WLCalendarReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
@implementation WLCalendarReusableView
- (void)showTimeLabelWithArray:(NSArray *)array {
    self.timeLabel.text = [NSString stringWithFormat:@"%@年%@月", array[0], array[1]];
}
 
@end
