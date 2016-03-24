//
//  MarkGet_two-dimension.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/6/1.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "MarkGet_two-dimension.h"

@implementation MarkGet_two_dimension


//懒加载并设置codeframeview 的一些信息

- (UIView *)codeFrameView{

    if (!_codeFrameView) {
        
        _codeFrameView = [[UIView alloc]init];
        _codeFrameView.layer.borderColor = (__bridge CGColorRef)([UIColor greenColor]);
        _codeFrameView.layer.borderWidth = 2;
        
        [self addSubview:_codeFrameView];
        
        //当启动扫描时 把扫描的页面放在最前面
        [self bringSubviewToFront:_codeFrameView];

    }


    return _codeFrameView;



}

//同样懒加载session

-(AVCaptureSession *)captureSession{


    if (!_captureSession) {
        
        _captureSession = [AVCaptureSession new];
        
    }
    


    return _captureSession;


}

//实现协议的方法
- (void)get_twodimension{
    
    //调用下面封装的方法
    [self startCapture];
    
    
    
}

- (void)startCapture{


    //1，获取摄像设备  也就是摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
   // AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    
    
    
    
    
    

    //2,想输出 必须先创建出入流 camera  就是输入的设备
    
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];

    //3,创建输出流
    
    self.outPut = [[AVCaptureMetadataOutput alloc]init];
    
    [self.outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    //4,添加输入流 和 输出流 到会话中
    [self.captureSession addInput:input];
    
    [self.captureSession addOutput:self.outPut];


    //5,给输出流添加元数据类型
    
   [self.outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,
         AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code]];
      //6，高质量采集
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    //7,设置预览层  添加会话 frame
    
    self.videoLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];

    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.videoLayer.frame = self.layer.bounds;
    
    [self.layer insertSublayer:self.videoLayer atIndex:0];
    
    
    //8,运行会话
    [self.captureSession startRunning];
    

}

//代理的可选方法

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    AVMetadataObject *metadataObject = [metadataObjects firstObject];
    
    if (metadataObject.type == AVMetadataObjectTypeQRCode) {
        
        AVMetadataMachineReadableCodeObject *object = (AVMetadataMachineReadableCodeObject *)[self.videoLayer transformedMetadataObjectForMetadataObject:metadataObject];
        self.codeFrameView.frame = object.bounds;
        
        if (object.stringValue != nil) {
           //拿到数据后就停止扫描了  也就是关闭会话
            [self.captureSession stopRunning];
            
            // 获取的数据其实就是字符串类型的网址
            [self.delegate get_twodimensionSuccessWithInfo:object.stringValue];
            
            
            
        }
        
        
    }else if (metadataObject.type == AVMetadataObjectTypeEAN13Code){
        
        AVMetadataMachineReadableCodeObject *object = (AVMetadataMachineReadableCodeObject *)[self.videoLayer transformedMetadataObjectForMetadataObject:metadataObject];
        self.codeFrameView.frame = object.bounds;
        
        if (object.stringValue != nil) {
            //拿到数据后就停止扫描了  也就是关闭会话
            [self.captureSession stopRunning];
            
            // 获取的数据其实就是字符串类型的网址
            [self.delegate get_twodimensionSuccessWithInfo:object.stringValue];
        }
    }




}
@end
