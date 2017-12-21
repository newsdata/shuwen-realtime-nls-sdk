#
# Be sure to run `pod lib lint SHWRealTimeNLSSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SHWRealTimeNLSSDK'
    s.version          = '0.0.1'
    s.summary          = '新华智云 SHWRealTimeNLS SDK'
    s.description      = 'SHWRealTimeNLSSDK 是对百度语音 TTS ASR 静态库的二次封装'
    s.homepage         = 'https://github.com/newsdata/shuwen-realtime-nls-sdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.authors          = { 'yangyang' => 'yangyang@shuwen.com', 'yehao' => 'yehao@shuwen.com' }
    s.ios.deployment_target = '8.0'

    s.source = { :http => 'http://s.newscdn.cn/ios_pod_sdk/realtime_nls/ShuWen_Realtime_NLS_1.0.0.zip' }

    s.ios.vendored_frameworks = "SHWRealTimeNLSSDK/SHWRealTimeNLS.framework"
    s.ios.vendored_libraries = 'SHWRealTimeNLSSDK/Librarys/libBaiduASR.a', 'SHWRealTimeNLSSDK/Librarys/libBaiduTTS.a'
    s.frameworks = 'AudioToolbox', 'AVFoundation', 'SystemConfiguration', 'CFNetwork', 'CoreLocation', 'CoreTelephony', 'GLKit'
    s.libraries = 'stdc++.6.0.9', 'c++', 'z.1.2.5', 'iconv.2.4.0', 'sqlite3.0'

    s.subspec 'LibBaiduASR' do |bdasr|
        bdasr.name = 'LibBaiduASR'
        bdasr.frameworks = 'AudioToolbox', 'AVFoundation', 'SystemConfiguration', 'CFNetwork', 'CoreLocation', 'CoreTelephony', 'GLKit'
        bdasr.libraries = 'stdc++.6.0.9', 'c++', 'z.1.2.5', 'iconv.2.4.0', 'sqlite3.0'
        bdasr.ios.vendored_libraries = 'SHWRealTimeNLSSDK/Libraries/libBaiduASRSDK.a'
        bdasr.source_files = "SHWRealTimeNLSSDK/Libraries/BDASRHeaders/**/*"
    end

    s.subspec 'LibBaiduTTS' do |bdtts|
        bdtts.name = 'LibBaiduTTS'
        bdtts.frameworks = 'AudioToolbox', 'AVFoundation', 'SystemConfiguration', 'CFNetwork', 'CoreLocation', 'CoreTelephony', 'GLKit'
        bdtts.libraries = 'stdc++.6.0.9', 'c++', 'z.1.2.5', 'iconv.2.4.0', 'sqlite3.0'
        bdtts.ios.vendored_libraries = 'SHWRealTimeNLSSDK/Libraries/libBaiduTTSSDK.a'
        bdtts.source_files = "SHWRealTimeNLSSDK/Libraries/BDTTSHeaders/*.h"
    end
end
