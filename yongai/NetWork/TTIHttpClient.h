//
//  TTIHttpClient.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-21
//  Copyright (c) 2014年 GMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTIRequest.h"

#define RequestTimeOut                  30

//错误提示
#define DATA_FORMAT_ERROR   @"数据格式错误"
#define NETWORK_UNABLE      @"网络状况异常"
#define REQUEST_FAILE       @"网络请求失败"

/**
 *  HTTP网络请求客户端
 */
@interface TTIHttpClient : NSObject
@property(nonatomic, strong)NSMutableArray *regionArr; //存储省份列表

+ (TTIHttpClient *)shareInstance;
+ (NSString *) filePath: (NSString *) fileName;
#pragma mark - 个人中心
#pragma 微信支付
- (TTIRequest *)wixinZhiFuWith:(NSString*)goods_name with:(NSString*)order_no with:(NSString*)fee with:(NSString *)IP  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
- (TTIRequest *)wixinZhiFuWith:(NSString*)string withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark --- 验证手机号唯一性
-(TTIRequest *)phoneExistRequestWithEmail:(NSString *)email
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---  手机号验证码发送
-(TTIRequest *)phoneCodeRequestWithEmail:(NSString *)email
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark --- 版本检测
- (TTIRequest *)updateVersionRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark --- 广告页
- (TTIRequest *)actAdRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

/**用户管理**/
#pragma mark ---用户注册
- (TTIRequest *)registerRequestWithemail:(NSString *)email
                                password:(NSString *)password
                              invitecode:(NSString *)invitecode
                                nickname:(NSString *)nickname
                                     sex:(NSString *)sex
                               equipment:(NSString *)equipment
                               equip:(NSString *)equip
                                    page:(NSString *)page
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ----发送验证码
- (TTIRequest *)fpwCodeRequestWithEmail:(NSString *)email
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----重置密码
- (TTIRequest *)fpwResetRequestWithusername:(NSString *)email
                                withuserpswd:(NSString *)newPwd
                                    withcode:(NSString *)code
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ----用户登录
- (TTIRequest *)userLoginRequestWithusername:(NSString *)email
                                withuserpswd:(NSString *)password
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- 注册协议
- (TTIRequest *)registerRuleRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 泡泡堂社区须知
- (TTIRequest *)bbsRuleRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                   withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ----用户注销
- (TTIRequest *)userLogoutRequestWithsid:(NSString *)sid
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----获取个人信息
- (TTIRequest *)userInfoRequestWithsid:(NSString *)sid
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

- (TTIRequest *)MyOrderList:(NSString *)user_id
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----编辑个人资料-昵称
- (TTIRequest *)userEditnicknameRequestWithNickname:(NSString *)nickname
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----编辑个人资料-生日
- (TTIRequest *)userEditbirthdayRequestWithconstellation:(NSString *)constellation
                                            withBirthday:(NSString *)birthday
                                                 withAge:(NSString *)age
                                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----编辑个人资料-兴趣爱好
- (TTIRequest *)userEdithobbyRequestWithsid:(NSString *)sid
                                  withHobby:(NSString *)hobby
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ----编辑个人资料-是否公开信息
- (TTIRequest *)userEditRequestWithOnOff:(NSString *)on_off
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ----编辑个人资料-修改密码
- (TTIRequest *)userEditPasswordRequestWithold_password:(NSString *)old_password
                                           withpassword:(NSString *)password
                                          withpassword2:(NSString *)password2
                                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----编辑个人资料-所在城市
- (TTIRequest *)userEditprovinceRequestWithsid:(NSString *)sid
                                  withProvince:(NSString *)province
                                      withCity:(NSString *)city
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----收藏商品添加
- (TTIRequest *)goodsEditprovinceRequestWithsid:(NSString *)sid
                                  withGoods_id:(NSString *)goods_id
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----收藏商品列表
- (TTIRequest *)goodsEditlistRequestWithsid:(NSString *)sid
                                  withpage:(NSString *)page
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----收藏商品删除
- (TTIRequest *)goodsEditdeleteRequestWithsid:(NSString *)sid
                                  withrec_id:(NSString *)rec_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----取消收藏商品
