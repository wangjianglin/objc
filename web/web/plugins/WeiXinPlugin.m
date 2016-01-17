//
//  WeiXinPlugin.m
//  buyers
//
//  Created by lin on 4/14/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "WeiXinPlugin.h"
#import "LinCore/core.h"


// 分享场景
typedef enum {
    WeChatShareToFriends,
    WeChatShareOnMonent,
} WeChatShareScene;

#define kWeChatShareFromExtension @"wxfe8929c7097f09cc"
//#define kWeChatShareFromExtension @"wx86b79000a2120cc7"

// 直接本地应用间分享到微信（类似系统照片中分享到微信）
BOOL WeChatShareDirect(NSArray *images, WeChatShareScene scene,NSString * text) {
    //
    NSData *thumbData = nil;
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:images.count];
    NSMutableArray *fileDatas = [NSMutableArray arrayWithCapacity:images.count];
    for (UIImage *image in images)
    {
        if([image isKindOfClass:[NSNull class]]){
            continue;
        }
        NSData *data = UIImagePNGRepresentation(image);
        if (data)
        {
            [fileDatas addObject:data];
            [urls addObject:[NSString stringWithFormat:@"file:///var/mobile/Media/DCIM/100APPLE/IMG_%04d.PNG", rand() % 9999]];
            
#ifdef kWeChatShareMakeThumb
            if (scene == WeChatShareOnMonent && !thumbData)
            {
                CGSize size;
                if (image.size.width > image.size.height)
                {
                    size.width = 130;
                    size.height = 130 * image.size.height / image.size.width;
                }
                else
                {
                    size.height = 130;
                    size.width = 130 * image.size.width / image.size.height;
                }
                UIImage *thumbImage = kWeChatShareMakeThumb(image, size);
                thumbData = UIImageJPEGRepresentation(thumbImage, 0.6);
            }
#endif
        }
    }
    
    //
    NSDictionary *log = @
    {
        @"$archiver":@"NSKeyedArchiver",
        @"$version":@100000,
        @"$top":@{@"root":@{@"CF$UID":@1}},
        @"$objects":@[
                      @"$null",
                      @{
                          @"$class":@{@"CF$UID":@2},
                          @"finished time":@0,
                          @"host app":@1,
                          @"launch time":[NSNumber numberWithLong:time(0)],	// TODO: Auto Generation
                          @"photos count":@1,
                          @"resource type":@1,
                          @"share feature":@2,
                          @"video count":@0,
                          },
                      @{
                          @"$classes":@[@"SELogData", @"NSObject"],
                          @"$classname":@"SELogData",
                          },
                      ]
    };
    NSData *logData = (__bridge_transfer NSData *)CFPropertyListCreateData(NULL, (__bridge CFPropertyListRef)log, kCFPropertyListBinaryFormat_v1_0, 0, 0);
    
    //
    NSMutableDictionary *appDict = [NSMutableDictionary dictionary];
    appDict[@"mediaTagName"] = @"WECHAT_TAG_JUMP_APP";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.9 ||	// iOS < 7.0
        ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"QQ41C152CF://"]])	// 微信 < 6.1
    {
        appDict[@"objectType"] = @"2";
        appDict[@"messageAction"] = @"<action>dotalist</action>";
        appDict[@"messageExt"] = @"";
        UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"wechat_file" create:YES];
        [pasteboard setPersistent:YES];
        [pasteboard setData:thumbData forPasteboardType:@"content"];
    }
    else
    {
        appDict[@"objectType"] = @"10";
        if (fileDatas) appDict[@"fileDatas"] = fileDatas;
        if (urls) appDict[@"urls"] = urls;
        if (log) appDict[@"log"] = logData;
    }
    appDict[@"result"] = @"1";
    appDict[@"returnFromApp"] = @"0";
    appDict[@"scene"] = [NSString stringWithFormat:@"%d", scene];
    appDict[@"sdkver"] = @"1.5";
    appDict[@"command"] = @"1010";
    if (thumbData) appDict[@"thumbData"] = thumbData;
    
    
    //
    NSDictionary *content = @{kWeChatShareFromExtension:appDict};
    NSData *contentData = (__bridge_transfer NSData *)CFPropertyListCreateData(NULL, (__bridge CFPropertyListRef)content, kCFPropertyListBinaryFormat_v1_0, 0, 0);
    
    //
    UIPasteboard *pasteboard;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.9)
    {
        pasteboard = [UIPasteboard pasteboardWithName:@"wechat_data" create:YES];
        [pasteboard setPersistent:YES];
    }
    else
    {
        pasteboard = [UIPasteboard generalPasteboard];
    }
    [pasteboard setData:contentData forPasteboardType:@"content"];//kUTTypePNG
    
    NSString *launchUrl = [NSString stringWithFormat:@"weixin://app/%@/sendreq/?", kWeChatShareFromExtension];
    BOOL r = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchUrl]];
    
    //    UIPasteboard * item = [UIPasteboard generalPasteboard];
    //    item.persistent = TRUE;
    //
    //    item.string = text;
    
    //    [Queue asynQueue:^{
    //        [NSThread sleepForTimeInterval:1500];
    //        UIPasteboard * item = [UIPasteboard generalPasteboard];
    //        item.persistent = TRUE;
    //        item.string = text;
    //    }];
    return r;
}

