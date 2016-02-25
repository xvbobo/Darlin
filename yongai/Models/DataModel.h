//
//  DataModel.h
//  Yongai
//
//  Created by myqu on 14/11/6.
//  Copyright (c) 2014年 com.threeti.yongai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

/*
 开发 http://www.3tixa.com:8099/dev/yongai_dev
 测试 http://www.3tixa.com:8099/dev/yongai_test
 正式 http://www.3tixa.com:8099/dev/yongai
 */


/*
 交付环境  http://103.20.249.101/paopaotang
 测试环境  http://www.3tixa.com:81/yongai_test
 */

#define HTTPBASEURL      @"http://103.20.249.101/paopaotang"

#pragma maek --- 颜色的宏定义
/**
 *  颜色的宏定义
 */
#define Color_241  [UIColor colorWithRed:241/255.0 green:242/255.0 blue:243/255.0 alpha:1.0] // 页面背景灰色
#define Color_236  [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] //
#define Color_230  [UIColor colorWithRed:230/255.0 green:145/255.0 blue:74/255.0 alpha:1.0] // 橘色
#define Color_104  [UIColor colorWithRed:104/255.0 green:167/255.0 blue:235/255.0 alpha:1.0] // 蓝色
#define Color_212  [UIColor colorWithRed:212/255.0 green:212/255.0 blue:216/255.0 alpha:1.0] // placeholder color

#define CommonLine  @"common_line"

#pragma maek --- 通知的宏定义
/**
 *  通知的宏定义
 */

#define Notify_HideBottom @"HideBottom"
#define Notify_ShowBottom @"ShowBottom"

 
#define Notify_showRootView  @"showRootView"
#define Notify_showLeftView  @"showLeftView"
#define Notify_showLoginView  @"showLoginView"

#define Notify_showMyTopicView    @"showMyTopicView"
#define Notify_showMyMessageView  @"showMyMessageView"
#define Notify_showAttentionView  @"showAttentionView"
#define Notify_showMyGoldView     @"showMyGoldView"

#define Notify_updateLoginState   @"updateLoginState"

#define Notify_updateAddressList  @"updateAddressList"

#define Notify_showGoodsDetailView  @"showGoodsDetailView"
#define Notify_showPostDetailView   @"showPostDetailView"
#define Notify_showTuiSongView   @"showTuiSongView"
//微信支付成功
#define Notify_weiXinSuccess  @"weiXinSuccess"
#define Notify_showPostDetailViewContoller  @"showPostDetailViewContoller"

#define Notify_RefreshMCProductCell @"RefreshMCProductCell"

#define Notify_UpdateSelectIndex @"UpdateSelectIndex"

#define Notify_RefreshOrderStatus  @"RefreshOrderStatus"

// 支付宝回调处理的通知
#define AlipayResultURLNotify  @"AlipayResultURL"

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088701805117259"
//收款支付宝账号
#define SellerID  @"terry@ultraprinting.cn"
//商户私钥，自助生成
#define PartnerPrivKey  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMWl3iuw1if3ZWIV\
/V1MVMxzupJzi3wiyT7rU1zLHT22U9SHhGKA9HeUB44Igot9r0gZN32WqBnhxecA\
flQ1dkZXGMVCZlUvvWakmmWWt20MdBJ4qE9mUiALAlgAeDQEQMhePDNMTteL86Yo\
GaMF6p6oTxVLsMb/+cCp1umejlG/AgMBAAECgYBCgUF0qhglcpVmn8eVMS4HbZmF\
1eNFbd8RkNWID8BTF5q1lLPzATlBU0oHfM2QakYkmHeXhq4hp1qUFBJt+19ETBk+\
gF3MlS9Og7fzsA1Y5AgBB7PQRxxv6IEcnz5t/F7uEDkntjTkDxvvu0UdsvigZK/R\
xDi9mHZrI6G+b84WQQJBAPILp1qQqVK3JdnsfLjapx3cjcGysSvNMyRE8A1ImxUz\
FLSXeqHrr3WUVM1ZVORLFN0sOhna0mA+FtcXhVTwNJkCQQDRCvNaEB90IKHOpOhy\
3M8Ec+PRgshnmZnFP3WZELQQ8OInlgxlhCVk5SivoDT2UXDXn/jR9qAM8xy6T+wM\
LVgXAkBhx3ls6aGta5Vb6uAboSD/vDh79l8CTdwKG9tJ0nnr333O0p7UyKxR+IEl\
j5/utbIRAyvZg/+Wp558d+ECBiOJAkEAlQACLwrY8JQl4T4H9X9QC7NzCi33HGkO\
gtrVvpF6V6zq9h5snZtQcBcrJevCdGPeU8NRvo7UzAYpTt+St6dGZwJBAKzVYuBv\
Iys+z6BeT1AzgfhiiFRY3TeqUqYAkKb/GDQO2WInLJ9N+gu1IoP/zG/hyKcAExZr\
ZQAcQt9TXxGLo00="