- (TTIRequest *)goodsCancelRequestWithsid:(NSString *)sid
                             withgoods_id:(NSString *)goods_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----我的金币
- (TTIRequest *)goldruleRequestWithtype:(NSString *)type
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 金币明细
- (TTIRequest *)goldMingxiRequestWithtype:(NSString *)page
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark ----获取金币
- (TTIRequest *)get_integralRequestWithsid:(NSString *)sid
                             withtask_type:(NSString *)task_type
                                       fid:(NSString *)fid
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----上传头像
- (TTIRequest *)upload_headRequestWithsid:(NSString *)sid
                                 withfile:(UIImage *)file
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----意见反馈
- (TTIRequest *)suggestionRequestWithsid:(NSString *)sid
                             withcontent:(NSString *)content
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----我的消息
- (TTIRequest *)messageRequestWithsid:(NSString *)sid
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----邀请码
- (TTIRequest *)invitationCodeRequestWithsid:(NSString *)sid
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----等级说明
- (TTIRequest *)descriptionwithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----获取兴趣爱好
- (TTIRequest *)hobbyRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----版本更新
- (TTIRequest *)updateVersionRequestWithnow_version:(NSString *)now_version
                                    withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----注册时邮箱唯一性校验
- (TTIRequest *)emailExistRequestWithEmail:(NSString *)email
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark ---注册时用户名唯一性校验
- (TTIRequest *)userNameExistRequestWithUserName:(NSString *)userName
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark - 商城

#pragma mark ----首页
- (TTIRequest *)homeRequestWithtype:(NSString *)type
                    withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----分类列表
- (TTIRequest *)categoryRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ----限时抢购列表
- (TTIRequest *)group_listRequestWithgroup_list:(NSString *)group_list
                                       withpage:(NSString *)page
                                withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----赠品列表
- (TTIRequest *)comment_listRequestWithgoods_id:(NSString *)goods_id
                                       withpage:(NSString *)page
                                withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----评论列表
- (TTIRequest *)gift_listRequestWithgoods_id:(NSString *)goods_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----关于我们
- (TTIRequest *)systemRequestWithact:(NSString *)act
                     withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                     withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----应用广告
- (TTIRequest *)systemAdRequestWithact:(NSString *)act
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----新增收获地址
- (TTIRequest *)addAddressRequestWithsid:(NSString *)sid
                           withconsignee:(NSString *)consignee
                              withmobile:(NSString *)mobile
                            withprovince:(NSString *)province
                                withcity:(NSString *)city
                             withaddress:(NSString *)address
                             withzipcode:(NSString *)zipcode
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----修改收获地址
- (TTIRequest *)updateAddressRequestWithsid:(NSString *)sid
                             withaddress_id:(NSString *)address_id
                              withconsignee:(NSString *)consignee
                                 withmobile:(NSString *)mobile
                               withprovince:(NSString *)province
                                   withcity:(NSString *)city
                                withaddress:(NSString *)address
                                withzipcode:(NSString *)zipcode
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----删除收货地址
- (TTIRequest *)deleteAddressRequestWithsid:(NSString *)sid
                             withaddress_id:(NSString *)address_id
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----收获地址列表
- (TTIRequest *)getAddressRequestWithsid:(NSString *)sid
                                   withpage:(NSString *)page
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----设置默认收获地址
- (TTIRequest *)setDefaultAddressRequestWithsid:(NSString *)sid
                                 withaddress_id:(NSString *)address_id
                                withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----收货地址详细信息
- (TTIRequest *)infoAddressRequestWithsid:(NSString *)sid
                           withaddress_id:(NSString *)address_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----获取省份城市地区
- (TTIRequest *)regionAddressRequestWithparent_id:(NSString *)parent_id
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----兑换中心
- (TTIRequest *)listExchangeRequestWithsid:(NSString *)sid
                                  withpage:(NSString *)page
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----兑换商品详情
- (TTIRequest *)infoExchangeRequestWithsid:(NSString *)sid
                              withgoods_id:(NSString *)goods_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;



