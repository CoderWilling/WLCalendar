//
//  WLCalendarItem.h
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLCalendarItem : NSObject
/*标题 */
@property(nonatomic,assign)NSInteger nubTitle;
/**是否选中 */
@property (nonatomic, assign)BOOL isSelect;
/**设置圆角 */
@property (nonatomic, assign)BOOL isRadius;
/**开始圆角 */
@property (nonatomic, assign)BOOL isStartRadius;
/**结束圆角 */
@property (nonatomic, assign)BOOL isEndRadius;
/**是否隐藏 */
@property (nonatomic, assign)BOOL isHidden;
/*年 */
@property(nonatomic,assign)NSInteger nubYear;
/*月 */
@property(nonatomic,assign)NSInteger nubMonth;
/*周末 */
@property(nonatomic,assign)BOOL isWeekend;
@end

NS_ASSUME_NONNULL_END
