---
title: API 文档 - PP匠

language_tabs: # must be one of https://git.io/vQNgJ
  - shell: cURL

toc_footers:
  - <a href='https://ppj.io/apply/company'>申请 API 权限</a>
  - <a href='https://ppj.io/profile/api'>设置开发信息</a>

includes:
  - api/jobs
  - callback

search: true
---

# Introduction || 简介

欢迎使用PP匠SaaS服务API！你可以使用我们的API，将PPT上传到PP匠网站，转化为H5网页，并通过接口下载到本地。

如你在使用过程中遇到问题，请加QQ群（459962155）或微信（GockGe）咨询。

# Request || 请求

## Endpoint ||  根目录

请用HTTPS发起所有请求到以下根目录：

`https://ppj.io/api/`

如果你的API类型为`测试`，请使用以下根目录：

`https://sandbox.ppj.io/api/`

## Authentication || 权限验证

> 你可以使用以下代码验证权限：

```shell
curl -i -H "X-PPJ-Credential: your_access_key" https://ppj.io/api/jobs
```

> 或者添加请求参数：

```shell
curl -i 'https://ppj.io/api/jobs?_credential=your_access_key'
```

> 请将 `your_access_key` 替换为你自己的`Access Key`。

PP匠使用`Access Key`验证所有的API请求，你可以在PP匠网站的[开发信息](https://ppj.io/profile/api)页面查看。

我们要求所有请求增加一个以`X-PPJ-Credential`为键`Access Key`为值的请求头（Request Header），形式如下：

`X-PPJ-Credential: your_access_key`

如果你的网络请求库不方便设置请求头，也可以使用以`_credential`为键`Access Key`为值的请求参数（Query String）的方式，形式如下：

`_credential=your_access_key`

<aside class="notice">
请将 <code>your_access_key</code> 替换为你自己的<code>Access Key</code>。
</aside>

# Response || 响应

- 未经特别说明，所有API以`application/json`格式响应请求；
- 时间戳以`ISO 8601`格式返回，如`2017-03-16T02:20:39+00:00`。通常也会同时返回一个精确到秒的Unix时间戳。

## 200 OK

```http
Status: 200 OK
Content-Type: application/json
```
```json
{
  "token": "token",
  "name": "2017年第二季度财报",
  "state": "completed"
}
```

如果请求正确完成，则以`200`的状态码响应，并返回一个JSON对象，一般格式如右侧所示：

## 400 Bad Request

```http
Status: 400 Bad Request
Content-Type: application/json
```

```json
{
  "message": "上传文件的MD5与参数中提供的MD5不符。",
  "type": "Error"
}
```

如果请求存在逻辑错误，如参数验证不通过等，则以`400`的状态码响应，并返回一个JSON对象用以说明错误原因，一般格式如右侧所示：

## 401 Unauthorized

```http
Status: 401 Unauthorized
Content-Type: application/json
```

```json
{
  "message": "Access Key无效，请查看开发信息页面或文档。",
  "type": "UnauthorizedError"
}
```

如果提供的`Access Key`不正确或者以错误的方式添加请求头，则以`401`的状态码响应，并返回一个JSON对象用以说明错误原因。

## 403 Forbidden

```http
Status: 403 Forbidden
Content-Type: application/json
```

```json
{
  "message": "客户端IP不在白名单中，请在后台设置。",
  "type": "PermissionError"
}
```

如果使用白名单之外的IP发起请求，或者请求的参数签名不正确，则以`403`的状态码响应，并返回一个JSON对象用以说明错误原因。

## 404 Not Found

```http
Status: 404 Not Found
Content-Type: application/json
```

```json
{
  "message": "您所请求的资源不存在。",
  "type": "NotFoundError"
}
```

如果请求的资源不存在，则以`404`的状态码响应，并返回一个JSON对象用以说明错误原因。

## 500 Internal Server Error

```http
Status: 500 Internal Server Error
Content-Type: text/html
```

如果服务器出现异常，则以`500`的状态码响应。

## 503 Service Unavailable

```http
Status: 503 Service Unavailable
Content-Type: text/html
```

如果我们正在更新服务，可能出现短暂的服务不可用的情况，这时会以`503`的状态码响应，请稍后重试。
