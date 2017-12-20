# iOS实时语音识别、文本朗读 SDK 接入指南（v1.0.0）

Deploy target : iOS 8.0.

## 1 注意：

目前只支持真机使用，不支持模拟器，模拟器上编译会报错。


## 2 如何接入

### 1.1 手动下载 SDK

[点击这里下载](http://s.newscdn.cn/ios_pod_sdk/realtime_nls/ShuWen_Realtime_NLS_1.0.0.zip)

### 1.2 将下载的 zip 解压缩后拖入项目中

### 1.3 在项目 Build Phases -> Link Binary With libraries 添加以下依赖

| Framework | 描述 |
| --- | --- |
|libc++.tbd             |    提供对C/C++特性支持    |
|libstdc++.6.0.9.tbd    |    提供C++标准库的支持    |
|libiconv.2.4.0.tbd     |    提供编码转换支持       |
|libz.1.2.5.tbd         |    提供gzip支持           |
|AudioToolbox           |    提供录音和播放支持      |
|AVFoundation           |    提供录音和播放支持      |
|CFNetwork              |    提供对网络访问的支持      |
|CoreLocation           |    提供对获取设备地理位置的支持，以提高识别准确度 |
|CoreTelephony          |    提供对移动网络类型判断的支持  |
|SystemConfiguration    |    提供对网络状态检测的支持    |
|GLKit                  |    内置识别控件所需           |
|AudioToolbox           |    提供录音和播放支持          |
|sqlite3.0              |    数据存储                |

## 3 Regist your app.

Get your AppKey in our web site.
appKey值可从新华智云接口人获取（网站建设中，目前请联系接口人）

## 4 How to use

### 4.1 设置AppKey和AppSecret

```Objective-C
[SWRPublicConfig setBaiduAppId:@“Your_AppId” APIKey:@"Your_APIKey" secretKey:@"Your_SecretKey"];
[SWRPublicConfig setSWAppKey:@“Your_AppKey” secretKey:@"Your_AppSecret"];
```

### 4.2 ASR, 语音转文字

短语音识别，长度限制`60s`，主要用于语音输入。
delegate方法，最终都在主线程中回调。

```Objective-C
@protocol SWRASRClientDelegate <NSObject>
/**
*    @brief    语音识别的关键回调函数，delegate必须实现。
*              在收到识别结果、出错、结束时，会收到这个回调方法。
*    @param    asrClient   SWRASRClient
*    @param    result      识别结果，同一次识别中直接使用当前返回结果，不需要和上次结果拼接
*    @param    isComplete  本次识别已结束标志符，本次回调中的result为识别最终结果。
*    @param    error       错误信息
*/
- (void)asrClient:(SWRASRClient *)asrClient didReceiveServiceResponse:(SWRASRSpeechResult *)result isComplete:(BOOL)isComplete error:(NSError *)error;

@optional
/**
*    @brief    语音识别模式下，返回语音音量。
*
*    @param    asrClient       SWRASRClient
*    @param    voiceVolume     0-100的整数值
*/
- (void)asrClient:(SWRASRClient *)asrClient recordingWithVoiceVolume:(NSUInteger)voiceVolume;
@end


@interface SWRASRClient : NSObject
/**
*    @brief    实例化快捷方法。
*
*    @param    delegate    delegate
*
*    @return   instance
*/
+ (instancetype)initWithDelegate:(id<SWRASRClientDelegate>)delegate;
/**
*    @brief    开始识别。
*/
- (void)start;
/**
*    @brief    结束识别。
*/
- (void)stop;
/**
*    @brief    取消识别。
*/
- (void)cancel;
@end
```


### 4.3 tts, 文字转语音

delegate方法，最终都在主线程中回调。


```Objective-C
@protocol SWRTTSClientDelegate <NSObject>

@optional
/**
*    @brief    开始朗读时收到的回调。
*    @param    ttsClient   SWRTTSClient
*    @param    sentence    speak sentence 语句对应的ID，对应于调用startSpeakText:(NSString *)text的次数
*/
- (void)ttsClientDidStartSpeak:(SWRTTSClient *)ttsClient sentence:(NSInteger)sentence;
/**
*    @brief    结束朗读时收到的回调。
*    @param    ttsClient   SWRTTSClient
*    @param    sentence    speak sentence 语句对应的ID，对应于调用startSpeakText:(NSString *)text的次数
*/
- (void)ttsClientDidFinishSpeak:(SWRTTSClient *)ttsClient sentence:(NSInteger)sentence;
/**
*    @brief    出错的回调时收到的回调。
*    @param    ttsClient   SWRTTSClient
*    @param    error       出错信息
*    @param    sentence    speak sentence 语句对应的ID，对应于调用startSpeakText:(NSString *)text的次数
*/
- (void)ttsClient:(SWRTTSClient *)ttsClient failWithError:(NSError *)error speaking:(NSInteger)sentence;
@end


@interface SWRTTSClient : NSObject
/**
*    @brief    获取单例。
*/
+ (instancetype)shareInstance;
/**
*    @brief    配置代理。
*    @param    delegate    delegate
*/
- (void)setTTSClientDelegate:(id<SWRTTSClientDelegate>)delegate;
/**
*    @brief    传入TTS文本内容，开始朗读
如果正在朗读，将取消当前朗读。立刻朗读当前文本。
*    @param    text    传入的文本，文本可能由于长度过长被分段
*    @return   最后的一个段落的sentenceID
*/
- (NSInteger)startSpeakText:(NSString *)text;
/**
*    @brief    传入TTS文本内容，开始朗读
如果正在朗读，新文本叠加到后面。如希望立刻朗读当前文本，应该调用startSpeakText。
*    @param    text    传入的文本，文本可能由于长度过长被分段
*    @return   最后的一个段落的sentenceID
*/
- (NSInteger)queueSpeakText:(NSString *)text;
/**
*    @brief    暂停朗读
*/
- (void)pause;
/**
*    @brief    继续朗读
*/
- (void)resume;
/**
*    @brief    取消朗读
*/
- (void)cancel;

@end

```

## 5 其它

项目使用了http协议，所以需要适配
在`Info.plist`中添加`NSAppTransportSecurity`类型`Dictionary`。
在`NSAppTransportSecurity`下添加```NSAllowsArbitraryLoads`类型`Boolean`，值设为`YES`。

项目需要使用麦克风，需要适配
在`Info.plist`中添加`Privacy - Microphone Usage Description`类型`NSString`。

将 `Build setting` 下 `Build Options` 中的`Enable Bitcode` 置为 `NO`。