//回调地址
#define  NOTIFYURL  [NSString stringWithFormat:@"%@/app/alipay/respond.php", HTTPBASEURL]

#define myAppScheme @"YongaiAliPay"


int  g_LoginStatus; // 登录状态
int  selectedIndex; //当前选择的tababr下标

NSString *g_version;
NSString *g_versionUrl;

#import "YongaiYabbarController.h"
YongaiYabbarController *yongaiVC;


@interface DataModel : NSObject

@end

/**
 *  基本数据模型
 */
#pragma mark ---- 公共模块数据对象
@interface RegionModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*id;
@property(nonatomic, strong)NSString <Optional>*name;
@property(nonatomic, strong)NSString <Optional>*parent_id;
@end


#pragma mark --- 用户个人中心模块数据对象

/**
 *  用户爱好
 */
@interface HobbyModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*id; // 兴趣爱好id
@property(nonatomic, strong)NSString <Optional>*name; // 兴趣爱好名称
@property(nonatomic, strong)NSString <Optional>*selectStatus;
@end

@protocol HobbyModel <NSObject>
@end

/**
 *  用户 登录/注册 返回数据模型
 */
@interface LoginModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*uid;   // 用户id
@property(nonatomic, strong)NSString <Optional>*user_photo; // 用户头像
@property(nonatomic, strong)NSString <Optional>*cart_num; // 购物车商品数量
@property(nonatomic, strong)NSString <Optional>*pay_points; //我的金币
@property(nonatomic, strong)NSString <Optional>*user_rank; //用户等级id
@property(nonatomic, strong)NSString <Optional>*rank_name; // 用户等级名称
@property(nonatomic, strong)NSString <Optional>*email; // 用户账号
@property(nonatomic, strong)NSString <Optional>*nickname; // 用户昵称
@property(nonatomic, strong)NSString <Optional>*birthday; // 生日
@property(nonatomic, strong)NSString <Optional>*age; // 年龄
@property(nonatomic, strong)NSString <Optional>*constellation; // 星座
@property(nonatomic, strong)NSString <Optional>*sex; // 性别  1：男 2：女
@property(nonatomic, strong)NSString <Optional>*address_id; // 默认地址id
@property(nonatomic, strong)NSString <Optional>*province; // 所在身份id
@property(nonatomic, strong)NSString <Optional>*provincename; // 所在省份名称
@property(nonatomic, strong)NSString <Optional>*city; // 所在城市id
@property(nonatomic, strong)NSString <Optional>*cityname; // 所在城市名称
@property(nonatomic, strong)NSString <Optional>*sid; // 检验用户登录sid
@property(nonatomic, strong)NSString <Optional>*message_red;// 是否有未读消息
@property(nonatomic, strong)NSString <Optional>*red_dot;

@property(nonatomic, strong)NSString <Optional>*loadPicture; // 图片设置：0、正常加载图片  1 、不自动加载图片
@property(nonatomic, strong)NSString <Optional>*peepPassword; // 防偷窥密码（四位数字）
@property(nonatomic, strong)NSString <Optional>*peepYes; // 是否打开防偷窥密码：0、关闭  1 、打开

@property(nonatomic, strong)NSString <Optional>*loginStatus; // 是否自动登录：0、否  1 、是
@property(nonatomic, strong)NSString <Optional>*pwd; // 是否自动登录：0、否  1 、是

@property(nonatomic, strong)NSString <Optional>*latest_msg_photo;//最新消息的头像
@property(nonatomic, strong)NSString <Optional>* isOpen;//是否公开个人信息
@property(nonatomic, strong)NSString <Optional>* exp;//用户经验
@property(nonatomic, strong)NSString <Optional>* dengji;//用户经验等级
@property (nonatomic,strong) NSString <Optional> * ver;//用户版本号
@property (nonatomic,strong) NSString <Optional> * verify_config;//是否开启审核
@property (nonatomic,strong) NSString <Optional> * if_new_chatting;//是否有新消息

