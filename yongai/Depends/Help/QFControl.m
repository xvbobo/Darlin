//
//  QFControl.m
//  UI11
//
//  Created by qianfeng on 14-8-18.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "QFControl.h"

@implementation QFControl
+ (UIButton *) createButtonWithFrame:(CGRect)frame  title:(NSString *)title  target:(id)target action:(SEL)action tag:(NSUInteger)tag
{
    UIButton *button=[UIButton  buttonWithType:UIButtonTypeSystem];
    button.frame=frame;
    [button  setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button  addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.tag= tag;
    button.backgroundColor = [UIColor clearColor];
    return button;
}
+ (UILabel *)createLabelWithFrame:(CGRect)frame  text: (NSString*)text
{
    UILabel *label=[[UILabel alloc] initWithFrame:frame] ;
    label.text=text;
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    return label;
}
+ (UITextField *) createTextFieldWithFrame:(CGRect)frame  placeHolder:(NSString *)placeHolder  borderStyle:(UITextBorderStyle)borderStyle   delegate:(id<UITextFieldDelegate>)delegate    tag:(NSInteger)tag
{
    UITextField *textField=[[UITextField  alloc] initWithFrame:frame];
    textField.placeholder=placeHolder;
    textField.borderStyle=borderStyle;
    textField.autocorrectionType=UITextAutocorrectionTypeNo;
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    textField.tag=tag;
    textField.delegate=delegate;
    textField.clearsOnBeginEditing=YES;
    textField.clearButtonMode=UITextFieldViewModeAlways;
    return textField;
}
+ (void)showAlertViewWithTitle:(NSString*)title  message:(NSString*)message  delegate:(id <UIAlertViewDelegate>)delegate
{
    UIAlertView *av=[[UIAlertView alloc]  initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    
}
+ (UIImageView *) createUIImageViewWithFrame:(CGRect)frame url:(NSString *)text
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImageWithURL:[NSURL URLWithString:text] placeholderImage:[UIImage imageNamed:Default_GoodsHead]];
    return imageView;
}
+ (UIImageView *)createUIImageViewWithFrame:(CGRect)frame imageName:(NSString *)name
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:name];
    return imageView;
}
+ (UIButton *) createButtonWithFrame:(CGRect)frame  image:(NSString *)image andSelectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action tag:(NSUInteger)tag
{
    UIButton *button=[UIButton  buttonWithType:UIButtonTypeSystem];
    button.frame=frame;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button  addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.tag=tag;
    return button;
}
+(UIImageView *)createUIImageViewWithFrame:(CGRect)frame imageName:(NSString *)name withlableText:(NSString *)labeltext withlableFrame:(CGRect)labelFrame
{
    UIImageView * image = [[UIImageView alloc]initWithFrame:frame];
    image.image = [UIImage imageNamed:name];
    UILabel * label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = labeltext;
    [image addSubview:label];
    return image;
}
+ (UIImageView *)createUIImageViewWithFrame:(CGRect)frame imageName:(NSString *)name withStr1:(NSString *)labeltext withStr:(NSString*)str2 withStr3:(NSString *)str3
{
     UIImageView * image = [[UIImageView alloc] initWithFrame:frame];
    image.image = [UIImage imageNamed:name];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10,image.frame.size.height/2-20, image.frame.size.width-20, 20)];
    label.textColor = BLACKTEXT;
    label.text = labeltext;
    label.textAlignment = NSTextAlignmentCenter;
    [image addSubview:label];
    UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, 15)];
    lable1.textColor = TEXT;
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.font = [UIFont systemFontOfSize:13];
    lable1.text = str2;
    [image addSubview:lable1];
    UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(lable1.frame.origin.x, lable1.frame.origin.y+30, lable1.frame.size.width,20)];
    lable2.textColor = beijing;
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.font = [UIFont systemFontOfSize:20];
    lable2.text = str3;
    [image addSubview:lable2];
    return image;
}
+ (UIImageView *)createUIImageFrame:(CGRect)frame imageName:(NSString *)name withStr1:(NSAttributedString *)labeltext withStr:(NSString *)str2 withStr3:(NSString *)str3
{
    UIImageView * image = [[UIImageView alloc] initWithFrame:frame];
    image.image = [UIImage imageNamed:name];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10,image.frame.size.height/2-20, image.frame.size.width-20, 20)];
    label.textColor = BLACKTEXT;
    [label setAttributedText:labeltext];
    label.textAlignment = NSTextAlignmentCenter;
    [image addSubview:label];
    UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, 15)];
    lable1.textColor = TEXT;
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.font = [UIFont systemFontOfSize:13];
    lable1.text = str2;
    [image addSubview:lable1];
    UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(lable1.frame.origin.x, lable1.frame.origin.y+30, lable1.frame.size.width,20)];
    lable2.textColor = beijing;
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.font = [UIFont systemFontOfSize:20];
    lable2.text = str3;
    [image addSubview:lable2];
    return image;
}
+ (UIImageView *)createUIImageFrame:(CGRect)frame withname:(NSString *)name
{
    UIImageView * dashangImage = [[UIImageView alloc] initWithFrame:frame];
    if ([name isEqualToString:@"打赏"]) {
        UIImageView * jinbiImage = [[UIImageView alloc] initWithFrame:CGRectMake(dashangImage.frame.size.width/4-3, 15, 17,17)];
        jinbiImage.image = [UIImage imageNamed:@"金币(1)"];
        [dashangImage addSubview:jinbiImage];
        UILabel * jinbiLabel = [[UILabel alloc] initWithFrame:CGRectMake(jinbiImage.frame.origin.x+jinbiImage.frame.size.width+2, jinbiImage.frame.origin.y, 20,20)];
        jinbiLabel.text = @"+2";
        jinbiLabel.textColor = [UIColor whiteColor];
        jinbiLabel.font = [UIFont systemFontOfSize:15];
        [dashangImage addSubview:jinbiLabel];
        UILabel * shanglabel = [[UILabel alloc] initWithFrame:CGRectMake(jinbiImage.frame.origin.x+10,jinbiImage.frame.origin.y+jinbiImage.frame.size.height,20,20)];
        shanglabel.textColor = [UIColor whiteColor];
        shanglabel.text = @"赏";
        [dashangImage addSubview:shanglabel];
    }
     dashangImage.image = [UIImage imageNamed:name];
    return dashangImage;
}
@end