#pragma mark ----去兑换商品
- (TTIRequest *)changingExchangeRequestWithGoods_id:(NSString *)goods_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----确认兑换商品
- (TTIRequest *)submitExchangeRequestWithGoodsId:(NSString *)goods_id
                              withAddressId:(NSString *)address_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----订单金额计算
- (TTIRequest *)calculateOrderRequestWithsid:(NSString *)sid
                                 withcart_id:(NSString *)cart_id
                              withaddress_id:(NSString *)address_id
                            withpayment_code:(NSString *)payment_code
                             withshipping_id:(NSString *)shipping_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----订单提交
- (TTIRequest *)doneOrderRequestWithsid:(NSString *)sid
                            withcart_id:(NSString *)cart_id
                         withaddress_id:(NSString *)address_id
                       withpayment_code:(NSString *)payment_code
                        withshipping_id:(NSString *)shipping_id
                         withpostscript:(NSString *)postscript// 订单备注可为空，不为空时限50字以内
                           withintegral:(NSString *)integral
                           withneed_inv:(NSString *)need_inv
                           withinv_type:(NSString *)inv_type
                          withinv_payee:(NSString *)inv_payee// 发票抬头信息
                        withinv_content:(NSString *)inv_content
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----订单取消
- (TTIRequest *)cancelOrderRequestWithsid:(NSString *)sid
                             withorder_id:(NSString *)order_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----确认收货
- (TTIRequest *)affirmReceivedOrderRequestWithsid:(NSString *)sid
                                     withorder_id:(NSString *)order_id
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----我的订单
- (TTIRequest *)listOrderRequestWithsid:(NSString *)sid
                               withtype:(NSString *)type
                               withpage:(NSString *)page
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----订单详情
- (TTIRequest *)infoOrderRequestWithsid:(NSString *)sid
                           withorder_id:(NSString *)order_id
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----订单商品清单
- (TTIRequest *)goodsOrderRequestWithsid:(NSString *)sid
                            withorder_id:(NSString *)order_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----评论商品
- (TTIRequest *)goods_commentsOrderRequestWithsid:(NSString *)sid
                                     withorder_id:(NSString *)order_id
                                      withcontent:(NSString *)content
                                 withcomment_rank:(NSString *)comment_rank
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----评论订单
- (TTIRequest *)commentsOrderRequestWithsid:(NSString *)sid
                                   order_id:(NSString *)order_id
                                    comment:(NSArray *)comment
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----商品评论列表
- (TTIRequest *)comments_listOrderRequestWithgoods_id:(NSString *)goods_id
                                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----购物车添加
- (TTIRequest *)addCartRequestWithsid:(NSString *)sid
                         withgoods_id:(NSString *)goods_id
                    withgoods_attr_id:(NSString *)goods_attr_id
                     withgoods_number:(NSString *)goods_number
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----购物车数量修改
- (TTIRequest *)editCartRequestWithsid:(NSString *)sid
                           withcart_id:(NSString *)cart_id
                      withgoods_number:(NSString *)goods_number
                       withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----购物车删除
- (TTIRequest *)deleteCartRequestWithsid:(NSString *)sid
                             withcart_id:(NSArray *)cart_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----购物车列表
- (TTIRequest *)cartListRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----立即购买
- (TTIRequest *)buyRequestWithsid:(NSString *)sid
                         goods_id:(NSString *)goods_id
                    goods_attr_id:(NSString *)goods_attr_id
                     goods_number:(NSInteger)goods_number
                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----购物车结算
- (TTIRequest *)settleCartRequestWithsid:(NSString *)sid
                             withcart_id:(NSString *)cart_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ----商城首页
- (TTIRequest *)mallshopHomeRequestWithType:(NSString *)type withVersion:(NSString *)version
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock ;

#pragma mark - 商城分类
- (TTIRequest *)mallshopCategoryRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                       withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark - 商品列表
- (TTIRequest *)productsListRequestWithId:(NSString *)id
                                     page:(NSString *)page
                                    order:(NSString *)order
                                priceOrder:(NSString *)price_order
                                  user_id:(NSString *)user_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark - 商品详情
- (TTIRequest *)productsDetailRequestWithGoodsId:(NSString *)goods_id
                                         user_id:(NSString *)user_id
                                 withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark - 限时抢购列表