@end

/**
 *  用户 信息数据模型
 */
@interface ContactInfoModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*user_id;   // 用户id
@property(nonatomic, strong)NSString <Optional>*nickname; // 用户昵称
@property(nonatomic, strong)NSString <Optional>*user_photo; // 用户头像
@property(nonatomic, strong)NSString <Optional>*sex; // 性别  1：男 2：女
@property(nonatomic, strong)NSString <Optional>*user_rank; //用户等级id
@property(nonatomic, strong)NSString <Optional>*age; // 年龄
@property(nonatomic, strong)NSString <Optional>*constellation; // 星座
@property(nonatomic, strong)NSString <Optional>*province; // 所在身份
@property(nonatomic, strong)NSString <Optional>*city; // 所在城市
@property(nonatomic, strong)NSString <Optional>*thread_num; //话题数
@property(nonatomic, strong)NSArray  <Optional>*hobby; // 爱好

@property(nonatomic, strong)NSString <Optional>*is_follow; //是否关注
@property(nonatomic, strong)NSString <Optional>*is_black; // 是否加入黑名单

@property(nonatomic, strong)NSString <Optional>*on_off; // 是否公开年龄和星座 1 公开 2 保密
@end

/**
 *  金币规则详情
 */
@interface GoldRuleModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*id;   // 规则id
@property(nonatomic, strong)NSString <Optional>*code; // 规则编码
@property(nonatomic, strong)NSString <Optional>*name; // 规则名称
@property(nonatomic, strong)NSString <Optional>*num; //可以获取的金币数量
@property(nonatomic, strong)NSString <Optional>*desc; //金币规则简介
@property(nonatomic, strong)NSString <Optional>*completed; // 完成度数据
@property(nonatomic, strong)NSString <Optional>*total; // 总任务量
@end

@protocol GoldRuleModel <NSObject>
@end

/**
 *  金币列表
 */
@interface GoldListModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*user_id;//用户id
@property(nonatomic, strong)NSString <Optional>*nickname;//用户昵称
@property(nonatomic, strong)NSString <Optional>*user_photo;// 用户头像
@property(nonatomic, strong)NSString <Optional>*fg_num;//金币数
@end

@protocol GoldListModel <NSObject>
@end

/**
 *  我的金币
 */
@interface GoldModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*gold_rule;   // 金币规则总描述
@property(nonatomic, strong)NSArray <GoldRuleModel, ConvertOnDemand>*rule_list; // 金币规则列表
@property(nonatomic, strong)NSArray <GoldListModel, ConvertOnDemand>*gold_list;

@property(nonatomic, strong)NSString <Optional>*app_gold_order;   // 每一元送多少金币
@end
//金币明细
@interface GoldMingModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*gold_num;   // 会话id
@property(nonatomic, strong)NSString <Optional>*task_code; // 最后一天内容
@property(nonatomic, strong)NSString <Optional>*task_date;
@end
/**
 *  我的消息列表
 */
@interface MessageModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*message_id;   // 会话id
@property(nonatomic, strong)NSString <Optional>*message_latest; // 最后一天内容
@property(nonatomic, strong)NSString <Optional>*message_time; // 时间
@property(nonatomic, strong)NSString <Optional>*mesu_unread; //未读数量
@property(nonatomic, strong)NSString <Optional>*mesu_id; //会话成员id
@property(nonatomic, strong)NSString <Optional>*nickname; //昵称
@property(nonatomic, strong)NSString <Optional>*sex; // 性别
@property(nonatomic, strong)NSString <Optional>*user_id; // 用户id
@property(nonatomic, strong)NSString <Optional>*user_photo; // 头像
@property (nonatomic,strong) NSString <Optional>*user_rank;//等级
@end


/**
 *  我的消息内容
 */
@interface MessageContentModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*user_photo; // 头像
@property(nonatomic, strong)NSString <Optional>*mesc_id;   // 消息id
@property(nonatomic, strong)NSString <Optional>*mesc_content; // 消息内容
@property(nonatomic, strong)NSString <Optional>*mesc_display; // 时间是否显示
@property(nonatomic, strong)NSString <Optional>*mesc_time; //消息时间
@property(nonatomic, strong)NSString <Optional>*mesc_user; // 显示方式
@end
//************************************
/**
 *  兑换中心商品列表数据模型
 */
