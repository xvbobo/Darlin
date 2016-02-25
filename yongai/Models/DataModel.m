//
//  DataModel.m
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import "DataModel.h"


@implementation DataModel

@end


/**
 *  基本数据模型
 */

/**
 *  基本数据模型
 */
#pragma mark ---- 公共模块数据对象
@implementation RegionModel
@end

#pragma mark --- 用户个人中心模块数据对象

/**
 *  用户爱好
 */
@implementation HobbyModel
@end

/**
 *  用户 登录/注册 返回数据模型
 */
@implementation LoginModel
@end

/**
 *  用户 信息数据模型
 */
@implementation ContactInfoModel
@end

/**
 *  金币规则详情
 */
@implementation GoldRuleModel
@end


/**
 *  我的金币
 */
@implementation GoldModel
@end
//金币明细
@implementation GoldMingModel
@end
/**
 *  我的消息
 */
@implementation MessageModel
@end

/**
 *  我的消息内容
 */
@implementation MessageContentModel
@end


/**
 *  兑换中心商品列表数据模型
 */
@implementation ExchangeListModel
@end



/**
 *  轮播图数据对象
 */
@implementation ScrollImgModel
@end

/**
 *  兑换中心商品详情数据模型
 */
@implementation ExchangeInfoModel
@end

#pragma mark ---- 购物车模块数据对象

/**
 *  收货地址
 */
@implementation AddressModel
@end

/**
 *  购物车列表数据
 */
@implementation CartListGoodsModel
@end



/**
 *  赠品数据
 */
@implementation GiftGoodsModel
@end


/**
 *  快递信息对象
 */
@implementation ShippingObject
@end


/**
 *  支付方式对象
 */
@implementation  PaymentObject
@end

/**
 *  订单金币使用对象
 */
@implementation GoldOrderModel
@end


/**
 *  订单商品金额对象
 */
@implementation GoodsOrderModel
@end


/**
 *  订单结算页面详情对象
 */
@implementation SettlementModel
@end

/**
 *  订单结算页面的响应对象
 */
@implementation OrderResponseModel
@end

#pragma mark - 商城模块数据对象
/**
 *  订单数据对象
 */
@implementation OrderListModel

@end


@implementation InvoiceModel
@end


/**
 *  订单详情数据对象
 */
@implementation OrderDetailModel
@end


#pragma mark ---- 商城模块数据对象

/**
 *  商品对象
 */
@implementation GoodModel
@end

#pragma mark  --  推送
@implementation GoodModelTui
@end

@implementation PostListModelTui

@end
#pragma mark - 泡友圈

/**
 *  圈子对象
 */
@implementation BbsModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithJSONToModelBlock:^NSString *(NSString *keyName) {
        
        if ([keyName isEqual:@"description"]) {
            return @"descp";
        } else {
            return keyName;
        }
        
    } modelToJSONBlock:^NSString *(NSString *keyName) {
        
        if ([keyName isEqual:@"descp"]) {
            return @"description";
        } else {
            return keyName;
        }
        
    }];
}


@end

/**
 *  圈子分类对象
 */
@implementation SortModel
@end


/**
 *  置顶帖子
 */
@implementation PostDingModel
@end

/**
 *  图片尺寸规则
 */
@implementation ImgInfoModel
@end

/**
 *  帖子列表
 */
@implementation PostListModel
@end


/**
 *  帖子详情+回复详情
 */
@implementation PostDetailModel

@end


/**
 *  泡友榜
 */
@implementation RankModel
@end

/**
 *  商品详情数据
 */
@implementation GoodsInfoModel

@end

/**
 *  商品详细信息数据
 */
@implementation GoodsDetailInfoModel  
@end



/**
 *  金币列表
 */
@implementation GoldListModel
@end

//通知
@implementation Tongzhi


@end



