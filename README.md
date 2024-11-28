# MPL ROS Wrapper

This project containerizes the MPL ROS package for planning trajectories. Trajectories are calculated using search-based planner for a quadrotor flying in an obstacle-cluttered environment. MPL uses the result of lower dimensional search of the environment as heuristic for hierarchical planning. 

Credits: Heavily reliant on Motion Primitive Library developed by [sikang](https://github.com/sikang)

Paper: [Search-based Motion Planning for Aggressive Flight in SE(3)](https://arxiv.org/pdf/1710.02748)

## Setup Instructions

### Prerequisites

- Docker installed on your system
- Windows X server for display forwarding on Windows OS (I used VcXsrv)

### Clone the Repository

```
git clone --recursive https://github.com/adithom/mpl_ros_project.git
```
### Build Docker Image
```
docker build -t mpl_ros_image .
```

