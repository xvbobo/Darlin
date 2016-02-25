//
//  MallClassificationCell.h
//  Yongai
//
//  Created by Kevin Su on 14-10-29.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MallClassificationCellDelegate <NSObject>

- (void)imageClicked:(NSString *) idStr withName:(NSString*)nameStr;

@end
@interface MallClassificationCell : UITableViewCell

@property (assign,nonatomic) id <MallClassificationCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@property (strong, nonatomic) IBOutlet UILabel *ptitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *pdescLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailBootm;

- (void)initDataWithDictionary:(NSDictionary *)dataDic;
- (void)initDataWithArray:(NSArray *)dataArray;

@end
