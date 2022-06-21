//
//  SwitchChainViewController.h
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchChainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) void (^selectHandler) (void);

@end

NS_ASSUME_NONNULL_END
