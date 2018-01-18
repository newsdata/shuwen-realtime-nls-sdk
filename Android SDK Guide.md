<!-- TITLE: Android Docs -->
<!-- SUBTITLE: A quick summary of Android Docs -->

# 智能会话+智能会话 SDK Android 开发文档
##  在Manifest中添加权限

```
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_SETTINGS" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
```
		
## 添加 maven 仓库地址    

```gradle

maven {
   url 'http://repo.baichuan-android.taobao.com/content/groups/BaichuanRepositories/'
}

maven {  
   url 'http://116.62.222.54/repository/maven-releases/'  
   credentials {  
      username <username>
      password <password>
   }  
}
``` 


## 引入依赖  

```
compile 'com.shuwen.chatrobot:chatrobot-sdk:1.0.9'  
// 推荐使用AndPermission动态申请权限
compile 'com.yanzhenjie:permission:1.1.2'
```

## 在 Application 中初始化

* 需要百度语音服务（ http://yuyin.baidu.com/ ）的 AppId，AppKey，SecretKey 
* 需要数闻接口服务（ http://fenfa.shuwen.com/ ）的 AppKey，SecretKey   
 

```java
public class MyApp extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        IChatRobot.Factory.init(this, "<appid>", "<appkey>", "<secretkey>", "<news_appkey>", "<news_secretkey>");
    }
}
```



## 接口调用方式

```java

//问答接口
chatRobot.ask(<question>, <latitude>, <longitude>, new Callback<JsonObject>() {
                    @Override
                    public void onResponse(Call<JsonObject> call, Response<JsonObject> response) {
                       
                    }

                    @Override
                    public void onFailure(Call<JsonObject> call, Throwable t) {
                        
                    }
                });
								
//上传本地录音文件接口
chatRobot.uploadLocalAudioFileForRecognize(<filePath>, new UploadCallback() {
                    @Override
                    public void onSuccess(String taskId) {
                       
                    }

                    @Override
                    public void onFailure(String message) {
                        
                    }

                    @Override
                    public void onLoading(long currentSize, long totalSize) {
                       
                    }
                });
								
//获取转译结果接口
chatRobot.fetchRecoginzeResult(<mTaskId>, new TranslateCallback() {
                    @Override
                    public void onSuccess(String result) {
                       
                    }

                    @Override
                    public void onTranslating(String status) {
                        
                    }

                    @Override
                    public void onFailure(String message) {
                       
                    }
                });
								
								
 //文本转语音								
 ttsClient.ttsSpeak(text);	
 //暂停
 ttsClient.ttsPause();
 //恢复
 ttsClient.ttsResume();
 //停止
 ttsClient.ttsStop();
 //释放tts资源
 ttsClient.releaseTts();
 
 //开始语音识别
 asrClient.asrStart();
 //取消语音识别
 asrClient.asrCancel();
 //停止语音识别
 asrClient.asrStop();
 //释放asr资源
 asrClient.releaseAsr();
 
```

## 回调接口说明

```text

//asr回调
public interface IRecogListener {

    /**
     * ASR_START 输入事件调用后，引擎准备完毕
     */
    void onAsrReady();

    /**
     * onAsrReady后检查到用户开始说话
     */
    void onAsrBegin();

    /**
     * 检查到用户开始说话停止，或者ASR_STOP 输入事件调用后，
     */
    void onAsrEnd();

    /**
     * onAsrBegin 后 随着用户的说话，返回的临时结果
     *
     * @param results     可能返回多个结果，请取第一个结果
     * @param recogResult 完整的结果
     */
    void onAsrPartialResult(String[] results, RecogResult recogResult);

    /**
     * 最终的识别结果
     *
     * @param results     可能返回多个结果，请取第一个结果
     * @param recogResult 完整的结果
     */
    void onAsrFinalResult(String[] results, RecogResult recogResult);

    /**
     * 识别一段话结束。如果是长语音的情况会继续识别下段话
     *
     * @param recogResult 完整的结果
     */
    void onAsrFinish(RecogResult recogResult);

   /**
     * 识别错误
     */
    void onAsrFinishError(int errorCode, int subErrorCode, String errorMessage, String descMessage, RecogResult recogResult);

    /**
     * 长语音识别结束
     */
    void onAsrLongFinish();

   /**
     * 音量大小回调
     */
    void onAsrVolume(int volumePercent, int volume);


    /**
     * 识别引擎结束并空闲中
     */
    void onAsrExit();

}


//tts回调
public interface ITtsListener {

    void onSpeechStart(String s);

    void onSpeechFinish(String s);

    void onError(String s, SpeechError speechError);
}


//上传的录音转译结果回调
public interface TranslateCallback {

   //转译成功
    void onSuccess(String result);

   //转译状态
    void onTranslating(String status);

   //转译失败
    void onFailure(String message);
}

//上传本地录音文件回调
public interface UploadCallback {

    //文件上传成功后后端返回的转译taskId,根据此taskId来获取最终转译结果
    void onSuccess(String taskId);

   //失败原因
    void onFailure(String message);

    //上传进度
    void onLoading(long currentSize, long totalSize);
}

```

