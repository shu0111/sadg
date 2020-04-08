
GSON 库的导入在之前的实训中已经完成。

{
    "HeWeather": [
        {
            "basic": {},
            "update": {},
            "status": "ok",
            "now": {},
            "daily_forecast": [],
            "aqi": {},
            "suggestion": {},
        }
    ]
}

_____________________________________

Basic 类
basic 中的具体内容为：

"basic": {
            "cid": "CN101210101",
            "location": "杭州",
            "parent_city": "杭州",
            "admin_area": "浙江",
            "cnty": "中国",
            "lat": "39.90498734",
            "lon": "116.4052887",
            "tz": "+8.00",
            "city": "杭州",
            "id": "CN101210101",
            "update": {
                "loc": "2020-03-09 17:32",
                "utc": "2020-03-09 09:32"
            }
}

__________________________________________________

代码如下：

public class Basic {
    @SerializedName("city")
    public String cityName;     // 城市名
    @SerializedName("id")
    public String weatherId;    // 天气编号
    public Update update;   // 更新状态类
    public class Update{
        @SerializedName("loc")
        public String updateTime;   // 更新时间
    }
}

___________________________________________

AQI 类
aqi 中的具体内容如下：

"aqi": {
        "city": {
            "aqi": "59",
            "pm25": "31",
            "qlty": "良"
        }
}
_____________________________________
选用其中的 aqi（空气质量指数）和 pm25（ PM2.5 的浓度）。在 gson 包下新建 AQI 类，代码如下：

public class AQI {
    public AQICity city;    // 城市
    public class AQICity{
        public String aqi;  // 空气质量指数
        public String pm25; // pm2.5浓度
    }
}
____________________________________
Now 类
now 中的具体内容如下：

"now": {
        "cloud": "91",
        "cond_code": "101",
        "cond_txt": "多云",
        "fl": "8",
        "hum": "22",
        "pcpn": "0.0",
        "pres": "1014",
        "tmp": "12",
        "vis": "21",
        "wind_deg": "234",
        "wind_dir": "西南风",
        "wind_sc": "3",
        "wind_spd": "16",
        "cond": {
            "code": "101",
            "txt": "多云"
        }
}

______________________________
选用其中的 tmp（温度）和 cond 中的 txt（天气）。在 gson 包下新建 AQI 类，代码如下：

public class Now {
    @SerializedName("tmp")
    public String temperature;  // 当前温度
    @SerializedName("cond")
    public More more;   // 更多信息
    public class More{
        @SerializedName("txt")
        public String info; // 天气信息
    }
}
________________________________________
Suggestion 类
suggestion 中的具体内容如下：

"suggestion": {
            "comf": {
                "type": "comf",
                "brf": "较舒适",
                "txt": "白天会有降雨，这种天气条件下，人们会感到有些凉意，但大部分人完全可以接受。"
            },
            "sport": {
                "type": "sport",
                "brf": "较不宜",
                "txt": "有降水，且风力较强，推荐您在室内进行各种健身休闲运动；若坚持户外运动，请注意防风保暖。"
            },
            "cw": {
                "type": "cw",
                "brf": "不宜",
                "txt": "不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。"
            }
}
________________________________________

选用其中 comf 的 txt（舒适程度建议）、sport 的 txt（运动建议）和 cw 的 txt（洗车建议）。在 gson 包下新建 Suggestion 类，代码如下：

public class Suggestion {
    @SerializedName("comf")
    public Comfort comfort; // 舒适度
    @SerializedName("cw")
    public CarWash carWash; // 洗车建议
    public Sport sport; // 运动建议
    public class Comfort{
        @SerializedName("txt")
        public String info;
    }
    public class CarWash{
        @SerializedName("txt")
        public String info;
    }
    public class Sport{
        @SerializedName("txt")
        public String info;
    }
}
________________________________
Forcast 类
daily_forecast 比较特殊，其中包含的是一个数组，数组中的每一项都代表着未来一天的天气信息。对于这种情况，我们只需要定义出单日天气的实体类，然后在声明实体类引用的时候使用集合类型声明即可。

daily_forecast 中的具体内容如下：

"daily_forecast": [
                {
                    "date": "2020-03-10",
                    "cond": {
                        "txt_d": "小雨"
                    },
                    "tmp": {
                        "max": "13",
                        "min": "4"
                    }
                },
                ...
]
其中的 date（日期）、 cond（天气状况）和 tmp（气温）都要用到。在 gson 包下新建 Forecast 类，代码如下：

