//
//  OderNoteCell.m
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "OderNoteCell.h"

@implementation OderNoteCell

- (void)awakeFromNib {
    // Initialization code
    [self setup];
    self.dingDanBei.textColor = BLACKTEXT;
    self.noteMarginView.layer.borderColor = LINE.CGColor;
    self.noteMarginView.layer.borderWidth = 0.5;
    self.order_line.backgroundColor = BJCLOLR;
    self.order_lineH.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setup
{
    _noteTextView.placeholder = @"仅限50字内...";
    _noteTextView.textColor = TEXT;
}
@end
