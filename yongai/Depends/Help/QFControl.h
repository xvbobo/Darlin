//
//  QFControl.h
//  UI11
//
//  Created by qianfeng on 14-8-18.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QFControlDelegate <NSObject>

- (void)imageViewClick:(UIButton*)btn;

@end
@interface QFControl : NSObject
@property (nonatomic,assign) CGFloat font1;
@property (nonatomic,assign) CGFloat font2;
@property (nonatomic,assign) CGFloat font3;
@property (assign,nonatomic) id <QFControlDelegate>delegate;
+ (UIButton *) createButtonWithFrame:(CGRect)frame  title:(NSString *)title  target:(id)target action:(SEL)action tag:(NSUInteger)tag;
+ (UILabel *)createLabelWithFrame:(CGRect)frame  text: (NSString*)text;
+ (UITextField *) createTextFieldWithFrame:(CGRect)frame  placeHolder:(NSString *)placeHolder  borderStyle:(UITextBorderStyle)borderStyle  delegate:(id<UITextFieldDelegate>)delegate    tag:(NSInteger)tag;
+ (void)showAlertViewWithTitle:(NSString*)title  message:(NSString*)message  delegate:(id <UIAlertViewDelegate>)delegate;
+ (UIImageView *)createUIImageViewWithFrame:(CGRect)frame  url: (NSString*)text;
+ (UIImageView *)createUIImageViewWithFrame:(CGRect)frame  imageName: (NSString*)name;
+ (UIButton *) createButtonWithFrame:(CGRect)frame  image:(NSString *)image andSelectedImage:(NSString *)selectedImage  target:(id)target action:(SEL)action tag:(NSUInteger)tag;
+ (UIImageView *)createUIImageViewWithFrame:(CGRect)frame imageName:(NSString *)name withlableText:(NSString *)labeltext withlableFrame:(CGRect)labelFrame;
+ (UIImageView *)createUIImageViewWithFrame:(CGRect)frame imageName:(NSString *)name withStr1:(NSString *)labeltext withStr:(NSString*)str2 withStr3:(NSString *)str3;
+ (UIImageView *)createUIImageFrame:(CGRect)frame imageName:(NSString *)name withStr1:(NSAttributedString *)labeltext withStr:(NSString*)str2 withStr3:(NSString *)str3;
+ (UIImageView *)createUIImageFrame:(CGRect)frame withname:(NSString *)name;
@end
