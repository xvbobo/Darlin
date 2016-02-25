//
//  TTIFont.m
//  iOSCodeProject
//
//  Created by Fox on 14-7-19.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import "TTIFont.h"

@implementation TTIFont

+ (void)showAllSystemFonts{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"ICFont Index:%ld   Family name: %@",(long)indFamily, [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@" Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

+ (UIFont *)getCommonFontWithSize:(float )size{
    return [UIFont fontWithName:@"KaiTi_GB2312" size:size];
}

+ (CGFloat)lineHeight:(UIFont *)font{
    return (font.ascender - font.descender) + 1;
}

+(float)calHeightWithText:(NSString *)text font:(UIFont *)font limitWidth:(float)limitWidth
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        
        NSDictionary *attribute = @{NSFontAttributeName: font};
        
        CGSize retSize = [text boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
        
        return ceil(retSize.height);
    }else
    {
        CGSize size=[text sizeWithFont:font
                     constrainedToSize:CGSizeMake(limitWidth, MAXFLOAT)
                         lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height;
    }
}

+(float)calWidthWithText:(NSString *)text font:(UIFont *)font limitWidth:(float)limitHeight
{
    CGSize size=[text sizeWithFont:font
                 constrainedToSize:CGSizeMake(MAXFLOAT, limitHeight)
                     lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.width;
}


@end
