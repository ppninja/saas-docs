## Job

我们用Job来指代一次PPT转H5请求

### 创建一个Job

```
POST /jobs   (alias. /job/create)
Content-Type: 'multipart/form-data'
```

#### 参数
参数名|类型|必须包含？|描述
---|---|---|---|---
file_md5|string|是|源PPT文件的md5值
file_source|File|是|file binaries

**file_source 应该在计算授权验证签名时过滤掉. 见[这里](../signature.md#授权签名算法).**

#### 响应
{% response header='200 OK' %}
{
  'token': 'hhNy1Eq6Py2Kjpyt'
}
{% endresponse %}

Token是Job的识别参数，客户端需要保存Token。之后关于Job的状态和下载等请求都会使用这个参数。

### 获得Job状态

```
GET /job/[:token]   (alias. /job/status?token='token')
```
#### 参数
参数名|类型|描述
---|---|---
token|string|Job标识

#### 响应
{% response header='200 OK' %}
{
  'state': 'completed'
}
{% endresponse %}

对于state的取值，详细的解释见[这里](#job-状态).

### 下载Job转化完毕后的H5文件

```
GET /job/[:token]/download   (alias. /job/download?token='token')
```
#### 参数
同[获得Job状态](#获得job状态).

#### 响应
{% response header='200 OK' %}
Content-Type: 'application/zip'
Content-Disposition: attachment; filename="TOKEN.zip"
Content-Transfer-Encoding: binary
{% endresponse %}

当响应为200时，客户端可以通过response.body取得压缩包。

__错误响应__
{% response header='422 Unprocessable Entity' %}
{
  "message": "Not available",
  “errors”: [
    {
      "resource": "Job",
      "field": "token",
      "code": "missing"
    }
  ]
}
{% endresponse %}
该错误只能反映客户端不能从服务器下载生成的H5文件，并不能用来排查具体失败的原因。

### 查询Jobs

获得上传的所有Jobs

```
GET /jobs   (alias. /job/list)

{
  'status': 'completed',
  'start_date': '2017-03-16T02:20:39+00:00'
}
```
#### 参数
参数名|类型|是否必须？|描述
---|---|---|---
status|string|可选|PPT状态, 可填写的值见[这里](#job-状态)
start_date|Timestamp|可选|查询起始时间戳
end_date|Timestamp|可选|查询终止时间戳

#### 响应
{% response header='200 OK' %}
{
  "count": 1,
  "tokens": [
    'fZoYvkua34zqYny8'
  ]
}
{% endresponse %}

### Job 状态
state|描述
---|---
converting, rendering, disting| 服务器转化状态
notifying|PP匠服务器正在通知客户服务器 (此时可以通过download接口下载生成好的H5文件)
completed|转化完成
deleted|所有资源已被移除(此时无法再通过download下载生成后的H5)
halted|出错状态
