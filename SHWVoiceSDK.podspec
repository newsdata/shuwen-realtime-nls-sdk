# 以下 pod 并未发布到 cocoapods 共有源，请参考 README.md 中的使用方法，手动依赖

Pod::Spec.new do |s|
    s.name             = 'SHWVoiceSDK'
    s.version          = '1.0.7'
    s.summary          = '新华智云 SHWVoiceSDK'
    s.description      = 'SHWVoiceSDK 是对百度语音 TTS ASR 静态库的二次封装，并增加了长录音识别'
    s.homepage         = 'https://github.com/newsdata/shuwen-voice-sdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.authors          = { 'yangyang' => 'yangyang@shuwen.com', 'yehao' => 'yehao@shuwen.com' }
    s.ios.deployment_target = '8.0'

    s.source = { :http => 'http://newscdn.oss-cn-hangzhou.aliyuncs.com/ios_pod_sdk/voice_sdk/ShuWen_Voice_1.0.7.zip' }

    s.ios.vendored_frameworks = "SHWVoiceSDK/SHWVoice.framework"
    s.ios.vendored_libraries = 'SHWVoiceSDK/Librarys/libBaiduASR.a', 'SHWVoiceSDK/Librarys/libBaiduTTS.a'
    s.frameworks = 'AudioToolbox', 'AVFoundation', 'SystemConfiguration', 'CFNetwork', 'CoreLocation', 'CoreTelephony', 'GLKit'
    s.libraries = 'stdc++.6.0.9', 'c++', 'z.1.2.5', 'iconv.2.4.0', 'sqlite3.0'

    s.subspec 'LibBaiduASR' do |bdasr|
        bdasr.name = 'LibBaiduASR'
        bdasr.frameworks = 'AudioToolbox', 'AVFoundation', 'SystemConfiguration', 'CFNetwork', 'CoreLocation', 'CoreTelephony', 'GLKit'
        bdasr.libraries = 'stdc++.6.0.9', 'c++', 'z.1.2.5', 'iconv.2.4.0', 'sqlite3.0'
        bdasr.ios.vendored_libraries = 'SHWVoiceSDK/Libraries/libBaiduASRSDK.a'
        bdasr.source_files = "SHWVoiceSDK/Libraries/BDASRHeaders/**/*"
    end

    s.subspec 'LibBaiduTTS' do |bdtts|
        bdtts.name = 'LibBaiduTTS'
        bdtts.frameworks = 'AudioToolbox', 'AVFoundation', 'SystemConfiguration', 'CFNetwork', 'CoreLocation', 'CoreTelephony', 'GLKit'
        bdtts.libraries = 'stdc++.6.0.9', 'c++', 'z.1.2.5', 'iconv.2.4.0', 'sqlite3.0'
        bdtts.ios.vendored_libraries = 'SHWVoiceSDK/Libraries/libBaiduTTSSDK.a'
        bdtts.source_files = "SHWVoiceSDK/Libraries/BDTTSHeaders/*.h"
    end
end
