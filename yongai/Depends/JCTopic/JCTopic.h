//
//  JCTopic.h
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import <UIKit/UIKit.h>

@protocol JCTopicDelegate<NSObject>
-(void)didClick:(id)data;
-(void)currentPage:(int)page total:(NSUInteger)total;
@end
@interface JCTopic : UIScrollView<UIScrollViewDelegate>{
    UIButton * pic;
    bool flag;
    int scrollTopicFlag;
    NSTimer * scrollTimer;
    int currentPage;
    CGSize imageSize;
    UIImage *image;
}
@property (nonatomic,copy) NSArray * pics;
@property (nonatomic,weak)id<JCTopicDelegate> JCdelegate;
@property (nonatomic,weak)UIImageView * jcVIew;
-(void)releaseTimer;
-(void)restartTimer;
-(void)upDate;
@end
