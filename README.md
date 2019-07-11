# Instabug-Task

## Run Services
- `docker-compose up` for developmet use over port 3000
- `docker-compose -f compose-prod.yaml up` for production use over port 80

## Endpoints

### Create Application
#### Request
```
POST /applications
{
  name: "test"
}
```
#### Response
```
{
    "id": 1,
    "name": "test",
    "token": "vVRJqzBVnSHMaZZnjNvYFYOMpXsyBhNGEyBwJBbohyQnwlSViM",
    "chats_count": 0,
    "created_at": "2019-07-11T01:41:19.000Z",
    "updated_at": "2019-07-11T01:41:19.000Z"
}
```

### Create Chat
#### Request
```
POST /applications/{token}/chats
```
#### Response
```
{
    "chat_num": 1
}
```

### Create Message
#### Request
```
POST /applications/{token}/chats/{chat_num}/messages
{
	"text": "boomboom"
}
```
#### Response
```
{
    "message_num": 1
}
```

### Search Messages
#### Request
```
GET /applications/{token}/chats/{chat_num}/messages/search?q={text}
```
#### Response
```
[
    {
        "_index": "messages",
        "_type": "_doc",
        "_id": "1",
        "_score": 0.2876821,
        "_source": {
            "id": 1,
            "text": "boomboom",
            "created_at": "2019-07-11T01:41:46.000Z",
            "updated_at": "2019-07-11T01:41:46.000Z"
        }
    }
]
```

