# MPL ROS Wrapper

This project containerizes the MPL ROS package for planning trajectories calculated using a search-based planner for quadrotors flying in an obstacle-cluttered environments. MPL uses the results of lower dimensional search of the environments as heuristics for hierarchical planning. Melodic port is not currently working.

Credits: Heavily reliant on Motion Primitive Library developed by [Sikang Liu](https://github.com/sikang)

Paper: [Search-based Motion Planning for Aggressive Flight in SE(3)](https://arxiv.org/pdf/1710.02748)

## Setup Instructions

Compiled package is available with this repo if you want to directly use it.

### Prerequisites

- Docker installed on your system
- Windows X server for display forwarding on Windows OS (I used VcXsrv)

### Clone the Repository with submodule

```
git clone --recursive https://github.com/adithom/mpl_ros_container.git
```
### Build Docker Image
```
docker build -t mpl_ros_image .
```

```
docker run -it --rm -e DISPLAY=host.docker.internal:0.0 --add-host=host.docker.internal:host-gateway mpl_ros_image
```


