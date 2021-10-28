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