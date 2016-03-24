//
//  MarkGet_two-dimension.h
//  Group-buying
//
//  Created by 叶杨杨 on 15/6/1.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//自定义一个protocol
@protocol MarkGet_twodimensionDelegate <NSObject>

//获取二维码的网址信息后的回调方法

-(void)get_twodimensionSuccessWithInfo:(NSString *)info;


@end

//AVCaptureMetaDataOutput：支持二维码及其他类型码识别
@interface MarkGet_two_dimension : UIView <AVCaptureMetadataOutputObjectsDelegate>

//视频抓屏预览层
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *videoLayer;
//使用AVCaptureSession 拍照，摄像，载图总结
@property (nonatomic,strong)AVCaptureSession *captureSession;

@property (nonatomic,strong)UIView *codeFrameView;


//输出流
@property (nonatomic,strong)AVCaptureMetadataOutput *outPut;


@property (nonatomic,weak)id<MarkGet_twodimensionDelegate>delegate;


//实例方法
- (void)get_twodimension;

@end