@interface ExchangeListModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*exchange_integral;
@property(nonatomic, strong)NSString <Optional>*goods_id;
@property(nonatomic, strong)NSString <Optional>*goods_name;
@property(nonatomic, strong)NSString <Optional>*img_url;
@property(nonatomic, strong)NSString <Optional>*mesc_user;
@end

/**
 *  轮播图数据对象
 */
@interface ScrollImgModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*id;
@property (nonatomic,strong) NSString <Optional> * tid;
@property (nonatomic,strong) NSString <Optional> * gid;
@property(nonatomic, strong)NSString <Optional>*logo;
@end


@protocol ScrollImgModel <NSObject>

@end

/**
 *  兑换中心商品详情数据模型
 */
@interface ExchangeInfoModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*exchange_integral;
@property(nonatomic, strong)NSString <Optional>*goods_id;
@property(nonatomic, strong)NSString <Optional>*goods_name;
@property(nonatomic, strong)NSString <Optional>*goods_desc;
@property(nonatomic, strong)NSString <Optional>*goods_number;
@property (nonatomic, strong)NSArray <ScrollImgModel, ConvertOnDemand>*gallery;
@end


//****************************************************
#pragma mark ---- 购物车模块数据对象

/**
 *  收货地址
 */
@interface AddressModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*address_id;   // 收货地址
@property(nonatomic, strong)NSString <Optional>*consignee;   // 收货人
@property(nonatomic, strong)NSString <Optional>*mobile;   // 手机
@property(nonatomic, strong)NSString <Optional>*email;   // 邮件
@property(nonatomic, strong)NSString <Optional>*address;   // 详细地址
@property(nonatomic, strong)NSString <Optional>*zipcode;   // 邮编
@property(nonatomic, strong)NSString <Optional>*country;   // 国家id
@property(nonatomic, strong)NSString <Optional>*province;   // 省份id
@property(nonatomic, strong)NSString <Optional>*city;   // 城市id
@property(nonatomic, strong)NSString <Optional>*district;   // 区县id
@property(nonatomic, strong)NSString <Optional>*country_name;   // 国家
@property(nonatomic, strong)NSString <Optional>*province_name;   // 省份
@property(nonatomic, strong)NSString <Optional>*city_name;   // 城市
@property(nonatomic, strong)NSString <Optional>*district_name;   // 区县
@property(nonatomic, strong)NSString <Optional>*default_address;   // 是否为默认地址
@end


@protocol AddressModel <NSObject>
@end

/**
 *  购物车列表数据
 */
@interface CartListGoodsModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*goods_id;   // 商品id
@property(nonatomic, strong)NSString <Optional>*goods_name;   // 商品名称
@property(nonatomic, strong)NSString <Optional>*goods_price;   // 商品价格
@property(nonatomic, strong)NSString <Optional>*market_price;   // 商品市场价
@property(nonatomic, strong)NSString <Optional>*is_zeng;   // 是否有赠品
@property(nonatomic, strong)NSString <Optional>*is_down;   // 是否为促销商品
@property(nonatomic, strong)NSString <Optional>*img_url;   // 商品图片路径
@property(nonatomic, strong)NSString <Optional>*rec_id;   // 购物车id
@property(nonatomic, strong)NSString <Optional>*product_id;   // 货品id
@property(nonatomic, strong)NSString <Optional>*goods_number;   // 货品数量
@property(nonatomic, strong)NSString <Optional>*goods_attr_id;   // 货品属性id
@property(nonatomic, strong)NSString <Optional>*attr_value;   // 货品属性值
@property(nonatomic, strong)NSString <Optional>*goods_status;   // 是否有货
@property(nonatomic, strong)NSString <Optional>*bSelect; //是否被选中的状态

@property(nonatomic, strong)NSString <Optional> *commentInfo; //评论信息
@property(nonatomic, strong)NSString <Optional> *rating; //选择的五星
@property(nonatomic, strong)NSString <Optional> *service_status;//是否申请过售后0，未申请售后
@property(nonatomic, strong)NSString <Optional> *is_gift;//是否是赠品
@end

@protocol CartListGoodsModel <NSObject>
@end


/**
 *  赠品数据
 */
