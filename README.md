# 数闻 shuwen-realtime-nls-sdk 说明文档（v0.1.0）

Deploy target : iOS 8.0.

## 0 注意：

SHWRealTimeNLSSDK 只能在真机在真机上使用，模拟器上会编译失败

## 1 如何接入

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


