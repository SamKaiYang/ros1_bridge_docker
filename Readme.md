# 這個映像檔內包含
1. Ubuntu 20.04
2. ROS 1 noetic
3. ROS 2 foxy

# Now create a script to run the image called run_my_image.bash

```

xhost +local:docker 

sudo docker run -it \
    --user=root \
    --net=host \
    --rm --ipc=host \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --privileged \
    -e LANG=C.UTF-8 \
    --volume=/dev:/dev \
    ubuntu20_test:v1 \
    /bin/bash
```
# Make the script executable
```
chmod a+x run_my_image.bash
```
# Execute the script
```
sudo ./run_my_image.bash
```
# If you want to add multiple terminals, you can enter the following commands in the new terminal
```
sudo docker exec -it --user root <CONTAINER ID> /bin/bash
```
