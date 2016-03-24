//
//  MarkSharedTool.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/6/1.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "MarkSharedTool.h"
#import "WXApi.h"

@implementation MarkSharedTool

//单例
+(MarkSharedTool *)sharedTool {

    //1，声明一个空的静态的单例对象
    static MarkSharedTool *_sharedTool = nil;

     // 2. 声明一个静态的GCD的单次任务

    static dispatch_once_t onceToken;
    // 3. 执行GCD的单次任务，把单例初始化
    dispatch_once(&onceToken, ^{
      
        _sharedTool = [[self alloc]init];
        
    });

    // 4. 返回单例对象

    
    return _sharedTool;

}
#pragma mark - //分享到微信朋友圈

- (void)sharedToWeiChatWithWebUrl:(NSURL *)url{
    
    //1，调用下面的方法  得到返回的字典数据
    NSDictionary *dict = [self getWebContentWithUrl:url];

   /*! @brief 多媒体消息结构体
    *
    * 用于微信终端和第三方程序之间传递消息的多媒体消息内容
    */
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = dict[@"title"];
    message.description = dict[@"description"];
    
    NSString *imageName = dict[@"imageName"];
    
    if (!imageName) {
        /*! @brief 设置消息缩略图的方法
         *
         * @param image 缩略图
         * @note 大小不能超过32K
         */
        [message setThumbImage:[UIImage imageNamed:@"AppIcon57x57"]];
    }else{
    
        [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]]];
    
    
    }
    
    /*! @brief 多媒体消息中包含的网页数据对象
     *
     * 微信终端和第三方程序之间传递消息中包含的网页数据对象。
     * @see WXMediaMessage
     */
    WXWebpageObject *webPage = [WXWebpageObject object];
    
    /** 网页的url地址
     * @note 不能为空且长度不能超过10K
     */

    webPage.webpageUrl = url.absoluteString;
    
    /**
     * 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
     */

    message.mediaObject = webPage;

    /*! @brief 第三方程序发送消息至微信终端程序的消息结构体
     *
     * 第三方程序向微信发送信息需要传入SendMessageToWXReq结构体，信息类型包括文本消息和多媒体消息，
     * 分别对应于text和message成员。调用该方法后，微信处理完信息会向第三方程序发送一个处理结果。
     * @see SendMessageToWXResp
     */
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc]init];
    
    request.bText = NO;
    request.message = message;
    request.scene = WXSceneTimeline;//发送到微信圈



    [WXApi sendReq:request];

}


#pragma mark - //分享给微信朋友
- (void)sharedtoWXfriendsWithUrl:(NSURL *)url{


    NSDictionary *dic = [self getWebContentWithUrl:url];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = dic[@"title"];
    message.description = dic[@"description"];
    NSString *imageName = dic[@"imageName"];
    
    if (imageName == nil) {
        
        [message setThumbImage:[UIImage imageNamed:@"AppIcon57x57"]];
        
    }else {
        [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]]];
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url.absoluteString;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];


}

#pragma mark - 解析URL    并返回一个字典

- (NSDictionary *)getWebContentWithUrl:(NSURL *)url{


    //1,解析这个webview的内容
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"str33333:%@",str);
    NSArray *subStr = [str componentsSeparatedByString:@"\n"];
    NSLog(@"substr:%@",subStr);
    //bool类型的 判断是否是JPG格式
    BOOL isJpg = NO;
    
    NSString *title = @"Mark recommend to you";
    
    NSString *description = @"please pay attention to this message";
    
    NSString *imageName = nil;
    
    
    for (NSString *doubleSub in subStr) {
        
        //charset=gb2312：是按中国的编码；charset=utf-8：是国际上标准的编码
        NSRange titleRange = [doubleSub rangeOfString:@"<meta charset=\"UTF-8\"/><title>"];
        NSRange descriptionRange = [doubleSub rangeOfString:@"仅售"];
        
        if (titleRange.length != 0) {
            
#warning 这里需要加注释！！！
            NSString *s1 = [doubleSub substringFromIndex:titleRange.location+titleRange.length];
            
            NSString *s2 = [s1 substringToIndex:s1.length-9];
            
            title = s2;
            
        }
        
        if (descriptionRange.length != 0) {
           
            
#warning 这里需要加注释！！！！
            NSString *s1 = [doubleSub substringFromIndex:descriptionRange.location];
            NSString *s2 = [s1 substringToIndex:s1.length - 4];
            
            description = s2;
            
    
        }
        
        //遍历被“”分割的string
        for (NSString *image in [doubleSub componentsSeparatedByString:@"\""]) {
            
            if ([image hasSuffix:@".jpg"]) {
                
                imageName = image;
                isJpg = YES;
                break;
                
                
                
            }
            
        }
        
        if (isJpg == YES) {
            
            break;
            
        }
        
        
        
}




    return @{@"title":title,@"description":description,@"imageName":imageName};


}


@end