public class Forecast {
    public String date; // 预报日期
    @SerializedName("tmp")
    public Temperature temperature; // 预报气温
    @SerializedName("cond")
    public More more;   // 更多信息
    public class Temperature{
        public String max;  //最高温
        public String min;  // 最低温
    }
    public class More{
        @SerializedName("txt_d")
        public String info; // 预测的天气信息
    }
}
Weather 类
上面已经把 basic 、aqi 、now 、suggestion 和 daliy_forecast 对应的实体类全部创建好了，接下来还需要再创建一个总的实例类来引用刚刚创建的各个实体类。在 gson 包下新建一个 Weather 类，代码如下：

public class Weather {
    // 引用其他类
    public String status;   // status数据，成功返回ok
    public Basic basic;
    public AQI aqi;
    public Now now;
    public Suggestion suggestion;
    @SerializedName("daily_forecast")
    public List<Forecast> forecastList;
}
在以上代码中，我们对 Basic 、AQI 、Now 、Suggestion 和 Forecast 类进行了引用。其中，由于 daily_forecast 中包含的是一个数组，因此这里使用了 List 集合来引用 Forecast 类。另外，返回的天气数据中还会包含一项 status 数据，成功返回 ok ，失败会返回具体的原因，这里也做了引用。

到此所有的 GSON 实体类已经创建完毕，完整的 gson 包中文件如下图所示：



图2 完整的 gson 包目录


——————————————————————————————————————————————————————————
任务二

activity_weather.xml文件中，以使得布局文件比较工整。

创建头布局
在 Android 模式下右击 res/layout 文件夹 → New → Layout resource file，命名为 title.xml，其他保持默认。代码如下：

<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent" 
    android:layout_height="?attr/actionBarSize">
    <!-- 居中显示城市名 -->
    <TextView
        android:id="@+id/title_city"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_centerInParent="true"
        android:textColor="#fff"
        android:textSize="20sp" />
    <!-- 居右显示更新时间 -->
    <TextView
        android:id="@+id/title_update_time"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_alignParentRight="true"
        android:layout_centerVertical="true"
        android:layout_margin="10dp"
        android:textSize="16sp"
        android:textColor="#fff" />
</RelativeLayout>

——————————————————————————————————————————————————————
创建天气信息布局
依然是在 layout 文件夹下新建布局文件，命名为 now.xml，代码如下：

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="15dp">
    <!-- 显示气温 -->
    <TextView
        android:id="@+id/degree_text"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="end"
        android:textColor="#fff"
        android:textSize="60sp" />
    <!-- 显示天气概况 -->
    <TextView
        android:id="@+id/weather_info_text"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="end"
        android:textColor="#fff"
        android:textSize="20sp"/>
</LinearLayout>
以上代码设定了天气信息布局，放置了两个 TextView ，一个用来显示当前气温，另一个用来显示天气概况。
_______________________________________________________________________
创建天气预报布局
在 layout 文件夹新建 forecast.xml 作为未来几天天气信息的布局，代码如下：

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical" android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="15dp"
    android:background="#8000"><!-- 定义半透明的背景 -->
    <!-- 定义标题 -->
    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginLeft="15dp"
        android:layout_marginTop="15dp"
        android:text="预报"
        android:textColor="#fff"
        android:textSize="20sp"/>
    <!-- 定义显示未来几天天气预报的布局 -->
    <LinearLayout
        android:id="@+id/forecast_layout"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"/>
</LinearLayout>
这里最外层使用 LinearLayout 定义了一个半透明的背景，然后使用 TextView 定义了一个标题，接着又使用一个 LinearLayout 用于显示未来几天天气信息的布局。不过这个布局中并没有放入任何内容，因为这是根据服务器返回的数据在代码中动态添加的。

为此，我们还需要再定义一个未来天气信息的子项布局。
_______________________________________________________________________

