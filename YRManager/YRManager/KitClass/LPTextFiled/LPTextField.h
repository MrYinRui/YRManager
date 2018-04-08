//
//  LPTextField.h
//  Lodger-Pad
//
//  Created by xun on 10/20/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPTextField : UITextField

@property (nonatomic, assign) CGRect rectForText;

- (LPTextField * (^)(CGRect rect))b_rectForText;

/**
 校验字符串是否合法

 @param str 被校验字符串，如果为空表示校验self.text

 @return 是否有效
 */
- (BOOL)validString:(NSString *)str;

@end


/**
 校验码TF
 */
@interface LPValidCodeTF : LPTextField

@end


/**
 手机号TF
 */
@interface LPPhoneTF : LPTextField

@end


/**
 密码TF
 */
@interface LPPwdTF : LPTextField

@end


/**
 IP地址TF
 */
@interface LPIPTF : LPTextField

@end


/**
 数字TF
 */
@interface LPNumberTF : LPTextField

@end

/**
 文字TF（不含表情或全部空格）
 */
@interface LPWordTF : LPTextField

@end
