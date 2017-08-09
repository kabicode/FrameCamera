//
//  PPShareManager.h
//  TDQianxiaoer
//
//  Created by 林晖杰 on 16/3/28.
//  Copyright © 2016年 林晖杰. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UMSocialCore/UMSocialCore.h>

//友盟key
#define UMENG_KEY @"598ab4e7310c931120001e05"
//QQ平台ID
#define QQ_PLATFORM_ID @"1106234299"
//新浪平台ID
#define SINA_PLATFORM_ID @"SINA_PLATFORM_ID"
//微信平台ID
#define WECHAT_PLATFORM_ID @"wx2dfce5a1e40bea4c"
//微信平台Secret
#define WECHAT_PLATFORM_SECRET @"72b402517bf01f7242be89982ab75ba2"
//新浪平台Secret
#define SINA_PLATFORM_SECRET @"SINA_PLATFORM_SECRET"
//新浪平台回调地址
#define SINA_PLATFORM_REDIRECT @"SINA_PLATFORM_REDIRECT"

typedef void (^ShareCompleteBlock)(id statusInfo);
typedef void (^ShareFailBlock)(id error);

typedef void (^LoginCompleteBlock)(UMSocialUserInfoResponse *accountInfo);
typedef void (^LoginFailBlock)(id error);

typedef void (^ResignCompleteBlock)(BOOL resignSuccess);

@interface PPShareManager : NSObject

@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareActionContent;
@property (nonatomic,copy) NSString *shareActionImage;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,strong) UIImageView *shareImageView;

/**
 * method：实例化
 */
+ (PPShareManager *)shareInstance;

/**
 * method：判断机器是否安装QQ
 */
+ (BOOL)isQQInstalled;

/**
 * method：判断机器是否安装微信
 */
+ (BOOL)isWXAppInstalled;

/**
 * method：判断机器是否安装微博
 */
+ (BOOL)isWeiboInstalled;

/**
 * method：判断机器是否安装平台
 */
+ (BOOL)isInstalledPlatform:(UMSocialPlatformType)platformType;

/**
 * method：配置分享平台账号信息
 * platformConfig:平台账号信息
 */
- (void)initShareConfig;

/**
 * method：处理回调
 * url:回调的URL
 */
- (BOOL)handleOpenUrl:(NSURL *)url;

/**
 * method：处理回调
 * url:回调的URL
 */
- (BOOL)handleOpenUrl:(NSURL *)url
              options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

/**
 * method：处理回调
 * 微博回调需要设置
 */
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation;

/**
 * method：调用shareSdk分享
 * parm：platformType:平台类型
 * parm：shareContent:分享内容
 * parm：shareImage:要分享的图片数据 （UIImage或者NSData类型，或者image_url）
 * parm：shareTitle:分享的标题
 * parm：shareUrl:分享的指向
 * 返回值：
 */
- (void)shareTitle:(NSString *)shareTitle
      shareContent:(NSString *)shareContent
        shareImage:(id)shareImage
          shareUrl:(NSString *)shareUrl
      platformType:(UMSocialPlatformType)platformType
      onCompletion:(ShareCompleteBlock)completionBlock
           onError:(ShareFailBlock)errorBlock;

/**
 * method：调用shareSdk第三方登录
 * parm：platformType:平台类型
 * parm：viewController:调用的控制器
 */
- (void)loginWithPlatformType:(UMSocialPlatformType)platformType
        presentViewController:(UIViewController *)viewController
                 onCompletion:(LoginCompleteBlock)completionBlock
                      onError:(LoginFailBlock)errorBlock;

/**
 * method  取消第三方登录授权
 * parm：platformType:平台类型
 */
- (void)resignOauthWithTypePlatformType:(UMSocialPlatformType)platformType
                           onCompletion:(ResignCompleteBlock)completeBlock;

@end