@interface WeiXinPlugin(){//<UIScrollViewDelegate>{
//    UIImageView * _imageView;
    UILabel * _label;
    UIColor * _color;
    UIFont * _font;
}

@end
@implementation WeiXinPlugin

-(instancetype)initWithWebView:(UIWebView *)webView{
    self = [super initWithWebView:webView];
    if(self){
        _label = [[UILabel alloc] init];
        _color = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        //_color = [UIColor redColor];
        //_font = [UIFont systemFontOfSize:22];
        _font = [UIFont boldSystemFontOfSize:22];
        _label.font = _font;
    }
    return self;
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;{
//    return _imageView;
//}
-(void)shareImpl:(Json*)args{

    
    NSArray * tmpImages = args[@"images"].asArray;
    NSString * sn = args[@"sn"].asString;
    NSMutableArray * images = [[NSMutableArray alloc] init];
    for (Json * image in tmpImages) {
        NSObject * item = (__bridge id)[self waterMark:[UIImage imageWithURLString:image.asString] text:sn].CGImage;
        if(item != nil){
            [images addObject:item];
        }
    }
    
    UIApplication * app =[UIApplication sharedApplication];
    UIWindow * window = app.windows[0];
    
    __block LinActivityIndicatorView * indicator = [[LinActivityIndicatorView alloc] init];
    indicator.label.text = @"正在切换到微信，请稍候...";
    indicator.label.font = [UIFont boldSystemFontOfSize:16.0];
    indicator.label.textColor = [[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    indicator.backgroundColor = [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:0.6];
    [window addSubview:indicator];
    
    
    __block __weak LinActivityIndicatorView * _indicator = indicator;
    ALAssetsLibrary * libray = [[ALAssetsLibrary alloc] init];
    [libray writeImageToSavedPhotosAlbums:images albumName:@"翡翠吧吧" metadata:nil completion:^(NSArray *urls, NSArray *errors) {
    
        [_indicator remove];
        UIPasteboard *pasteboard;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.9)
        {
            pasteboard = [UIPasteboard pasteboardWithName:@"wechat_data" create:YES];
            [pasteboard setPersistent:YES];
        }
        else
        {
            pasteboard = [UIPasteboard generalPasteboard];
        }
        pasteboard.string = args[@"text"].asString;
        
        NSString *launchUrl = [NSString stringWithFormat:@"weixin://app/%@/sendreq/?", kWeChatShareFromExtension];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchUrl]];
        
    }];

   
}
-(Json*)share:(Json*)args{
//    NSLog(@"args:%@",args);
    [self shareImpl:(Json*)args];
//    
//    NSArray * tmpImages = args[@"images"].asArray;
//    NSString * sn = args[@"sn"].asString;
//    NSMutableArray * images = [[NSMutableArray alloc] init];
//    for (Json * image in tmpImages) {
////        [images addObject:image.asString];
//        [images addObject:[self waterMark:[UIImage imageWithURLString:image.asString] text:sn]];
//    }//WeChatShareToFriends,WeChatShareOnMonent
//    if ([args[@"scene"].asString isEqualToString:@"friend"]) {
//        WeChatShareDirect(images,WeChatShareToFriends,@"");
//    }else{
//        WeChatShareDirect(images,WeChatShareOnMonent,@"");
//    }

    return [[Json alloc] initWithObject:@"ok."];
}



-(Json*)shareText:(Json*)args{
    
    return [[Json alloc] initWithObject:@"ok."];
}


-(UIImage *)waterMark:(UIImage *)image text:(NSString*)text{
    
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(contextRef, 0, image.size.height);  //画布的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);  //画布翻转
    
    [_color set];
    CGContextTranslateCTM(contextRef, 0, image.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    _label.text = text;
    CGContextSetBlendMode(contextRef,kCGBlendModeColorBurn);
    CGSize textSize = [_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    [text drawInRect:CGRectMake(image.size.width - textSize.width - 20, image.size.height - textSize.height - 10, textSize.width, textSize.height) withFont:_font];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



// 直接本地应用间分享到微信（类似系统照片中分享到微信）
//BOOL WeChatShareLinkDirect(NSArray *images, WeChatShareScene scene,NSString * text) {

-(Json*)shareLink:(Json*)args{
    
    
    NSString * title = [args[@"title"] asString:@""];
    NSString * desc = [args[@"desc"] asString:@""];
    NSString * scene = [args[@"scene"] asString:@""];
    NSString * link = [args[@"link"] asString:@""];
//    WeChatShareScene scene = WeChatShareToFriends;
//    NSString * text = @"测试文本！";
//    NSData *thumbData = nil;
//    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:images.count];
//    NSMutableArray *fileDatas = [NSMutableArray arrayWithCapacity:images.count];
    
    
    //
    
    //
    NSMutableDictionary *appDict = [NSMutableDictionary dictionary];
   
    appDict[@"mediaTagName"] = @"WECHAT_TAG_JUMP_SHOWRANK";
    appDict[@"mediaUrl"] = link;
//    appDict[@"thumbData"]  = nil;
    appDict[@"title"] = title;
    appDict[@"description"] = desc;
    
    
    appDict[@"objectType"] = @"5";
    appDict[@"result"] = @"1";
    appDict[@"returnFromApp"] = @"0";
    if([scene isEqualToString:@"friend"]){
        appDict[@"scene"] = [NSString stringWithFormat:@"%d", WeChatShareToFriends];
    }else{
        appDict[@"scene"] = [NSString stringWithFormat:@"%d", WeChatShareOnMonent];
    }
    appDict[@"sdkver"] = @"1.5";
    appDict[@"command"] = @"1010";
    
    UIImage *thumbImage = [UIImage imageNamed:@"LinWeb.bundle/weixin-link.png"];
    NSData * thumbData = UIImageJPEGRepresentation(thumbImage, 0.6);
    
    if (thumbData) appDict[@"thumbData"] = thumbData;
    
    
    //
    NSDictionary *content = @{kWeChatShareFromExtension:appDict};
    NSData *contentData = (__bridge_transfer NSData *)CFPropertyListCreateData(NULL, (__bridge CFPropertyListRef)content, kCFPropertyListBinaryFormat_v1_0, 0, 0);
    
    //
    UIPasteboard *pasteboard;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.9)
    {
        pasteboard = [UIPasteboard pasteboardWithName:@"wechat_data" create:YES];
        [pasteboard setPersistent:YES];
    }
    else
    {
        pasteboard = [UIPasteboard generalPasteboard];
    }
    [pasteboard setData:contentData forPasteboardType:@"content"];//kUTTypePNG
    
    NSString *launchUrl = [NSString stringWithFormat:@"weixin://app/%@/sendreq/?", kWeChatShareFromExtension];
    BOOL r = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchUrl]];
    
    //    UIPasteboard * item = [UIPasteboard generalPasteboard];
    //    item.persistent = TRUE;
    //
    //    item.string = text;
    
    //    [Queue asynQueue:^{
    //        [NSThread sleepForTimeInterval:1500];
    //        UIPasteboard * item = [UIPasteboard generalPasteboard];
    //        item.persistent = TRUE;
    //        item.string = text;
    //    }];
    
    return [[Json alloc] initWithObject:@""];

}
@end
