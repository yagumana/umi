#!/bin/bash

# sessionディレクトリの定義 (ex. pick_place_demo_session)
session_dir=$1
# ベースディレクトリの定義 (ex. /home/robot_dev6/yaguchi/universal_manipulation_interface2/universal_manipulation_interface)
base_dir=$2

# 02: Create map
echo "Running 02_create_map.py..."
python scripts_slam_pipeline/02_create_map.py --input_dir ${session_dir}/demos/mapping --base_dir ${base_dir} --map_path ${session_dir}/demos/mapping/map_atlas.osa
if [ $? -ne 0 ]; then
    echo "Error in 02_create_map.py"
    exit 1
fi

# 03: Batch SLAM
echo "Running 03_batch_slam.py..."
python scripts_slam_pipeline/03_batch_slam.py --input_dir ${session_dir}/demos --base_dir ${base_dir} --map_path ${session_dir}/demos/mapping/map_atlas.osa
if [ $? -ne 0 ]; then
    echo "Error in 03_batch_slam.py"
    exit 1
fi

# 04: Detect Aruco
echo "Running 04_detect_aruco.py..."
python scripts_slam_pipeline/04_detect_aruco.py --input_dir ${session_dir}/demos --camera_intrinsics /workspace/example/calibration/gopro_intrinsics_2_7k.json --aruco_yaml /workspace/example/calibration/aruco_config.yaml
if [ $? -ne 0 ]; then
    echo "Error in 04_detect_aruco.py"
    exit 1
fi

# 05: Run calibrations
echo "Running 05_run_calibrations.py..."
python scripts_slam_pipeline/05_run_calibrations.py ${session_dir}
if [ $? -ne 0 ]; then
    echo "Error in 05_run_calibrations.py"
    exit 1
fi

# 06: Generate dataset plan
echo "Running 06_generate_dataset_plan.py..."
python scripts_slam_pipeline/06_generate_dataset_plan.py --input ${session_dir}
if [ $? -ne 0 ]; then
    echo "Error in 06_generate_dataset_plan.py"
    exit 1
fi

# 07: Generate replay buffer
echo "Running 07_generate_replay_buffer.py..."
python scripts_slam_pipeline/07_generate_replay_buffer.py -o ${session_dir}/dataset.zarr.zip ${session_dir}
if [ $? -ne 0 ]; then
    echo "Error in 07_generate_replay_buffer.py"
    exit 1
fi