## 自定义配置
### TTS
| PARAM_SPEAKER | String, 默认“0” | 普通女声 |
| --- | --- | --- |
|  | “1” | 普通男声 |
|  | “2” | 特别男声 |
|  | “3” | 情感男声<度逍遥> |
|  | “4” | 情感儿童声<度丫丫> |
| PARAM_VOLUME | String, 默认”5” | 在线及离线合成的音量 。范围[“0” - “9”], 不支持小数。 “0” 最轻，”9” 最响。 |
| PARAM_SPEED | String, 默认”5” | 在线及离线合成的语速 。范围[“0” - “9”], 不支持小数。 “0” 最慢，”9” 最快 |
| PARAM_PITCH | String, 默认”5” | 在线及离线合成的语调 。范围[“0” - “9”], 不支持小数。 “0” 最低沉， “9” 最尖 |
|  |  |  |
|  |  |  |

### ASR
| ACCEPT_AUDIO_VOLUME | boolean | 是否需要语音音量数据回调，开启后有CALLBACK_EVENT_ASR_VOLUME事件回调 |
| --- | --- | --- |


## Demo示例


```text
public class MainActivity extends AppCompatActivity implements View.OnClickListener, PermissionListener {

    @BindView(R.id.asr_result)
    TextView asr_result;

    private IChatRobot chatRobot;
    private TtsClient ttsClient;
    private AsrClient asrClient;

    private String TAG = "ASR_TEST";
    private String filePath;
    private String mTaskId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);

        AndPermission.with(this)
                .requestCode(100)
                .permission(Permission.MICROPHONE, Permission.STORAGE)
                .callback(this)
                .start();
    }

    @OnClick({R.id.ask, R.id.speak, R.id.pause, R.id.resume, R.id.stop, R.id.asrStart, R.id.asrCancel, R.id.asrStop, R.id.test, R.id.uploadAudioFile, R.id.fetchAsrResult})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.test:
                startActivity(new Intent(MainActivity.this, TestActivity.class));
                break;
            case R.id.ask:
                chatRobot.ask("xxx是谁", 0.0, 0.0, new Callback<JsonObject>() {
                    @Override
                    public void onResponse(Call<JsonObject> call, Response<JsonObject> response) {
                        Toast.makeText(MainActivity.this, "onResponse", Toast.LENGTH_SHORT).show();
                    }

                    @Override
                    public void onFailure(Call<JsonObject> call, Throwable t) {
                        Toast.makeText(MainActivity.this, "onFailure", Toast.LENGTH_SHORT).show();
                    }
                });
                break;

            case R.id.uploadAudioFile:
                chatRobot.uploadLocalAudioFileForRecognize(filePath, new UploadCallback() {
                    @Override
                    public void onSuccess(String taskId) {
                        mTaskId = taskId;
                        Toast.makeText(MainActivity.this, "onSuccess: " + taskId, Toast.LENGTH_SHORT).show();
                        Log.i(TAG, "onSuccess: " + taskId);
                    }

                    @Override
                    public void onFailure(String message) {
                        Toast.makeText(MainActivity.this, "onFailure", Toast.LENGTH_SHORT).show();
                        Log.i(TAG, "onFailure: " + message);
                    }

                    @Override
                    public void onLoading(long currentSize, long totalSize) {
                        Log.i(TAG, "onLoading: " + "currentSize: " + currentSize + "totalSize: " + totalSize);
                    }
                });
                break;
            case R.id.fetchAsrResult:
                chatRobot.fetchRecoginzeResult(mTaskId, new TranslateCallback() {
                    @Override
                    public void onSuccess(String result) {
                        Toast.makeText(MainActivity.this, "onSuccess: " + result, Toast.LENGTH_SHORT).show();
                    }

                    @Override
                    public void onTranslating(String status) {
                        Toast.makeText(MainActivity.this, "onTranslating: " + status, Toast.LENGTH_SHORT).show();
                        Log.i(TAG, "onTranslating: " + status);
                    }

                    @Override
                    public void onFailure(String message) {
                        Toast.makeText(MainActivity.this, "onFailure: " + message, Toast.LENGTH_SHORT).show();
                    }
                });
                break;
            case R.id.speak:
                String text = "今天天气不错，心情挺好的";
                ttsClient.ttsSpeak(text);
                break;
            case R.id.pause:
                ttsClient.ttsPause();
                break;
            case R.id.resume:
                ttsClient.ttsResume();
                break;
            case R.id.stop:
                ttsClient.ttsStop();
                break;
            case R.id.asrStart:
                asrClient.asrStart();
                break;
            case R.id.asrCancel:
                asrClient.asrCancel();
                break;
            case R.id.asrStop:
                asrClient.asrStop();
                break;
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (ttsClient != null) {
            ttsClient.releaseTts();
        }

        if (asrClient != null) {
            asrClient.releaseAsr();
        }
    }

    private void initChatRobot() {

        TtsAdapterListener ttsAdapterListener = new TtsAdapterListener(new ITtsListener() {
            @Override
            public void onSpeechStart(String s) {

            }

            @Override
            public void onSpeechFinish(String s) {

            }

            @Override
            public void onError(String s, SpeechError speechError) {

            }
        });


        RecogAdapterListener asrListener = new RecogAdapterListener(new IRecogListener() {
            @Override
            public void onAsrReady() {
                Log.i(TAG, "onAsrReady");
            }

            @Override
            public void onAsrBegin() {
                Log.i(TAG, "onAsrBegin");
            }

            @Override
            public void onAsrEnd() {
                Log.i(TAG, "onAsrEnd");
            }

            @Override
            public void onAsrPartialResult(String[] results, RecogResult recogResult) {
                String message = "临时识别结果，结果是“" + results[0] + "”；原始json：" + recogResult.getOrigalJson();
                Log.i(TAG, "onAsrPartialResult: " + message);

                String result = results[0] + " ";
                asr_result.setText(result);
            }


            @Override
            public void onAsrFinalResult(String[] results, RecogResult recogResult) {

                String message = "识别结束，结果是“" + results[0] + "”；原始json：" + recogResult.getOrigalJson();
                Log.i(TAG, "onAsrFinalResult: " + message);
            }

            @Override
            public void onAsrFinish(RecogResult recogResult) {
                Log.i(TAG, "onAsrFinish: " + "识别一段话结束。如果是长语音的情况会继续识别下段话");
            }


            @Override
            public void onAsrFinishError(int errorCode, int subErrorCode, String errorMessage, String descMessage, RecogResult recogResult) {
                String message = "识别错误, 错误码：" + errorCode + "," + subErrorCode + "；错误消息:" + errorMessage + "；描述信息：" + descMessage;
                Log.i(TAG, "onAsrFinishError: " + message);
            }

            @Override
            public void onAsrLongFinish() {
                Log.i(TAG, "onAsrLongFinish: " + "长语音识别结束");
            }


            @Override
            public void onAsrVolume(int volumePercent, int volume) {
                Log.i(TAG, "onAsrVolume: " + "volumePercent: " + volumePercent + "volume: " + volume);
            }

            @Override
            public void onAsrExit() {
                Log.i(TAG, "onAsrExit: " + "识别引擎结束并空闲中");
            }

        });

        chatRobot = IChatRobot.Factory.getInstance();
        //TtsConfig ttsConfig = new TtsConfig.Builder().setSpeaker("4").build();
        ttsClient = IChatRobot.Factory.getTtsClent(this, ttsAdapterListener);
        AsrConfig asrConfig = new AsrConfig.Builder().setAcceptAudioVolume(true).build();
        asrClient = IChatRobot.Factory.getAsrClient(this, asrConfig, asrListener);
    }


    @Override
    public void onSucceed(int requestCode, @NonNull List<String> grantPermissions) {

        if (requestCode == 100) {
            initChatRobot();

            File[] files = Environment.getExternalStorageDirectory().listFiles();
            for (File file : files) {
                if (file.getName().contains("测试")) {
                    filePath = file.getAbsolutePath();
                }
            }
        }
    }

    @Override
    public void onFailed(int requestCode, @NonNull List<String> deniedPermissions) {

        if (requestCode == 100) {

        }
    }
}
```

## 代码混淆

```

# chat-robot sdk
-keep class com.shuwen.xhchatrobot.sdk.** {*;}

# Utdid
-keep class com.taobao.** {*;}

# 百度语音
-keep class com.baidu.speech.**{*;}
-keep class com.baidu.tts.**{*;}
-keep class com.baidu.speechsynthesizer.**{*;}

# Retrofit
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
-keepattributes Signature
-keepattributes Exceptions
-dontwarn okio.**
-dontwarn javax.annotation.**


# OkHttp
-dontwarn okio.**
-dontwarn okhttp3.**
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.ParametersAreNonnullByDefault


# Okio
-dontwarn com.squareup.**
-dontwarn okio.**
-keep public class org.codehaus.* { *; }
-keep public class java.nio.* { *; }
````