@interface GiftGoodsModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*goods_id;   // 商品id
@property(nonatomic, strong)NSString <Optional>*goods_name;   // 商品名称
@property(nonatomic, strong)NSString <Optional>*price;   // 商品价格
@property(nonatomic, strong)NSString <Optional>*img_url;   // 商品图片路径
@property(nonatomic, strong)NSString <Optional>*product_id;   // 货品id
@property(nonatomic, strong)NSString <Optional>*goods_number;   // 货品数量
@property(nonatomic, strong)NSString <Optional>*goods_attr_id;   // 货品属性id
@property(nonatomic, strong)NSString <Optional>*attr_value;
@end

@protocol GiftGoodsModel <NSObject>
@end

/**
 *  快递信息对象
 */
@interface ShippingObject : JSONModel
@property (nonatomic, strong) NSString<Optional>* shipping_id;// 快递编码
@property (nonatomic, strong) NSString<Optional>* shipping_name;// 快递名称
@property (nonatomic, strong) NSString<Optional>* shipping_desc;// 配送描述
@property (nonatomic, strong) NSString<Optional>* support_cod;// 是否支持货到付款
@end



@protocol ShippingObject <NSObject>
@end


/**
 *  支付方式对象
 */
@interface  PaymentObject:JSONModel
@property (nonatomic, strong) NSString <Optional>*cod;//  货到付款
@property (nonatomic, strong) NSString <Optional>*alipay;//  支付宝
@property (nonatomic, strong) NSString <Optional>*weiXin;// 微信支付
@end


/**
 *  订单金币使用对象
 */
@interface GoldOrderModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*order_min;//  使用金币订单金额下限
@property (nonatomic, strong) NSString <Optional>*gold_max;//  订单最大可使用金币
@property (nonatomic, strong) NSString <Optional>*gold_rate;//  金币折合率
@property (nonatomic, strong) NSString <Optional>*gold_num;//  用户可用金币
@end


/**
 *  订单商品金额对象
 */
@interface GoodsOrderModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*goods_price;//  商品价格
@property (nonatomic, strong) NSString <Optional>*discount;//  订单最大可使用金币
@property (nonatomic, strong) NSString <Optional>*integral_money;//  金币折合率
@property (nonatomic, strong) NSString <Optional>*shipping_fee;//  用户可用金币
@property (nonatomic, strong) NSString <Optional>*app_gold_give_min;//  赠送金币订单金额下限
@property (nonatomic, strong) NSString <Optional>*app_gold_order;//  每一元订单可奖励金币数
@property (nonatomic, strong) NSString <Optional>*will_get_integral;//  可获金币
@property (nonatomic, strong) NSString <Optional>*amount;//  应付金额
@end


/**
 *  订单结算页面详情对象
 */
@interface SettlementModel : JSONModel
@property (nonatomic, strong) NSString *confirm;// 订单提示信息
@property (nonatomic, strong) AddressModel <Optional>*consignee; // 收货人信息
@property (nonatomic, strong) PaymentObject <Optional>*payment_list; // 支付方式列表
@property (nonatomic, strong) NSArray <ShippingObject, ConvertOnDemand>*shipping_list; //配送方式
@property (nonatomic, strong) NSArray <CartListGoodsModel, ConvertOnDemand>*goods_list; //商品列表
@property (nonatomic, strong) NSArray <GiftGoodsModel, ConvertOnDemand>*gift_list; //赠品列表
@property (nonatomic, strong) GoldOrderModel  <Optional>*gold; // 订单金币使用对象
@property (nonatomic, strong) GoodsOrderModel <Optional>*total; // 订单商品金额对象
@end

/**
 *  订单结算页面的响应对象
 */
@interface OrderResponseModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*order_amount;//  支付金额
@property (nonatomic, strong) NSString <Optional>*order_desc;//  订单描述
@property (nonatomic, strong) NSString <Optional>*order_id;//  订单id
@property (nonatomic, strong) NSString <Optional>*order_sn;//  订单编号
@property (nonatomic, strong) NSString <Optional>*pay_code;//  支付方式
@end

#pragma mark - 商城模块数据对象

/**
 *  订单列表数据对象
 */
