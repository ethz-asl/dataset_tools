#!/usr/bin/env python

import kalibr_common as kc
import cv
import cv2
import csv
import os
import sys
import argparse

def extractData(topics,sensor_name):
    
    sensor = {"imu" : kc.BagImuDatasetReader, 
              "image" : kc.BagImageDatasetReader, 
              "leica" : kc.BagLeicaDatasetReader, 
              "vicon" : kc.BagViconDatasetReader}
    
    if topics is not None:
        for iidx, topic in enumerate(topics):
            output_folder = "{0}/{1}{2}".format(parsed.output_folder, sensor_name, iidx)
            dataset = sensor[sensor_name](parsed.bag, topic, output_folder)
            
            dataset.writeToCSV()

#setup the argument list
parser = argparse.ArgumentParser(description='Extract a ROS bag containing a image and imu topics.')
parser.add_argument('--bag', metavar='bag', help='ROS bag file')
parser.add_argument('--image-topics',  metavar='image_topics', nargs='+', help='Image topics %(default)s')
parser.add_argument('--imu-topics',  metavar='imu_topics', nargs='+', help='Imu topics %(default)s')
parser.add_argument('--leica-topics',  metavar='leica_topics', nargs='+', help='Leica topics %(default)s')
parser.add_argument('--vicon-topics',  metavar='vicon_topics', nargs='+', help='Vicon topics %(default)s')
parser.add_argument('--output-folder',  metavar='output_folder', nargs='?', default="output", help='Output folder %(default)s')

#print help if no argument is specified
if len(sys.argv)<2:
    parser.print_help()
    sys.exit(0)

#parse the args
parsed = parser.parse_args()

if parsed.image_topics is None and parsed.imu_topics and parsed.leica_topics and parsed.vicon_topics is None:
    print "ERROR: Need at least one camera, IMU, leica or vicon topic."
    sys.exit(-1)

#create output folder
try:
  os.makedirs(parsed.output_folder)
except:
  pass

#extract data
extractData(parsed.imu_topics,"imu")
extractData(parsed.image_topics,"image")
extractData(parsed.leica_topics,"leica")
extractData(parsed.vicon_topics,"vicon")