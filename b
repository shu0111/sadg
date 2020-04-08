
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