@interface OrderListModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*order_id;//  订单id
@property (nonatomic, strong) NSString <Optional>*order_sn;//  订单编号
@property (nonatomic, strong) NSString <Optional>*order_status;//  订单状态id
@property (nonatomic, strong) NSString <Optional>*order_status_text;//  订单状态
@property (nonatomic, strong) NSString <Optional>*pay_code;//  支付方式
@property (nonatomic, strong) NSString <Optional>*order_amount;//  支付金额
@property (nonatomic, strong) NSString <Optional>*order_time;//  订单时间
@property (nonatomic, strong) NSArray <CartListGoodsModel, ConvertOnDemand>*goods_list; //商品列表

@property (nonatomic, strong) NSString <Optional>*order_comment;//
@end

@interface InvoiceModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*need_inv;//  是否开发票 1：需要 0：不需要
@property (nonatomic, strong) NSString <Optional>*inv_type;//  发票类型 1：个人  2：单位
@property (nonatomic, strong) NSString <Optional>*inv_payee;//  发票抬头信息
@property (nonatomic, strong) NSString <Optional>*inv_content;//  发票内容 1：详情  2：办公用品
@end

@protocol InvoiceModel <NSObject>
@end

/**
 *  订单详情数据对象
 */
@interface OrderDetailModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*order_id;//  订单id
@property (nonatomic, strong) NSString <Optional>*order_sn;//  订单编号
@property (nonatomic, strong) NSString <Optional>*order_status;//  订单状态id   // 1待付款，2待发货，3待收货，4已完成，5已取消
@property (nonatomic, strong) NSString <Optional>*order_status_test;//  订单状态
@property (nonatomic, strong) NSString <Optional>*pay_code;//  支付方式
@property (nonatomic, strong) NSString <Optional>* shipping_name;// 快递名称
@property (nonatomic, strong) NSString <Optional>*order_amount;//  支付金额
@property (nonatomic, strong) NSString <Optional>*goods_amount;//  商品总额
@property (nonatomic, strong) NSString <Optional>* shipping_fee;// 运费
@property (nonatomic, strong) NSString <Optional>*integral_money;//  抵扣金额
@property (nonatomic, strong) NSString <Optional>*discount;//  优惠金额
@property (nonatomic, strong) NSString <Optional>*postscript;//  订单备注
@property (nonatomic, strong) NSString <Optional>*app_receipt_confirm;//  确认收货地自定义文本
@property (nonatomic, strong) NSString <Optional>*order_time;//  订单时间
@property (nonatomic, strong) NSString <Optional>*invoice_no;// 运单号

@property (nonatomic, strong) AddressModel <Optional> *consignee;
@property (nonatomic, strong) InvoiceModel <Optional> *invoice;
@property (nonatomic, strong) NSArray <CartListGoodsModel, ConvertOnDemand>*goods_list; //商品列表

@end

#pragma mark ---- 商城模块数据对象

/**
 *  商品对象
 */
@interface GoodModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*goods_id;
@property(nonatomic, strong)NSString <Optional>*name;
@property(nonatomic, strong)NSString <Optional>*market_price;
@property(nonatomic, strong)NSString <Optional>*shop_price;
@property(nonatomic, strong)NSString <Optional>*image_url;
@property(nonatomic, strong)NSString <Optional>*rec_id;
@end
@interface GoodModelTui : JSONModel
@property(nonatomic, strong)NSString <Optional>*goods_id;
@property(nonatomic, strong)NSString <Optional>*goods_name;
@property(nonatomic, strong)NSString <Optional>*img;
@property(nonatomic, strong)NSString <Optional>*price;
@end

#pragma mark - 泡友圈
/**
 *  圈子对象
 */
@interface BbsModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*fid; // 圈子id
@property(nonatomic, strong)NSString <Optional>*name; // 圈子名称
@property(nonatomic, strong)NSString <Optional>*descp; //圈子描述
@property(nonatomic, strong)NSString <Optional>*icon; // 图标
@property(nonatomic, strong)NSString <Optional>*post_num; 
@property(nonatomic, strong)NSString <Optional>*is_join; // 是否加入
@property(nonatomic, strong)NSString <Optional>*is_signin;//帖子是否签到
@property (nonatomic,strong) NSString <Optional>*tag_id;
@property (strong,nonatomic) NSString <Optional> * height;
@property (strong,nonatomic) NSString <Optional> * if_thread_thumb;//是否显示图片1，不显示，0显示
@end

/**
 *  圈子分类对象
 */
@interface SortModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*fid;
@property(nonatomic, strong)NSString <Optional>*name;
@end


/**
 *  置顶帖子
 */
