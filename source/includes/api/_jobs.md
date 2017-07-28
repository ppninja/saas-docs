# Jobs

我们使用**Job**来指代一次PPT转H5请求。

## Job的生命周期

一个Job可能经历以下状态变化。

![Job状态机](images/jobs_state_machine.png)

- `uploading`，`converting`，`disting`：表示服务器正在执行转换
- `notifying`：正在通知客户服务器，此时可通过API下载生成的H5文件
- `completed`：转换并通知完成，此时可通过API下载生成的H5文件
- `deleted`：所有资源已被移除，此时**无法**通过API下载生成的H5文件
- `halted`：转换过程出现错误，已终止

<aside class="notice">
有关 <strong>通知客户服务器</strong> 部分请查看后续章节。
</aside>

## 获取所有Job

```shell
curl -i -H "X-PPJ-Credential: ppj_is_great" \
     'https://ppj.io/api/jobs?start_date=2017-07-31'
```

> 以上命令将返回如下格式的数据：

```http
Status: 200 OK
Content-Type: application/json
```

```json
{
  "count": 1,
  "tokens": [
    "fZoYvkua34zqYny8"
  ]
}
```

`GET https://ppj.io/api/jobs`

### 参数表

 参数 | 类型 | 说明
--------- | ------- | -----------
start_date | DateTime | 「可选」晚于该时间（含）创建的Job
end_date | DateTime | 「可选」早于该时间（不含）创建的Job

<aside class="notice">
以上参数中的 <code>DateTime</code> 类型请使用<code>ISO 8601</code>格式的字符串表示，如<code>2017-07-30T02:20:39+08:00</code>。如果服务端无法成功将字符串转换成时间，则该参数将忽略。
</aside>

### 响应

返回满足条件的所有Job。

- `count`：满足条件的Job的数量；
- `tokens`：满足条件的Job的标识组成的数组。

## 创建Job

```shell
curl -i -H "X-PPJ-Credential: ppj_is_great" https://ppj.io/api/jobs -XPOST \
     -F 'file_source=@demo.pptx' \
     -F 'file_md5=5951595bace948c6fd5e0f415b16a16e'
```

> 请根据实际情况替换以上所有参数。

> 以上命令将返回如下格式的数据：

```http
Status: 200 OK
Content-Type: application/json
```

```json
{
  "token": "kuSzcH5AwaDY",
  "name": "demo",
  "state": "completed",
  "source_filename": "demo.pptx",
  "source_filesize": 1826642,
  "total_pages": 14,
  "last_error": null,
  "created_at": "2017-07-24T08:36:03.872Z",
  "created_at_in_ts": 1500885363
}
```

> 如果出现业务逻辑上的错误：

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

`POST https://ppj.io/api/jobs`

### 参数表

 参数 | 类型 | 说明
--------- | ------- | -----------
file_source | File | 文件流
file_md5 | String | 「可选」源文件的MD5值，提供该值时将校验文件完整性

<aside class="notice">
请以 <code>multipart/form-data</code> 对请求参数进行编码。
</aside>

### 响应

如果创建成功，返回该Job的信息，各字段说明如下：

- `token`：标识，用于后续的查询；
- `name`：名称；
- `state`：状态，见「Job的生命周期」；
- `source_filename`：源文件名；
- `source_filesize`：源文件大小，单位为字节；
- `total_pages`：源文件总页数；
- `last_error`：转换过程中的错误原因；
- `created_at`：创建时间，`ISO 8601`格式；
- `created_at_in_ts`：创建时间，精确到秒的Unix时间戳。

如果上传文件的MD5与参数中提供的MD5不符，或者其他业务逻辑上的错误，返回`400 Bad Request`。

## 查询特定 Job

```shell
curl -i -H "X-PPJ-Credential: ppj_is_great" https://ppj.io/api/jobs/kuSzcH5AwaDY
```

> 请将`kuSzcH5AwaDY`替换为具体的Job标识。

> 以上命令将返回如下格式的数据：

```http
Status: 200 OK
Content-Type: application/json
```

```json
{
  "token": "kuSzcH5AwaDY",
  "name": "demo",
  "state": "completed",
  "source_filename": "demo.pptx",
  "source_filesize": 1826642,
  "total_pages": 14,
  "last_error": null,
  "created_at": "2017-07-24T08:36:03.872Z",
  "created_at_in_ts": 1500885363
}
```

> 如果Token对应的Job不存在：

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

`GET https://ppj.io/api/jobs/{token}`

### 参数表

参数 | 类型 | 说明
--------- | ------- | -----------
token | String | Job 标识

### 响应

如果`Token`对应的Job存在，则返回与「创建Job」相同的对象；否则返回`404 Not Found`。

## 下载转换完毕后的H5文件

```shell
curl -H "X-PPJ-Credential: ppj_is_great"
     https://ppj.io/api/jobs/kuSzcH5AwaDY/download
     -o archive.zip
```

> 请将`kuSzcH5AwaDY`替换为具体的Job标识。

> 如果Job可供下载，返回二进制流：

```http
Status: 200 OK
Content-Type: 'application/zip'
Content-Disposition: attachment; filename="kuSzcH5AwaDY.zip"
Content-Transfer-Encoding: binary

{binary data}
```

> 如果Job没有转换完成：

```http
Status: 400 Bad Request
Content-Type: application/json
```

```json
{
  "message": "项目还没有转换完成。",
  "type": "Error"
}
```

`GET https://ppj.io/api/jobs/{token}/download`

### 参数表

 参数 | 类型 | 说明
--------- | ------- | -----------
token | String | Job 标识

### 响应

如果Job已经转换完成可供下载（`notifying`或`completed`状态），则返回`zip`格式的二进制流；否则返回`400 Bad Request`。

如果`Token`对应的Job不存在，返回`404 Not Found`。
