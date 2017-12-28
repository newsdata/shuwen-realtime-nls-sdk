# iOS Voice SDK 接入指南（v1.0.4）

支持实时语音识别、文本朗读、长录音识别
Deploy target : iOS 8.0.

## 1 注意：

目前只支持真机使用，不支持模拟器，模拟器上编译会报错。

## 2 如何接入

### 2.1 手动下载 SDK

- [点击这里下载](http://newscdn.oss-cn-hangzhou.aliyuncs.com/ios_pod_sdk/voice_sdk/ShuWen_Voice_1.0.4.zip)
- 下载后，可校验 zip 文件，当前文件的
    - md5:  b1e519a39307ba3cea7896ddb754feeb
    - sha1: 71a78fd6e43452e9b3c9117f9953c06b3cf73e61
- 校验 zip 文件方式：

```shell
# 查看 md5 值
md5 ShuWen_Voice_1.0.4.zip
# 查看 sha1 值
shasum ShuWen_Voice_1.0.4.zip
```

### 2.2 使用方法
将下载的 zip 解压缩后拖入项目中。

项目使用了http协议，所以需要适配
在`Info.plist`中添加`NSAppTransportSecurity`类型`Dictionary`。
在`NSAppTransportSecurity`下添加```NSAllowsArbitraryLoads`类型`Boolean`，值设为`YES`。

项目需要使用麦克风，需要适配
在`Info.plist`中添加`Privacy - Microphone Usage Description`类型`NSString`。

将 `Build Setting` 下 `Build Options` 中的`Enable Bitcode` 置为 `NO`。

将 `Build Setting` 下 `Other Linker Flags` 中的`-ObjC`和`${inherited}`。

通过pod引入`AliyunOSSiOS`和`UTDID`
```
pod 'AliyunOSSiOS', '~> 2.8.0'
pod 'UTDID', '~> 1.0.0'
```


### 2.3 在项目 Build Phases -> Link Binary With libraries 添加以下依赖

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
*    @param    sentence    speak sentence 语句对应的ID
*/
- (void)ttsClientDidStartSpeak:(SWRTTSClient *)ttsClient sentence:(NSInteger)sentence;
/**
*    @brief    结束朗读时收到的回调。
*    @param    ttsClient   SWRTTSClient
*    @param    sentence    speak sentence 语句对应的ID
*/
- (void)ttsClientDidFinishSpeak:(SWRTTSClient *)ttsClient sentence:(NSInteger)sentence;
/**
*    @brief    出错的回调时收到的回调。
*    @param    ttsClient   SWRTTSClient
*    @param    error       出错信息
*    @param    sentence    speak sentence 语句对应的ID
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

### 4.4 离线长录音识别

```
/**
*  用于处理长录音的上传与识别
*  NOTICE: 一个实例同一时间只能上传一个文件。
*/
@interface SWRAudioFileRecognizer : NSObject
/**
*    @brief    上传识别的数据
*    @param    data        待识别音频数据
*    @param    audioformat     录音文件格式，m4a，mp3，pcm，amr，opus，wav等
*    @param    language        ASR识别语音，默认值为"zh-CN"，也支持"en-US"
*    @param    allowBackgroundUpload   是否允许后台上传，注意如果app没有申请后台网络访问权限，传入YES，可能会引发异常
*    @param    progressCallback    上传过程中，上传进度的回调，不定期回调
*    @param    completionHandler   上传完成后的回调，包含提取识别结果时需要的taskId、clientErrMsg、clientCode，clientCode为200表示没有错误，此时的taskId才有效
*/
- (void)uploadRecognizeData:(NSData *)data audioformat:(NSString *)audioformat language:(NSString *)language allowBackgroundUpload:(BOOL)allowBackgroundUpload progress:(void(^)(double progress))progressCallback completionHandler:(void(^)(NSString *taskId, NSString *clientErrMsg, NSInteger clientCode))completionHandler;

/**
*    @brief    上传识别的数据
*    @param    filepath    待识别音频文件的路径， 认为uri的最后一段为文件名，并根据文件名获取待识别音频数据的格式类型
*    @param    audioformat     录音文件格式，m4a，mp3，pcm，amr，opus，wav等
*    @param    language        ASR识别语音，默认值为"zh-CN"，也支持"en-US"
*    @param    allowBackgroundUpload   是否允许后台上传，注意如果app没有申请后台网络访问权限，传入YES，可能会引发异常
*    @param    progressCallback    上传过程中，上传进度的回调，不定期回调
*    @param    completionHandler   上传完成后的回调，包含提取识别结果时需要的taskId、clientErrMsg、clientCode，clientCode为200表示没有错误，此时的taskId才有效
*/
- (void)uploadRecognizeFilePath:(NSString *)filepath audioformat:(NSString *)audioformat language:(NSString *)language allowBackgroundUpload:(BOOL)allowBackgroundUpload progress:(void(^)(double progress))progressCallback completionHandler:(void(^)(NSString *taskId, NSString *clientErrMsg, NSInteger clientCode))completionHandler;

/**
*    @brief    取消正在上传文件的上传
*/
- (void)cancelUpload;

/**
*    @brief    提取识别结果，需要客户端轮询，如果服务端还没有识别成功，回调函数中返回空串，并附有error信息。
*    @param    taskId    提取识别结果需要传入的id
*    @param    completionHandler   回调，包含识别状态、识别结果、clientErrMsg、clientCode，clientCode为200表示没有错误、且识别状态为0，此时的识别结果才有效
status， 0表示已经识别完成; 1表示还未识别，正在排队中; 2表示正在识别中
result， 识别结果
*/
- (void)fetchRecoginzeResult:(NSString *)taskId completionHandler:(void(^)(NSInteger status, NSString *result, NSString *clientErrMsg, NSInteger clientCode))completionHandler;
```


