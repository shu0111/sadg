首先修改 activity_weather.xml 中的代码，如下所示：

<FrameLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/colorPrimary">
    <!-- 显示背景图片 -->
    <ImageView
        android:id="@+id/bing_pic_img"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:scaleType="centerCrop" />
    <!-- 通过滚动方式查看屏幕以外内容 -->
    <ScrollView
        android:id="@+id/weather_layout"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:scrollbars="none"
        android:overScrollMode="never">
        ...
    </ScrollView>
</FrameLayout>
以上代码在 FrameLayout 中添加了一个 ImageView ，并将其宽和高都设置成 match_parent 。因为 FrameLayout 默认情况下会将控件放置在左上角，所以 ScrollView 会完全覆盖住 ImageView ，从而使其成为背景图片。

修改活动代码
布局文件修改完成后，接下来需要修改活动中的控制逻辑，首先是 WeatherActivity ，代码如下：

public class WeatherActivity extends AppCompatActivity {
    ...
    private ImageView bingPicImg;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_weather);
        //初始化各组件
        bingPicImg = findViewById(R.id.bing_pic_img);
        ...
        String bingPic = prefs.getString("bing_pic",null);  // 尝试从缓存中读取
        if(bingPic != null){
            Glide.with(this).load(bingPic).into(bingPicImg);
        }else{
            loadBingPic();  // 没有读取到则加载
        }
    }
    /**
     * 根据天气Id请求城市天气信息
     */
    public void requestWeather(final String weatherId){
        ...
        loadBingPic();
    }
    ...
    /**
     * 加载必应每日一图
     */
    private void loadBingPic(){
        String requestBingPic = "http://guolin.tech/api/bing_pic";
        HttpUtil.sendOkHttpRequest(requestBingPic, new Callback() {
            @Override
            public void onResponse(@NotNull Call call, @NotNull Response response) throws IOException {
                final String bingPic = response.body().string();    // 获取背景图链接
                SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(WeatherActivity.this).edit();
                editor.putString("bing_pic",bingPic);
                editor.apply(); // 将北京图链接存到 SharedPreferences 中
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Glide.with(WeatherActivity.this).load(bingPic).into(bingPicImg);    // 用 Glide 加载图片
                    }
                });
            }
            @Override
            public void onFailure(@NotNull Call call, @NotNull IOException e) {
                e.printStackTrace();
            }
        });
    }
}
以上代码首先在 onCreate() 方法中获取新增控件 ImageView 的实例，然后尝试用 SharedPreferences 中读取缓存的背景图片。如果有缓存的话就直接用 Glide 来加载这张图片，如果没有的话就调用 loadBingPic() 方法去请求今日的必应背景图。

loadBingPic()方法中的逻辑比较简单，先调用HttpUtil.sendOkHttpRequest()方法获取必应背景图的链接，然后将这一链接存储到 SharedPreferences 中，再将当前线程切换到主线程，最后使用 Glide 库来加载这张图片就可以了。

另外需要注意在requestWeather()方法的最后也要调用一下loadBingPic()方法，这样在每次请求天气信息的时候同时也会刷新背景图片。

这时重新运行一下程序，就可以看到在天气界面显示了背景图：



图1 添加背景图后的界面
融合背景图与状态栏
上一步骤中已经成功添加了背景图，但是可以看到状态栏的样式并没有改变，这在一定程度上会影响用户的使用体验。接下来我们尝试将背景图与状态栏融合到一起。

修改 WeatherActivity 中的代码，如下所示：

public class WeatherActivity extends AppCompatActivity {
    ...
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(Build.VERSION.SDK_INT >= 21){
            View decorView = getWindow().getDecorView();    // 获取DecorView
            decorView.setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            |View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            );  // 改变系统UI
            getWindow().setStatusBarColor(Color.TRANSPARENT);   // 设置透明
        }
        setContentView(R.layout.activity_weather);
        ...
    }
    ...
}
这一功能在 Android 5.0 版本之后才支持，所以先判断系统版本号，只有当版本号大于或等于 2121（也就是 5.0 ），才会执行后面的代码。

接着获取当前活动的 DecorView ，并调用它的setSystemUiVisibility()方法来改变系统 UI 的显示，这里传入 View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN 和 View.SYSTEM_UI_FLAG_LAYOUT_STABLE 参数，表示活动布局会显示在状态栏上面。最后调用一下setStatusBarColor()方法将状态栏设置成透明色。

此时运行程序，可以看到如下效果：



图2 融合状态栏后的界面
会发现背景图和状态来已经成功融合，但是又出现了新的问题：天气界面的头布局几乎和系统状态栏贴到了一起。这是由于系统状态栏已经成为天气布局的一部分，没有为其单独留出空间。

解决这一问题的方法非常简单，只需要在 activity_weather.xml 文件中设置一下 android:fistSystemWindows 属性即可，代码如下：

<FrameLayout
    ...>
    ...
    <ScrollView
    ...>
        <!-- 引入之前定义的所有布局 -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical"
            android:fitsSystemWindows="true">
            ...
        </LinearLayout>
    </ScrollView>
</FrameLayout>
这里在 ScrollView 中的 LinearLayout 中增加了android:fistSystemWindows属性，设置为 true 就表示会为系统状态栏留出空间。重新运行程序，可以看到如下效果：