@interface PostDingModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*tid;//帖子id
@property(nonatomic, strong)NSString <Optional>*subject;//帖子主题
@end


/**
 *  图片尺寸规则
 */
@interface ImgInfoModel : JSONModel

@property(nonatomic, strong)NSString <Optional>*height;//用户id
@property(nonatomic, strong)NSString <Optional>*url;//用户昵称
@property(nonatomic, strong)NSString <Optional>*width;// 用户
@end

@protocol ImgInfoModel
@end


/**
 *  帖子列表
 */
@interface PostListModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*user_id;//用户id
@property(nonatomic, strong)NSString <Optional>*nickname;//用户昵称
@property(nonatomic, strong)NSString <Optional>*user_photo;// 用户
@property(nonatomic, strong)NSString <Optional>*sex;//性别  2：女 1：男
@property(nonatomic, strong)NSString <Optional>*user_rank;//用户等级  1：普通 2：资深
@property(nonatomic, strong)NSString <Optional>*subject;//帖子主题
@property(nonatomic, strong)NSString <Optional>*message;//帖子内容
@property(nonatomic, strong)NSString <Optional>*is_pic;//帖子是否有图
@property(nonatomic, strong)NSString <Optional>*is_jing;//帖子是否为精华帖
@property(nonatomic, strong)NSString <Optional>*is_hot;//帖子是否为热帖
@property(nonatomic, strong)NSString <Optional>*is_new;//帖子是否为新帖
@property(nonatomic, strong)NSString <Optional>*is_join;//是否加入该帖子
@property(nonatomic, strong)NSString <Optional>*addtime;//发帖时间
@property(nonatomic, strong)NSArray  <ImgInfoModel>*attachment;//帖子图片路径
@property(nonatomic, strong)NSString <Optional>*reply_num;//帖子回复数
@property(nonatomic, strong)NSString <Optional>*replyTime;//帖子最后回复时间
@property (nonatomic, strong)NSString <Optional>*tid; //帖子id
@property (nonatomic, strong)NSString <Optional>*contentHeight; //cell的高度
@property (nonatomic, strong)NSString <Optional>*fid; //圈子id
@property(nonatomic, strong)NSString <Optional>*sex_chose;//性别  2：女 1：男
@property(nonatomic, strong)NSString <Optional>*pid;//帖子
@property(nonatomic, strong)NSString <Optional>*exp_rank;//用户等级  1：普通 2：资深
@end

@protocol PostListModel <NSObject>

@end
@interface PostListModelTui : JSONModel
@property(nonatomic, strong)NSString <Optional>*subject;//帖子主题

@property(nonatomic, strong)NSString <Optional>*is_join;//是否加入该帖子
@property (nonatomic, strong)NSString <Optional>*tid; //帖子id
@property(nonatomic, strong)NSString <Optional>*pic;
@property (nonatomic, strong)NSString <Optional>*fid; //圈子id
@end

/**
 *  帖子详情+回复详情
 */
@interface PostDetailModel  : JSONModel

@property(nonatomic, strong)NSString <Optional>*user_id;//用户id
@property(nonatomic, strong)NSString <Optional>*nickname;//用户昵称
@property(nonatomic, strong)NSString <Optional>*user_photo;// 用户
@property(nonatomic, strong)NSString <Optional>*sex;//性别  2：女 1：男
@property(nonatomic, strong)NSString <Optional>*user_rank;//用户等级  1：普通 2：资深
@property(nonatomic, strong)NSString <Optional>*message;//帖子内容
@property(nonatomic, strong)NSString <Optional>*is_pic;//帖子是否有图
@property(nonatomic, strong)NSString <Optional>*addtime;//发帖时间
@property(nonatomic, strong)NSArray  <ImgInfoModel>*attachment;//帖子图片路径
@property(nonatomic, strong)NSString <Optional>*replyTime;//帖子最后回复时间
@property(nonatomic, strong)NSString <Optional>*pid;//帖子
@property (nonatomic, strong)NSString <Optional>*tid; //帖子id
@property (nonatomic, strong)PostListModel <Optional>*subPost;
@property (nonatomic, strong)NSString <Optional>*contentHeight; //cell的高度
@property(nonatomic, strong)NSString <Optional>*exp_rank;//用户等级
@end


/**
 *  泡友榜
 */
