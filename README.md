# mjpg-stream on Raspberry Pi 

在這裡找到解答：https://github.com/OctoPrint/octoprint-docker/issues/47
此專案中已經執行了論壇的步驟，先根據一樓的作法，再根據二樓的建議做修正，增加環境變數。
最後，在專案內增加 `docker-compose.yml` 一鍵完成容器的運行！

## 可以在樹莓派上運行的版本
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
然後建置 image 

```sh
docker build -t mjpeg-pi .
```
並直接運行容器
```sh
docker run -it --device /dev/video0 -e "ENV_FPS=5" -e "ENV_RESOLUTION=1280x720" -p 8080:8080  mjpeg-pi "output_http.so -w ./www", "input_uvc.so"
```

## 包含有環境變數的版本

原本，想執行 mjpeg 串流應該是這樣的指令：

```sh
sudo mjpg_streamer -i "input_uvc.so -r 1280x720 -d /dev/video0 -f 30" -o "output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www"
```
如果按照前面的章節，想要修改一些環境變數，必須把整行完整的指令 `-d, -r` 這些都寫在 `docker run <command>` 裡面傳入。

若是能把這些輸入參數寫在 `docker-compose.yml`，直接以環境變數的方式傳入不是方便很多？這需要按照上方論壇的二樓的建議，修改 docker-start.sh 檔案。

本專案已經修改好，現在 `docker-compose.yml` 變成如下：


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
