## 概览

### 当前版本

当前 API 版本为 PPJ SaaS API 接口 v1版。所有 API 请求请通过设置 `Accept` header 来标记该版本。

`Accept: application/vnd.ppj.v1+json`

### API 请求根目录

`http://ppj.io/`

### 通用规范

未经特别说明，所有 API 以 `Content-Type: 'application/json'` 响应请求。

时间 (DateTime) 的格式为 ISO 8601 标准；在某些特殊说明的请求中，使用标准时间戳 (Unix Timestamp) 来表示。

DateTime (ISO 8601): `YYYY-MM-DDTHH:MM:SSZ // e.g. 2017-03-16T02:20:39+00:00`

Unix Timestamp: `10-digits // e.g. 1489804788 (2017-03-18T10:39:48+08:00) `


### 客户端请求报错

响应客户端请求出错会包含一个 4XX 的错误码，和对应的 json 格式返回值来说明：

{% response header='400 Bad Request' %}
{
  "message": "Problems parsing JSON",
  "type": "ParserError"
}
{% endresponse %}

"message" 和 "type" 可以帮助客户端理解错误，在任何 4XX 类型错误中总是存在的。

常见 type 值点击[错误码](errors.md)。


### HTTP Verbs

API 设计符合 RESTful 规范，意味着不同的 HTTP Verb 会有不同的含义。

Verb|描述
---|---
GET	| 用来获取资源信息
POST| 用来新建资源
PUT, PATCH| 用来更新资源对象，如更新名称等
DELETE|	表示删除某项资源

对于发送 http 请求时，设置 Verb 有困难的客户端，可以通过在请求的参数列表增加 `_method=[Verb.]` 来取代。

{% command %}
curl http://ppj.io/whatever?_method=GET
{% endcommand %}

### 授权验证

PPJ API v1 支持两种验证请求的方式。 若验证失败统一回复：
{% response header='403 Forbidden' %}
{
  "message": "Authentication Error",
  "type": "AuthenticationError"
}
{% endresponse %}

#### 参数表
参数名|类型|描述
---|---|---
Credential|String|PPJ AppID, 通过开发者后台获取
Timestamp|Unix Timestamp| 计算签名时的时间戳
Signature|String|验证用签名, 点击查看[签名算法](./signature.md)

#### 方法

1. 通过设置 http 请求的 headers
{% command %}
curl -H 'X-PPJ-Credential: YOUR-APPID' \
     -H 'X-PPJ-Timestamp: XXXXXXXXXXX' \
     -H 'X-PPJ-Signature: AUTH-TOKEN' \
     http://ppj.io/whatever
{% endcommand %}

2. 通过设置 http 请求的参数
{% command %}curl 'http://ppj.io/whatever?_credential=XXXX&_timestamp=XXXXXX&_signature=XXXXXX'
{% endcommand %}

__注意：__ 所有以“\_”开头的参数，如 \_method，\_credential，\_timestamp和 \_signature，本身是不参与计算签名的；示例见[签名算法示例](./signature.md#示例)。

### Credits

This API is inspired mostly by [Github.com](https://developers.github.com) and [Amazon.com](https://aws.amazon.com/api-gateway/).
