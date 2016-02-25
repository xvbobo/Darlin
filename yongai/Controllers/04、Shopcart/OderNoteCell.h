//
//  OderNoteCell.h
//  Yongai
//
//  Created by arron on 14/11/5.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTITextView.h"

@interface OderNoteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet TTITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UILabel *dingDanBei;
@property (weak, nonatomic) IBOutlet UIImageView *order_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_lineH;

@property (strong, nonatomic) IBOutlet UIView *noteMarginView;
@end
