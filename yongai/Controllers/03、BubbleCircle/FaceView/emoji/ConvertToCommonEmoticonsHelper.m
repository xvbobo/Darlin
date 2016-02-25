//
//  ConvertToCommonEmoticonsHelper.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 14-6-30.
//  Copyright (c) 2014年 dujiepeng. All rights reserved.
//

#import "ConvertToCommonEmoticonsHelper.h"
#import "Emoji.h"

@implementation ConvertToCommonEmoticonsHelper

#pragma mark - emotics
+ (NSString *)convertToCommonEmoticons:(NSString *)text {
    int allEmoticsCount = [Emoji allEmoji].count;
    NSMutableString *retText = [[NSMutableString alloc] initWithString:text];
    for(int i=0; i<allEmoticsCount; ++i) {
        NSRange range;
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😊"
                                 withString:@"<img src='f101'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😉"
                                 withString:@"<img src='f102'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😃"
                                 withString:@"<img src='f103'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🐱"
                                 withString:@"<img src='f104'/>"
                                    options:NSLiteralSearch
                                      range:range];
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😬"
                                 withString:@"<img src='f105'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😔"
                                 withString:@"<img src='f106'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😒"
                                 withString:@"<img src='f109'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😭"
                                 withString:@"<img src='f110'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💪"
                                 withString:@"<img src='f112'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👻"
                                 withString:@"<img src='f113'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😱"
                                 withString:@"<img src='f115'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😐"
                                 withString:@"<img src='f118'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👍"
                                 withString:@"<img src='f120'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🍸"
                                 withString:@"<img src='f123'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🎁"
                                 withString:@"<img src='f125'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😝"
                                 withString:@"<img src='f201'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😖"
                                 withString:@"<img src='f205'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😡"
                                 withString:@"<img src='f208'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👿"
                                 withString:@"<img src='f209'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😓"
                                 withString:@"<img src='f211'/>"
                                    options:NSLiteralSearch
                                      range:range];
       
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🐰"
                                 withString:@"<img src='f212'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😠"
                                 withString:@"<img src='f215'/>"
                                    options:NSLiteralSearch
                                      range:range];
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😑"
                                 withString:@"<img src='f217'/>"
                                    options:NSLiteralSearch
                                      range:range];

        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😷"
                                 withString:@"<img src='f219'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👎"
                                 withString:@"<img src='f220'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
//        range.location = 0;
//        range.length = retText.length;
//        [retText replaceOccurrencesOfString:@""
//                                 withString:@"<img src=\"f220\">"
//                                    options:NSLiteralSearch
//                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😍"
                                 withString:@"<img src='f222'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😏"
                                 withString:@"<img src='f225'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💩"
                                 withString:@"<img src='f227'/>"
                                    options:NSLiteralSearch
                                      range:range];
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"☀️"
                                 withString:@"<img src='f228'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"⚡️"
                                 withString:@"<img src='f231'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🎈"
                                 withString:@"<img src='f202'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"🎉"
                                 withString:@"<img src='f260'/>"
                                    options:NSLiteralSearch
                                      range:range];

        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😘"
                                 withString:@"<img src='f262'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👧"
                                 withString:@"<img src='f246'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👨"
                                 withString:@"<img src='f247'/>"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌛"
                                 withString:@"<img src='f229'/>"
                                    options:NSLiteralSearch
                                      range:range];
    }
    
    return retText;
}

+ (NSString *)convertToSystemEmoticons:(NSString *)text {
    int allEmoticsCount = [Emoji allEmoji].count;
    NSMutableString *retText;
    if (text) {
        retText = [[NSMutableString alloc] initWithString:text];
    }
    
    for(int i=0; i<allEmoticsCount; ++i) {
        NSRange range;
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f101'/>"
                                 withString:@"😊"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f102'/>"
                                 withString:@"😉"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f103'/>"
                                 withString:@"😃"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f104'/>"
                                 withString:@"🐱"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f105'/>"
                                 withString:@"😬"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f106'/>"
                                 withString:@"😔"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f109'/>"
                                 withString:@"😒"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f110'/>"
                                 withString:@"😭"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f112'/>"
                                 withString:@"💪"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f113'/>"
                                 withString:@"👻"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f115'/>"
                                 withString:@"😱"
                                    options:NSLiteralSearch
                                      range:range];
        //meizhaodao
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f118'/>"
                                 withString:@"😐"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f120'/>"
                                 withString:@"👍"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f123'/>"
                                 withString:@"🍸"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f125'/>"
                                 withString:@"🎁"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f201'/>"
                                 withString:@"😝"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f205'/>"
                                 withString:@"😖"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f208'/>"
                                 withString:@"😡"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f209'/>"
                                 withString:@"👿"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f211'/>"
                                 withString:@"😓"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f212'/>"
                                 withString:@"🐰"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f215'/>"
                                 withString:@"😠"
                                    options:NSLiteralSearch
                                      range:range];
        //没找到
//        range.location = 0;
//        range.length = retText.length;
//        [retText replaceOccurrencesOfString:@"<img src=\"f215\">"
//                                 withString:@"😑"
//                                    options:NSLiteralSearch
//                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f217'/>"
                                 withString:@"😑"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f219'/>"
                                 withString:@"😷"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f220'/>"
                                 withString:@"👎"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f222'/>"
                                 withString:@"😍"
                                    options:NSLiteralSearch
                                      range:range];
        
//        range.location = 0;
//        range.length = retText.length;
//        [retText replaceOccurrencesOfString:@"<img src=\"f227\">"
//                                 withString:@"🌞"
//                                    options:NSLiteralSearch
//                                      range:range];
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f225'/>"
                                 withString:@"😏"
                                    options:NSLiteralSearch
                                      range:range];

        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f227'/>"
                                 withString:@"💩"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"<img src='f228'/>"
                                 withString:@"☀️"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"<img src='f231'/>"
                                 withString:@"😍"
                                    options:NSLiteralSearch
                                      range:range];

        
        //没找到
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f260'/>"
                                 withString:@"🎉"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f262'/>"
                                 withString:@"😘"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f246'/>"
                                 withString:@"👧"
                                    options:NSLiteralSearch
                                      range:range];
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f247'/>"
                                 withString:@"👨"
                                    options:NSLiteralSearch
                                      range:range];

        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f229'/>"
                                 withString:@"🌙"
                                    options:NSLiteralSearch
                                      range:range];
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"<img src='f202'/>"
                                 withString:@"🎈"
                                    options:NSLiteralSearch
                                      range:range];
        
    }
    
    return retText;
}
@end