创建未来天气子项布局
新建 forecast_item.xml 文件，代码如下：

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="15dp">
    <!-- 显示天气预报日期 -->
    <TextView
        android:id="@+id/date_text"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_gravity="center_vertical"
        android:layout_weight="2"
        android:textColor="#fff" />
    <!-- 显示天气预报概况 -->
    <TextView
        android:id="@+id/info_text"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_gravity="center_vertical"
        android:layout_weight="1"
        android:gravity="center"
        android:textColor="#fff" />
    <!-- 显示最高温 -->
    <TextView
        android:id="@+id/max_text"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_gravity="center_vertical"
        android:layout_weight="1"
        android:gravity="right"
        android:textColor="#fff" />
    <!-- 显示最低温 -->
    <TextView
        android:id="@+id/min_text"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_gravity="center"
        android:layout_weight="1"
        android:gravity="right"
        android:textColor="#fff" />
</LinearLayout>
以上子项布局中放置了 44 个 TextView ，一个用来显示天气预报日期，一个用于显示天气概况，另外两个分别用于显示当天的最高温度和最低温度。
_______________________________________________________________________

创建空气质量信息布局
新建 aqi.xml 作为空气质量信息的布局，代码如下所示：

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical" android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="15dp"
    android:background="#8000"><!-- 定义半透明背景 -->
    <!-- 定义标题 -->
    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginLeft="15dp"
        android:layout_marginTop="15dp"
        android:text="空气质量"
        android:textColor="#fff"
        android:textSize="20sp"/>
    <!-- 嵌套实现左右平分且集中对其的布局 -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_margin="15dp">
        <!-- 显示AQI指数 -->
        <LinearLayout
            android:orientation="vertical"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1">
            <TextView
                android:id="@+id/aqi_text"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="center"
                android:textColor="#fff"
                android:textSize="40sp" />
            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="center"
                android:text="AQI 指数"
                android:textColor="#fff" />
        </LinearLayout>
        <!-- 显示PM2.5指数 -->
        <LinearLayout
            android:orientation="vertical"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1">
            <TextView
                android:id="@+id/pm25_text"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="center"
                android:textColor="#fff"
                android:textSize="40sp" />
            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="center"
                android:text="PM2.5 指数"
                android:textColor="#fff" />
        </LinearLayout>
    </LinearLayout>
</LinearLayout>
这个布局中的代码看上去虽然有点长，但是并不复杂。前面也是用 LinearLayout 定义了一个半透明的背景，然后使用 TextView 定义了一个标题。接下来，使用 LinearLayout 嵌套的方式实现了一个左右平分且居中对齐的布局，分别用于显示 AQI 指数和 PM2.5 指数。
_______________________________________________________________________


创建生活建议信息布局
新建 suggestion.xml 作为生活建议信息布局，代码如下：

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:layout_margin="15dp"
    android:background="#8000">
    <!-- 显示标题 -->
    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginLeft="15dp"
        android:layout_marginTop="15dp"
        android:text="生活建议"
        android:textColor="#fff"
        android:textSize="20sp"/>
    <!-- 显示舒适度 -->
    <TextView
        android:id="@+id/comfort_text"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_margin="15dp"
        android:textColor="#fff" />
    <!-- 显示洗车建议 -->
    <TextView
        android:id="@+id/car_wash_text"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_margin="15dp"
        android:textColor="#fff" />
    <!-- 显示运动建议 -->
    <TextView
        android:id="@+id/sport_text"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_margin="15dp"
        android:textColor="#fff" />
</LinearLayout>
这里同样也是先定义了一个半透明的背景和一个标题，然后使用 33 个TextView 分别用于显示舒适度、洗车建议和运动建议的相关内容。
_______________________________________________________________________


引入布局文件
到此已经完成了天气界面上每个部分的布局文件，接下来需要将它们引入到 activity_weather.xml 中，代码如下：

<FrameLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/colorPrimary">
    <!-- 通过滚动方式查看屏幕以外内容 -->
    <ScrollView
        android:id="@+id/weather_layout"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:scrollbars="none"
        android:overScrollMode="never">
        <!-- 引入之前定义的所有布局 -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical">
            <include layout="@layout/title"/>
            <include layout="@layout/now"/>
            <include layout="@layout/forecast"/>
            <include layout="@layout/aqi"/>
            <include layout="@layout/suggestion"/>
        </LinearLayout>
    </ScrollView>
</FrameLayout>
_______________________________________________________________________

任务三

解析JSON数据
首先在 Utility 类中添加一个用于解析天气 JSON 数据的方法，如下所示：

