先注释掉`docker-compose.yml` 文件中的这段代码
```

        volumes:
           - "./data:/var/www/html"
```
# 先执行docker-compose up -d 启动
然后使用 `docker ps` 查看 容器的id
然后将里面的文件复制出来
`docker cp f88f2fd59eea:/var/www/html  data/`
然后`docker-compose down`删除容器

然后修改`docker-compose` 文件, 去除
```

        volumes:
           - "./data:/var/www/html"
```
这段的注释, 然后重新启动
