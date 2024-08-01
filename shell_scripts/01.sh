#!/bin/bash

# スクリプト実行時に渡される引数 (ex. pick_place_demo_session)
session_dir=$1

# 現在のパスを取得
current_dir=$(pwd)

# ベースディレクトリの定義
base_dir="${current_dir}/${session_dir}/demos/*"

docker_image="chicheng/openicc:latest"
mount_target="/data"

# ディレクトリ内の各サブディレクトリに対して処理を実行
for video_dir in ${base_dir}; do
    echo "Processing directory: ${video_dir}"

    # ディレクトリの内容を表示
    ls -l ${video_dir}

    echo "Input video path: ${mount_target}/raw_video.mp4"
    echo "Output file will be: ${mount_target}/imu_data.json"

    # Docker 実行コマンド
    docker run --rm --volume ${video_dir}:${mount_target} ${docker_image} node /OpenImuCameraCalibrator/javascript/extract_metadata_single.js ${mount_target}/raw_video.mp4 ${mount_target}/imu_data.json
done

# echo "Input video path: ${mount_target}/raw_video.mp4"
# echo "Output file will be: ${mount_target}/imu_data.json"
# echo "Video directory: ${video_dir}"
# ls -l ${video_dir}


# # Docker 実行コマンド
# docker run --rm --volume ${video_dir}:${mount_target} ${docker_image} node /OpenImuCameraCalibrator/javascript/extract_metadata_single.js ${mount_target}/raw_video.mp4 ${mount_target}/imu_data.json