@interface RankModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*user_id;//用户id
@property(nonatomic, strong)NSString <Optional>*nickname;//用户昵称
@property(nonatomic, strong)NSString <Optional>*user_photo;// 用户头像
@property(nonatomic, strong)NSString <Optional>*sex;//性别  2：女 1：男
@property(nonatomic, strong)NSString <Optional>*rank;
@property(nonatomic, strong)NSString <Optional>*user_rank;//登陆用户排名
@property(nonatomic, strong)NSString <Optional>*distance;//距离排行榜分值，小于0代表已经进入排行榜
@property(nonatomic, strong)NSString <Optional>*gold_num;//月贡献分值

@property(nonatomic, strong)NSString <Optional>*rank_name;// 用户等级
@property(nonatomic, strong)NSString <Optional>*up_down;//排名 上升、持平或下降
@property(nonatomic, strong)NSString <Optional>*exp_rank;//用户等级
@end


/**
 *  商品详情数据
 */
@interface GoodsInfoModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*evaluation;   //
@property(nonatomic, strong)NSString <Optional>*goods_brief;   //
@property(nonatomic, strong)NSString <Optional>*goods_desc;   // 货品属性值
@property(nonatomic, strong)NSString <Optional>*goods_id;   //商品id
@property(nonatomic, strong)NSString <Optional>*goods_name;   //商品名称
@property(nonatomic, strong)NSString <Optional>*img_url;   // 商品图片路径
@property(nonatomic, strong)NSString <Optional>*is_collect;   // 是否被选中的状态
@property(nonatomic, strong)NSString <Optional>*is_down;   // 是否为促销商品
@property(nonatomic, strong)NSString <Optional>*is_zeng;   //  是否有赠品
@property(nonatomic, strong)NSString <Optional>*keywords;   // 货品数量
@property(nonatomic, strong)NSString <Optional>*market_price;   //商品市场价
@property(nonatomic, strong)NSString <Optional>*price;   // 商品价格
@property(nonatomic, strong)NSString <Optional>*promotion_count;   // 是否有货
@property(nonatomic, strong)NSString  <Optional>*star_value; //货品属性id 货品id
@property(nonatomic, strong)NSString <Optional>*end_time;
@property(nonatomic, strong)NSString <Optional>*discount;
@end


/**
 *  商品详细信息数据
 */
@interface GoodsDetailInfoModel : JSONModel
@property(nonatomic, strong)NSString <Optional>*cart_num;   //
@property(nonatomic, strong)NSArray <ScrollImgModel, Optional>*focus_item;   //
@property(nonatomic, strong)NSString <Optional>*gold_rule;   //
@property(nonatomic, strong)GoodsInfoModel <Optional>*goods_info;   //
@property(nonatomic, strong)NSArray <Optional>*link_goods;
//@property (nonatomic,strong) NSNumber * salenum;//
@end
//通知
@interface Tongzhi : JSONModel
@property(nonatomic, strong)NSString <Optional>*addtime;   //事件
@property(nonatomic, strong)NSString <Optional>*forum_name;   //圈子名称
@property(nonatomic, strong)NSString <Optional>*fid;   //圈子编号
@property(nonatomic, strong)NSString <Optional>*if_read;   //是否阅读1阅读，0没有阅读
@property(nonatomic, strong)NSString <Optional>*is_join;   //是否加入圈子
@property(nonatomic, strong)NSString <Optional>*message;   // 回复内容
@property(nonatomic, strong)NSString <Optional>*my_message;   // 是否被选中的状态
@property(nonatomic, strong)NSString <Optional>*nickname;   // 昵称
@property(nonatomic, strong)NSString <Optional>*page;   // 这一回复在主贴所有回复的第几页
@property(nonatomic, strong)NSString <Optional>*pid;   // 这一回复的回复编号
@property(nonatomic, strong)NSString <Optional>*porder;   //这一回复在主贴所有回复的第几条
@property(nonatomic, strong)NSString <Optional>*pup;   // 这一回复如果是回复用户评论，而并非用户帖子，则其内容为“被回复的帖子评论的回复编号”，否则为空
@property(nonatomic, strong)NSString <Optional>*reply_num;   //这一回复所在帖子的回复总数
@property(nonatomic, strong)NSString  <Optional>*tid; //这一回复对应的帖子编号
@property(nonatomic, strong)NSString <Optional>*user_id;   //这一回复发表者的用户ID
@property(nonatomic, strong)NSString <Optional>*user_photo;   //这一回复发表者的用户头像图片地址
@end

