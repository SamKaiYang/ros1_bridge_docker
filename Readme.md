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

# TEST ros1_bridge
## 安裝ros1_bridge
```
mkdir -p ~/colcon_ws/src
cd ~/colcon_ws/src
git clone https://github.com/ros2/ros1_bridge
# 暫時不能加載ros1 工作空間, 編譯
colcon build --symlink-install --packages-skip ros1_bridge
# 加載ros1工作空間
. /opt/ros/noetic/setup.bash
# 加載ros2工作空間
. /ros2_foxy/ros2-linux/setup.bash
# 最後再編譯ros1_bridge
colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure
```
## 測試ros1_bridge
### 啟動ros1 roscore
```
# Shell A (ROS 1 only):
. /opt/ros/noetic/setup.bash
roscore
```
### 啟動bridge
```
# Shell B (ROS 1 + ROS 2):
cd ~/colcon_ws/src
. /opt/ros/noetic/setup.bash
. /ros2_foxy/ros2-linux/setup.bash
export ROS_MASTER_URI=http://localhost:11311
source ./install/setup.bash
ros2 run ros1_bridge dynamic_bridge
```
### ros1下發布talker話題
```
# Shell C:
. /opt/ros/noetic/setup.bash
rosrun rospy_tutorials talker
```
### ros2下訂閱話題
```
# Shell D:
. /ros2_foxy/ros2-linux/setup.bash
ros2 run demo_nodes_cpp listener
```
