
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

