//
//  PPShareManager.m
//  TDQianxiaoer
//
//  Created by 林晖杰 on 16/3/28.
//  Copyright © 2016年 林晖杰. All rights reserved.
//

#import "PPShareManager.h"
#import "WXApi.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>  

static PPShareManager *instance = nil;

@implementation PPShareManager

#pragma mark - Life Cycle

#pragma mark - Event Response

#pragma mark - --Notification Event Response

#pragma mark - --Button Event Response

#pragma mark - --Gesture Event Response

#pragma mark - System Delegate

#pragma mark - Custom Delegate

#pragma mark - Public Function
//+ (PPShareManager *)shareInstance {
//    @synchronized(self) {
//        if (nil == instance) {
//            instance = [[PPShareManager alloc] init];
//        }
//    }
//    return instance;
//}
//
//- (void)initShareConfig {
//    
//     [[UMSocialManager defaultManager] openLog:YES];
//    
//    // 设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_KEY];
//    
//    // 设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
//                                          appKey:WECHAT_PLATFORM_ID
//                                       appSecret:WECHAT_PLATFORM_SECRET
//                                     redirectURL:nil];
//    
//    
//    // 设置分享到QQ互联的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
//                                          appKey:QQ_PLATFORM_ID
//                                       appSecret:nil
//                                     redirectURL:nil];
//    
//    // 设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
//                                          appKey:SINA_PLATFORM_ID
//                                       appSecret:SINA_PLATFORM_SECRET
//                                     redirectURL:SINA_PLATFORM_REDIRECT];
//    
//}
//
//- (BOOL)handleOpenUrl:(NSURL *)url {
//    return [[UMSocialManager defaultManager] handleOpenURL:url];
//}
//
//- (BOOL)handleOpenUrl:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
//    return [[UMSocialManager defaultManager] handleOpenURL:url options:options];
//}
//
//- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    
//}
//
//+ (BOOL)isQQInstalled {
//    return [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
//}
//
//+ (BOOL)isWXAppInstalled {
//    return [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
//}
//
//+ (BOOL)isWeiboInstalled {
//    return [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina];
//}
//
//+ (BOOL)isInstalledPlatform:(UMSocialPlatformType)platformType {
//    return [[UMSocialManager defaultManager] isInstall:platformType];
//}
//
//- (void)shareTitle:(NSString *)shareTitle
//      shareContent:(NSString *)shareContent
//        shareImage:(id)shareImage
//          shareUrl:(NSString *)shareUrl
//      platformType:(UMSocialPlatformType)platformType
//      onCompletion:(ShareCompleteBlock)completionBlock
//           onError:(ShareFailBlock)errorBlock {
//    
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    NSString *l_shareTitle   = shareTitle;
//    NSString *l_shareContent = shareContent;
//    
//    if (!l_shareTitle) {
//        l_shareTitle = @"";
//    }
//    
//    if (!l_shareContent) {
//        //设置文本
//        l_shareContent = @"";
//    }
//
//    if (shareUrl) {
//        if (!shareImage) {
//            NSLog(@"PPShareManager - 分享的图片内容不能为空");
//            return;
//        }
//        
//        //创建网页内容对象
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:l_shareTitle
//                                                                                 descr:l_shareContent
//                                                                             thumImage:shareImage];
//        
//        //设置网页地址
//        shareObject.webpageUrl            = shareUrl;
//        
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject         = shareObject;
//        
//    }
//    else {
//        messageObject.title = l_shareTitle;
//        messageObject.text  = l_shareContent;
//        
//        if (shareImage) {
//            //创建图片内容对象
//            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//            [shareObject setShareImage:shareImage];
//            
//            //分享消息对象设置分享内容对象
//            messageObject.shareObject = shareObject;
//        }
//    }
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType
//                                        messageObject:messageObject
//                                currentViewController:nil
//                                           completion:^(id data, NSError *error) {
//                                               
//                                               if (error) {
//                                                   errorBlock(error);
//                                               }
//                                               else {
//                                                   completionBlock(data);
//                                               }
//    }];
//    
//}
//
//- (void)loginWithPlatformType:(UMSocialPlatformType)platformType
//        presentViewController:(UIViewController *)viewController
//                 onCompletion:(LoginCompleteBlock)completionBlock
//                      onError:(LoginFailBlock)errorBlock {
//    
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(id result, NSError *error) {
//        
//        if (!error) {
//            UMSocialUserInfoResponse *userinfo = result;
//            completionBlock(userinfo);
//            
//        } else {
//            errorBlock(error);
//        }
//    }];
//}
//
//- (void)resignOauthWithTypePlatformType:(UMSocialPlatformType)platformType
//                           onCompletion:(ResignCompleteBlock)completeBlock {
//    
//    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
//        if (!error) {
//            completeBlock(YES);
//            
//        } else {
//            completeBlock(NO);
//        }
//    }];
//}

#pragma mark - Private Function

#pragma mark - Getter and Setter

@end
