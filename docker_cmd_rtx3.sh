img="nvcr.io/nvidia/pytorch:24.05-py3"

docker run --gpus all --privileged=true --workdir /git --name "graphr1" -e DISPLAY --ipc=host -d --rm -p 6332:8889 \
  -v /home/ggzhang/agent/Graph-R1:/git/Graph-R1 \
  -v /raid/git/datasets:/git/datasets \
  $img sleep infinity

docker exec -it graphr1 /bin/bash

# docker images | grep "pytorch" | grep "21."
# docker stop graphr1
