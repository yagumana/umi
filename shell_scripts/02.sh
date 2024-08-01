#!/bin/bash

# パスの定義
input_dir=$1
map_path=$2
docker_image="chicheng/orb_slam3:latest"
no_docker_pull=$3
no_mask=$4

# 絶対パスに変換
video_dir=$(readlink $input_dir)
map_path=$(readlink $map_path)

# Dockerイメージのプル
if [ "$no_docker_pull" != "true" ]; then
    echo "Pulling docker image $docker_image"
    docker pull $docker_image
    if [ $? -ne 0 ]; then
        echo "Docker pull failed!"
        exit 1
    fi
fi

# マウントポイントの設定
mount_target="/data"
csv_path="${mount_target}/mapping_camera_trajectory.csv"
video_path="${mount_target}/raw_video.mp4"
json_path="${mount_target}/imu_data.json"
mask_path="${mount_target}/slam_mask.png"

# マスクの作成
if [ "$no_mask" != "true" ]; then
    mask_write_path="${video_dir}/slam_mask.png"
    python3 /path/to/create_mask.py $mask_write_path
fi

# Dockerコマンドの実行
docker run --rm \
    --volume "${video_dir}:${mount_target}" \
    --volume "$(dirname $map_path):$(dirname /map/$(basename $map_path))" \
    $docker_image \
    /ORB_SLAM3/Examples/Monocular-Inertial/gopro_slam \
    --vocabulary /ORB_SLAM3/Vocabulary/ORBvoc.txt \
    --setting /ORB_SLAM3/Examples/Monocular-Inertial/gopro10_maxlens_fisheye_setting_v1_720.yaml \
    --input_video $video_path \
    --input_imu_json $json_path \
    --output_trajectory_csv $csv_path \
    --save_map /map/$(basename $map_path) \
    ${no_mask:+"--mask_img $mask_path"}