public class Utility {
    ...
    /**
     * 将返回的JSON数据解析成Weather实体类
     */
    public static Weather handleWeatherResponse(String response){
        try{
            JSONObject jsonObject = new JSONObject(response);
            JSONArray jsonArray = jsonObject.getJSONArray("HeWeather");
            String weatherContent = jsonArray.getJSONObject(0).toString();
            return new Gson().fromJson(weatherContent, Weather.class);  // 将JSON数据解析成Weather对象
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}
以上代码提供了handleWeatherResponse()方法，该方法先通过 JSONObject 和 JSONArray 将天气数据中的主体内容解析出来，即：

{
    "basic": {},
    "update": {},
    "status": "ok",
    "now": {},
    "daily_forecast": [],
    "aqi": {},
    "suggestion": {},
}
之前我们已经按照上面的数据格式定义过相应的 GSON 实体类，所以这里只需要调用fromJson()方法就能直接将 JSON 数据转换成 Weather 对象了。

在活动中将数据显示到界面
接下来要完成的工作是在活动中请求天气数据，并将数据展示到界面上。

修改 WeatherActivity 中的代码：

public class WeatherActivity extends AppCompatActivity {
    private ScrollView weatherLayout;
    private TextView titleCity;
    private TextView titleUpdateTime;
    private TextView degreeText;
    private TextView weatherInfoText;
    private LinearLayout forecastLayout;
    private TextView aqiText;
    private TextView pm25Text;
    private TextView comfortText;
    private TextView carWashText;
    private TextView sportText;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_weather);
        //初始化各组件
        weatherLayout = findViewById(R.id.weather_layout);
        titleCity = findViewById(R.id.title_city);
        titleUpdateTime = findViewById(R.id.title_update_time);
        degreeText = findViewById(R.id.degree_text);
        weatherInfoText = findViewById(R.id.weather_info_text);
        forecastLayout = findViewById(R.id.forecast_layout);
        aqiText = findViewById(R.id.aqi_text);
        pm25Text = findViewById(R.id.pm25_text);
        comfortText = findViewById(R.id.comfort_text);
        carWashText = findViewById(R.id.car_wash_text);
        sportText = findViewById(R.id.sport_text);
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        String weatherString = prefs.getString("weather",null);
        if(weatherString != null){
            //有缓存时直接解析天气数据
            Weather weather = Utility.handleWeatherResponse(weatherString);
            showWeatherInfo(weather);
        }else{
            //无缓存时去服务器查询数据
            String weatherId = getIntent().getStringExtra("weather_id");
            weatherLayout.setVisibility(View.INVISIBLE);    // 暂时将ScrollView设为不可见
            requestWeather(weatherId);
        }
    }
    /**
     * 根据天气Id请求城市天气信息
     */
    public void requestWeather(final String weatherId){
        String weatherUrl = "http://guolin.tech/api/weather?cityid=" + weatherId
                + "&key=6ebfd087db8144cbaab3884bb8f4b19d"; // 这里的key设置为第一个实训中获取到的API Key
        // 组装地址并发出请求
        HttpUtil.sendOkHttpRequest(weatherUrl, new Callback() {
            @Override
            public void onResponse(@NotNull Call call, @NotNull Response response) throws IOException {
                final String responseText = response.body().string();
                final  Weather weather = Utility.handleWeatherResponse(responseText);   // 将返回数据转换为Weather对象
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if(weather!=null && "ok".equals(weather.status)){
                            //缓存有效的weather对象(实际上缓存的是字符串)
                            SharedPreferences.Editor editor = PreferenceManager
                                    .getDefaultSharedPreferences(WeatherActivity.this).edit();
                            editor.putString("weather",responseText);
                            editor.apply();
                            showWeatherInfo(weather);   // 显示内容
                        }else{
                            Toast.makeText(WeatherActivity.this, "获取天气信息失败", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
            @Override
            public void onFailure(@NotNull Call call, @NotNull IOException e) {
                e.printStackTrace();
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(WeatherActivity.this, "获取天气信息失败", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }
    /**
     * 处理并展示Weather实体类中的数据
     * @param weather
     */
    private void showWeatherInfo(Weather weather){
        // 从Weather对象中获取数据
        String cityName = weather.basic.cityName;
        String updateTime = weather.basic.update.updateTime.split(" ")[1]; //按24小时计时的时间
        String degree = weather.now.temperature + "°C";
        String weatherInfo = weather.now.more.info;
        // 将数据显示到对应控件上
        titleCity.setText(cityName);
        titleUpdateTime.setText(updateTime);
        degreeText.setText(degree);
        weatherInfoText.setText(weatherInfo);
        forecastLayout.removeAllViews();
        for(Forecast forecast:weather.forecastList){    // 循环处理每天的天气信息
            View view = LayoutInflater.from(this).inflate(R.layout.forecast_item,forecastLayout,false);
            // 加载布局
            TextView dateText = view.findViewById(R.id.date_text);
            TextView infoText = view.findViewById(R.id.info_text);
            TextView maxText = view.findViewById(R.id.max_text);
            TextView minText = view.findViewById(R.id.min_text);
            // 设置数据
            dateText.setText(forecast.date);
            infoText.setText(forecast.more.info);
            maxText.setText(forecast.temperature.max);
            minText.setText(forecast.temperature.min);
            // 添加到父布局
            forecastLayout.addView(view);
        }
        if(weather.aqi != null){
            aqiText.setText(weather.aqi.city.aqi);
            pm25Text.setText(weather.aqi.city.pm25);
        }
        String comfort = "舒适度: " + weather.suggestion.comfort.info;
        String carWash = "洗车指数: " + weather.suggestion.carWash.info;
        String sport = "运动建议: "+ weather.suggestion.sport.info;
        comfortText.setText(comfort);
        carWashText.setText(carWash);
        sportText.setText(sport);
        weatherLayout.setVisibility(View.VISIBLE);  // 将天气信息设置为可见
    }
}
这个活动中的代码比较长，但是逻辑相对比较清晰。首先在OnCreate()方法中获取一些控件的实例，然后尝试从本地缓存中读取天气数据。如果本地没有缓存就从 Intent 中取出天气 id ，并调用requestWeather()方法来从服务器请求天气数据。如果缓存中有数据则直接解析并显示天气数据。

注意：请求数据的时候先将 ScrollView 隐藏，否则空数据的界面看上去会非常奇怪。

requestWeather()方法中先是使用了参数中传入的天气 id 和之前申请的 API Key 进行组装，拼出一个接口地址，接着调用 HttpUtil.sendOkHttpRequest()方法来向该地址发出请求，服务器会将相应城市的天气信息以 JSON 格式返回。然后我们在onResponse()回调中先调用 Utility.handleWeatherResponse()方法将返回的 JSON 数据转换成 Weather 对象，再将当前线程切换到主线程。然后进行判断，如果服务器返回的 status 是 ok ，就说明请求是成功的，此时将返回的数据存到 SharedPreferences 中，并调用showWeatherInfo()方法来进行内容显示。

showWeatherInfo()方法中的逻辑比较简单，就是从 Weather 对象中获取数据，然后显示到相应的控件上。

注意：在未来几天天气预报的部分我们使用了一个 for 循环来处理每天的天气信息，在循环中动态加载 forecast.xml 布局并设置相应的数据，然后添加到父布局中。设置完所有的数据之后，要记得将 ScrollView 重新设置为可见。

从省市县列表跳转到天气界面
实现这样的跳转，需要修改 ChooseAreaFragment 中的代码，如下所示：

public class ChooseAreaFragment extends Fragment {
    ...
    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        // 设置 ListView 和 Button 的点击事件
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (currentLevel == LEVEL_PROVINCE) {
                    selectedProvince = provinceList.get(position);
                    queryCities();
                } else if (currentLevel == LEVEL_CITY) {
                    selectedCity = cityList.get(position);
                    queryCounties();
                }else if(currentLevel==LEVEL_COUNTY){
                    String weatherId = countyList.get(position).getWeatherId();
                    Intent intent = new Intent(getActivity(), WeatherActivity.class);
                    intent.putExtra("weather_id",weatherId);    // 向intent传入WeatherId
                    startActivity(intent);
                    getActivity().finish();
                }
            }
        });
        ...
    }
    ...
}
非常简单，以上代码在onItemClick()方法中加入了一个 if 判断，如果当前级别是 LEVEL_COUNTY ，就启动 WeatherActivity ，并把当前选中的县的 id 传递过去。

加入缓存数据的判断
在应用刚启动时，需要判断是否有缓存数据，进而决定进入哪个页面。修改 MainActivity 中的代码，如下所示：

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        // 从 SharedPreferences 中读取缓存数据
        if(prefs.getString("weather",null)!=null){
            // 之前请求过则直接跳转到天气信息
            Intent intent = new Intent(this, WeatherActivity.class);
            startActivity(intent);
            finish();
        }
    }
}