- (TTIRequest *)flashSaleRequestWithPage:(NSString *)page
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark - 评论列表
- (TTIRequest *)commentsListRequestWithGoodsid:(NSString *)goods_id
                               withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark - 搜索商品
- (TTIRequest *)searchProductsListRequestWithKeyWord:(NSString *)keyword
                                                page:(int)page
                                     withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                     withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark --- ///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ---- 我的消息列表
-(TTIRequest *)messagelistRequestWithType:(NSString *)type
                                     page:(NSString *)page
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- 我的消息内容
-(TTIRequest *)messagecontentRequestWithMessageid:(NSString *)message_id
                                         withpage:(NSString *)page
                                  withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 我的消息删除
-(TTIRequest *)messageDelRequestWithMesuid:(NSString *)mesu_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 我的消息发送
-(TTIRequest *)messageSendRequestWithTo_user:(NSString *)to_user
                                withtcontent:(NSString *)content
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark - 泡友圈
#pragma mark ---- 首页
- (TTIRequest *)indexBbsRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


//新加跑友圈轮播图
#pragma mark ---- 分类
- (TTIRequest *)categoryBbsRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                  withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 贴吧
- (TTIRequest *)tieBaWithUser_id:(NSString *)user_id withPage:(NSString *)page withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                 withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark ---- 圈子
- (TTIRequest *)circleBbsRequestWithFid:(NSString *)fid
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 规则
- (TTIRequest *)ruleBbsRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 发帖
- (TTIRequest *)addBbsRequestWithFid:(NSString *)fid
                             withTid:(NSString *)tid
                             withPup:(NSString *)pup
                         withSubject:(NSString *)subject
                         withMessage:(NSString *)message
                         withPhotos0:(UIImage *)photos0
                         withPhotos1:(UIImage *)photos1
                         withPhotos2:(UIImage *)photos2
                         withPhotos3:(UIImage *)photos3
                         withPhotos4:(UIImage *)photos4
                         withPhotos5:(UIImage *)photos5
                         withPhotos6:(UIImage *)photos6
                         withPhotos7:(UIImage *)photos7
                          withTag_ids:(NSArray *)tag_ids
                         withVersion:(NSString *)version
                      withSex_Choose:(NSString *)sex_chose
                     withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                     withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 泡友榜
- (TTIRequest *)rankingBbsRequestWithFid:(NSString *)fid
                             withVersion:(NSString *)version
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- 我的关注看人列表
- (TTIRequest *)userFollowRequestWithPage:(NSString *)page
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 我的关注看帖子列表
- (TTIRequest *)bbsFollowRequestWithPage:(NSString *)page
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 圈子签到加分
- (TTIRequest *)bbsSigninRequestWithFid:(NSString *)fid
                                withCode:(NSString *)code
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 送金币
- (TTIRequest *)giveGoldRequestWithUserid:(NSString *)user_id
                              WithGoldnum:(NSString *)gold_num
                              WithContent:(NSString *)content
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 加入黑名单
- (TTIRequest *)addBlackRequestWithUserid:(NSString *)user_id
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 移除黑名单
- (TTIRequest *)cancelBlackRequestWithUserid:(NSString *)user_id
                             withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 添加关注
- (TTIRequest *)addFollowRequestWithUserid:(NSString *)user_id
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark ---- 举报帖子
- (TTIRequest *)reportPostRequestWithTid:(NSString *)tid
                               withreport_note:(NSString *)report_note  withReport_type:(NSString *) report_type
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark ---- 举报用户
- (TTIRequest *)reportPostRequestWithuserid:(NSString *)user_id
                         withreport_note:(NSString *)report_note  withReport_type:(NSString *) report_type
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 圈子详情
- (TTIRequest *)circleInfoRequestWithFid:(NSString *)fid
                           withOrderType:(NSString *)order_type
                                withPage:(NSString *)page
                              withTag_id:(NSString *)tag_id
                             withVersion:(NSString *)version
                          withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                          withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 加入圈子
