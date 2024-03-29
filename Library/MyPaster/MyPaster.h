//
//  MyPaster.h
//  MyPaster
//
//  Created by 蔡成汉 on 16/8/11.
//  Copyright © 2016年 蔡成汉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////      Paster     /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  Paster基类
 */
@interface Paster : NSObject<NSCoding>

@property (nonatomic, assign) NSTimeInterval paster_id;

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) CGRect bounds;

/** 旋转角度 默认为0 */
@property (nonatomic, assign) CGFloat rotateAngle;

/** 是否镜像 默认为NO */
@property (nonatomic, assign) BOOL isMirror;

/**
 *  贴花尺寸
 *  图片类型默认为120x120：即初始化出的贴花尺寸；非方形图片会等比缩放。
 *  文字类型默认为160x80：即初始化出的贴花尺寸；非方形图片会等比缩放。
 */
@property (nonatomic , assign) CGSize size;

/**
 *  贴花背景图 -- 默认为nil
 */
@property (nonatomic , strong) UIImage *backgroundImage;

@end


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////   ImagePaster   /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  Paster图片类
 */
@interface ImagePaster : Paster

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imagePath;

/**
 *  图片
 */
@property (nonatomic , strong) UIImage *image;

@end

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////    TextPaster   /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  Paster文本类
 */
@interface TextPaster : Paster

/**
 *  文本内容
 */
@property (nonatomic , strong) NSString *text;

/**
 *  文本颜色
 */
@property (nonatomic , strong) UIColor *textColor;

/**
 *  文本字体 -- 忽略大小
 */
@property (nonatomic , strong) UIFont *font;

@end


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////     MyPaster    /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  MyPasterDelegate
 */
@protocol MyPasterDelegate;

@interface MyPaster : UIView

/**
 *  MyPasterDelegate
 */
@property (nonatomic , weak) id<MyPasterDelegate>delegate;

/**
 *  原始图片
 */
@property (nonatomic , strong) UIImage *originImage;

/**
 *  贴花后生成的图片
 */
@property (nonatomic , readonly) UIImage *pasterImage;

/**
 *  删除按钮图片
 */
@property (nonatomic , strong) UIImage *deleteIcon;

/**
 *  尺寸控制按钮图片
 */
@property (nonatomic , strong) UIImage *sizeIcon;

/**
 *  旋转按钮图片
 */
@property (nonatomic , strong) UIImage *rotateIcon;

/**
 *  按钮尺寸 -- 默认为30x30
 */
@property (nonatomic , assign) CGSize iconSize;

/**
 *  currentPaster
 */
@property (nonatomic , strong) Paster *currentPaster;

/**
 *  添加贴花 -- 位置随机
 *
 *  @param paster Paster
 */
-(void)addPaster:(Paster *)paster;

/**
 *  getPasterImage
 *
 *  @return pasterImage
 */
-(UIImage *)getPasterImage;

- (void)saveAllPasterParameters;

@end


////////////////////////////////////////////////////////////////////////////////
////////////////////////////                      //////////////////////////////
////////////////////////////   MyPasterDelegate   //////////////////////////////
////////////////////////////                      //////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@protocol MyPasterDelegate <NSObject>

@optional

/**
 *  pasterIsSelect
 *
 *  @param myPaster myPaster
 *  @param paster   selectPaster
 */
-(void)myPaster:(MyPaster *)myPaster pasterIsSelect:(Paster *)paster;

- (void)myPaster:(MyPaster *)myPaster deletePaster:(Paster *)paster;

@end

