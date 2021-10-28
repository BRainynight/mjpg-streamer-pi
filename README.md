# mjpg-stream on Raspberry Pi 

在這裡找到解答：https://github.com/OctoPrint/octoprint-docker/issues/47。

此專案中已經執行了論壇的步驟，完整的步驟將放在後面。並且在專案內增加 `docker-compose.yml` 一鑑完成容器的運行！

下載專案後，執行指令

```sh
docker build -t mjpeg-pi .
```

並直接運行容器進行測試

```sh
docker run -it --device /dev/video0 -e "ENV_FPS=5" -e "ENV_RESOLUTION=1280x720" -p 8080:8080  mjpeg-pi "output_http.so -w ./www", "input_uvc.so"
```

`docker-compose.yml` 中則可以這樣測試，原本應該是這樣的指令：

```sh
sudo mjpg_streamer -i "input_uvc.so -r 1280x720 -d /dev/video0 -f 30" -o "output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www"
```

現在變成：

```yml
version: '3'
services:
    mjpg-cam1:
        restart: always
        image: mjpeg-pi 
        environment:
            - ENV_RESOLUTION=1280x720
            - ENV_FPS=30
            - ENV_LOCATION=./www #/usr/local/share/mjpg-streamer/www
            - ENV_CAMERA=/dev/video0
        devices:
            - /dev/video0
        ports:
            - 8080:8080
```

現在，就可以在資料夾`mjpg-streamer-experimental` 中使用指令直接執行串流！

```sh
docker-compose up 
```




## 完整的步驟
先下載並進入 `mjpg-streamer-experimental` 資料夾：

```sh
git clone https://github.com/jacksonliam/mjpg-streamer
cd mjpg-streamer/mjpg-streamer-experimental
```

進去修改裡面的 `dockerfile`

```dockerfile
FROM ubuntu:18.04

RUN apt-get update && apt-get install git cmake make build-essential libjpeg-dev imagemagick subversion libv4l-dev checkinstall lib\
jpeg8-dev libv4l-0 gcc g++ -y

RUN git clone https://github.com/jacksonliam/mjpg-streamer.git

WORKDIR /mjpg-streamer/mjpg-streamer-experimental

COPY . .
RUN make USE_LIBV4L2=true clean all
RUN make install
RUN cat docker-start.sh
RUN chmod +x docker-start.sh
EXPOSE 8080/TCP
ENTRYPOINT ["/mjpg-streamer/mjpg-streamer-experimental/docker-start.sh"]
CMD ["output_http.so -w ./www", "input_uvc.so"]
```

後面就執行 docker build （連接到上面的步驟）