- (TTIRequest *)addCircleRequestWithFid:(NSString *)fid
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- 帖子详情
- (TTIRequest *)bbsPostRequestWithTid:(NSString *)tid
                             withPage:(NSString *)page
                      withSearchOrder:(NSString *)search_order
                              withFid:(NSString *)fid
                     withFromnotepage:(NSString *)fromnotepage
                         withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 打赏
- (TTIRequest *)bbsPostRequestWithTid:(NSString *)tid
                              withFid:(NSString *)fid
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
- (TTIRequest *)bbsPostRequestWithTid:(NSString *)tid
                      withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                      withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- 我的话题
- (TTIRequest *)bbsThreadRequestWithPage:(NSString *)page
                         WithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;



#pragma mark ---- Ta的话题
- (TTIRequest *)userThreadRequestWithUserId:(NSString *)user_id
                                   withPage:(NSString *)page
                            withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- Ta的资料
- (TTIRequest *)bbsFriendRequestWithUserId:(NSString *)user_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- 取消加入圈子
- (TTIRequest *)cancleCircleRequestWithFid:(NSString *)fid
                        withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                        withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- 取消关注
- (TTIRequest *)cancelFollowRequestWithUserId:(NSString *)user_id
                           withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;


#pragma mark ---- 现有金币
- (TTIRequest *)nowGoldRequestWithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                                withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

#pragma mark ---- Ta的话题 - 赠送金币人物列表
- (TTIRequest *)userGoldListRequestWithUserId:(NSString *)user_id
                                     WithPage:(NSString *)page
                              withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock;



#pragma mark ---- 炮友圈左侧消息 - 消息红点校验
- (TTIRequest *)messageRedRequestwithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                              withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 我的话题删除
- (TTIRequest *)myTopicCancelwithTid:(NSString *) tid withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                             withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 推送消息
- (TTIRequest *)tuisongRequestWith:(NSString *)uid withtype:(NSString*)type withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                     withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma 在线客服
- (TTIRequest *)kefuChat:(NSString *)uid withcontent:(NSString*)content withNick_name:(NSString*)nick_name withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
- (TTIRequest *)shuxinLiaotian:(NSString *)uid withlinenum:(NSString*)linenum withPage:(NSString*)page withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
- (TTIRequest *)getUnReadMessageWithUserid:(NSString *)user_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
               withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma 我的订单list
- (TTIRequest *)getOrderListMessage:(NSString *)user_id withpage:(NSString *)page withOrder_type:(NSString *)type withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 提交售后服务
- (TTIRequest *)postSHServeWithuser_id:(NSString *)user_id
                             withorder_sn:(NSString *)order_sn
                             withgoods_id:(NSString *)goods_id
                         withproduct_id:(NSString *)product_id
                      withAmount_apply:(NSString *)amount_apply
                         withMessage:(NSString *)service_type
                          withOrder_id:(NSString *)order_id
                         withPhotos0:(UIImage *)photos0
                         withPhotos1:(UIImage *)photos1
                         withPhotos2:(UIImage *)photos2
                        withdescript:(NSString *)descript
                     withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                     withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 进度查询
- (TTIRequest *)checkJinDu:(NSString *)user_id withpage:(NSString *)page withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                    withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
- (TTIRequest *)cancleOrder:(NSString *)user_id withorder_sn:(NSString *)order_sn withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 再次购买
- (TTIRequest *)buyAgain:(NSString *)goods_id withgoods_number:(NSString *)goodsNum withSid:(NSString *)sid withproduct_id:(NSString *)product_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
         withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 取消审核
- (TTIRequest *)cancelServeListWithuser_id:(NSString *)user_id withservice_id:(NSString *)service_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 客服在线
- (TTIRequest *)kefuisOnlinewithSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                           withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 运单查询
- (TTIRequest *)shouhuoDiZhiChaXun:(NSString *)yunDanHao withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                            withFailedBlock:(TTIRequestCompletedBlock )failedBlock;
#pragma mark -- 上传视频
- (TTIRequest *)postMovie:(NSString *)user_id withSucessBlock:(TTIRequestCompletedBlock )sucessBlock
                   withFailedBlock:(TTIRequestCompletedBlock )failedBlock;

@end