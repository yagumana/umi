# create_mask.py
import numpy as np
import cv2
from .cv_util import draw_predefined_mask
import sys

def create_mask(output_path):
    slam_mask = np.zeros((2028, 2704), dtype=np.uint8)
    slam_mask = draw_predefined_mask(slam_mask, color=255, mirror=True, gripper=False, finger=True)
    cv2.imwrite(output_path, slam_mask)

if __name__ == "__main__":
    output_path = sys.argv[1]
    create_mask(output_path)
