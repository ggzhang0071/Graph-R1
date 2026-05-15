#!/bin/bash
# Graph-R1 Docker Launch Script for RTX 5080 (sm_120)
# Requires: Docker with nvidia-container-toolkit

# 使用支持 RTX 5080 的 NGC 镜像 (PyTorch 2.6.0 + CUDA 12.8)
img="nvcr.io/nvidia/pytorch:25.02-py3"

CONTAINER_NAME="graphr1"
HOST_PROJECT_DIR="/home/ggzhang/agent/Graph-R1"
HOST_DATASET_DIR="/raid/git/datasets"

echo "=== Starting Graph-R1 Container ==="
echo "Image: $img"
echo "Project: $HOST_PROJECT_DIR"
echo "Dataset: $HOST_DATASET_DIR"

# 停止并移除已存在的同名容器
docker stop $CONTAINER_NAME >/dev/null 2>&1
docker rm $CONTAINER_NAME >/dev/null 2>&1

# 启动容器
docker run --gpus all \
  --privileged=true \
  --workdir /git/Graph-R1 \
  --name "$CONTAINER_NAME" \
  -e DISPLAY \
  --ipc=host \
  -d \
  --rm \
  -p 6332:8889 \
  -v "$HOST_PROJECT_DIR:/git/Graph-R1" \
  -v "$HOST_DATASET_DIR:/git/datasets" \
  $img \
  sleep infinity

if [ $? -ne 0 ]; then
  echo "ERROR: Failed to start container"
  exit 1
fi

echo "Container started successfully!"
echo ""
echo "=== Next Steps ==="
echo "1. Enter container:  docker exec -it $CONTAINER_NAME /bin/bash"
echo "2. Install deps:     pip install -e . && pip install -r requirements.txt"
echo "3. Prepare data:     python script_process.py --data_source 2WikiMultiHopQA"
echo "4. Run training:     bash run_grpo.sh -p <model_path> -m <model_name> -d 2WikiMultiHopQA"
echo ""
echo "Or auto-setup with: docker exec -it $CONTAINER_NAME bash -c 'cd /git/Graph-R1 && bash setup_env.sh'"
