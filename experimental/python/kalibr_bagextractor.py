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
              "vicon" : kc.BagViconDatasetReader,
              "odom" : kc.BagOdomDatasetReader}
    
    if topics is not None:
        for iidx, topic in enumerate(topics):
            output_folder = "{0}/{1}{2}".format(parsed.output_folder, sensor_name, iidx)
            dataset = sensor[sensor_name](parsed.bag, topic, output_folder)
            
            dataset.writeToCSV()

#setup the argument list
parser = argparse.ArgumentParser(description='Extract a ROS bag containing a image and imu topics.')
parser.add_argument('--bag', metavar='bag', help='ROS bag file')
parser.add_argument('--topics',  metavar='topics', nargs='+', help='topics %(default)s')
parser.add_argument('--output-folder',  metavar='output_folder', nargs='?', default="output", help='Output folder %(default)s')

#print help if no argument is specified
if len(sys.argv)<2:
    parser.print_help()
    sys.exit(0)

#parse the args
parsed = parser.parse_args()

if parsed.topics is None:
    print "ERROR: Need at least one topic."
    sys.exit(-1)

#extract data
for iidx, topic in enumerate(parsed.topics):
    csv_write = kc.CSVWriter(parsed.bag,topic,parsed.output_folder)
    csv_write.write()
    