## 概览

### 当前版本

当前API版本为PPJ SaaS API 接口 v1版. 所有API请求请通过设置 `Accept` header 来标记该版本.

`Accept: application/vnd.ppj.v1+json`

### API请求根目录

`https://api.ppj.io/`

### 通用规范

未经特别说明，所有API以 `Content-Type: 'application/json'` 响应请求。

时间戳 (Timestamp) 的格式为 ISO 8601 标准；在某些特殊说明的请求中，使用10位数字时间戳 (Unix Timestamp) 来表示。

ISO 8601: `YYYY-MM-DDTHH:MM:SSZ // e.g. 2017-03-16T02:20:39+00:00`

Unix timestamp: `1489804788 // represents timestamp at 2017-03-18T10:39:48+08:00 `


### 客户端请求报错

通常用两种响应方式来标记客户端请求出错：

1. 针对POST请求，若请求包含的JSON无法解析或不是要求的格式
{% response header='400 Bad Request' %}
{
  "message": "Problems parsing JSON"
}
{% endresponse %}

2. 请求的参数有误
{% response header='422 Unprocessable Entity' %}
{
  "message": "Validation Failed",
  “errors”: [
    {
      "resource": "Job",
      "field": "file_md5",
      "code": "missing_field"
    }
  ]
}
{% endresponse %}

所有的error对象都包含'resource', 'field', 'code'来帮助你了解参数哪里有问题。 可能的错误码如下：

错误码名称|描述
---|---
missing|当前请求的资源不存在。
missing_field|该参数缺失，对应field排错。
invalid|该参数格式不对，对应field拍错。

其他错误在响应的时候，会额外带字段‘message’来大致解释出错原因，具体见对应API的响应案例。


### HTTP Verbs

API设计符合RESTful规范，意味着不同的HTTP Verb会有不同的含义。

Verb|Description
---|---
GET	| 用来获取资源信息
POST| 用来新建资源
PUT, PATCH| 用来更新资源对象，如更新名称等
DELETE|	表示删除某项资源

对于发送http请求时，设置Verb.有困难的客户端，可以通过在请求的参数列表增加 `_method=[Verb.]` 来取代。

{% command %}
curl http://api.ppj.io/whatever?_method=GET
{% endcommand %}

### 授权验证

PPJ API v1 支持两种验证请求的方式。 若验证失败统一回复
{% response header='403 Forbidden' %}
{
  "message": "Authentication Error."
}
{% endresponse %}

#### 参数表
name|type|description
---|---|---
Credential|string|PPJ AppID, 通过开发者后台获取
Timestamp|Unix Timestamp| 计算签名时的时间戳
Signature|string|验证用签名, 算法[点击此处](./signature.md)

#### 方法

1. Authentication Token (通过设置http请求的headers)
{% command %}
curl -H 'X-PPJ-Credential: YOUR-APPID' \
     -H 'X-PPJ-Timestamp: XXXXXXXXXXX' \
     -H 'X-PPJ-Signature: AUTH-TOKEN' \
     https://api.ppj.io/whatever
{% endcommand %}

2. Authentication Token (通过设置http请求的参数)
   {% command %}curl 'https://api.ppj.io/whatever?_credential=XXXX&_timestamp=XXXXXX&_signature=XXXXXX'
   {% endcommand %}


### Credits

This API is inspired mostly by [Github.com](https://developers.github.com) and [Amazon.com](https://aws.amazon.com/api-gateway/).
