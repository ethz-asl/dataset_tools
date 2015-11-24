#!/usr/bin/env python
print "importing libraries"

import datasets_common as dc

import argparse
import csv
import cv
import cv2
import os
import sys
import yaml

print

#setup the argument list
parser = argparse.ArgumentParser(
         description='Extract a ROS bag containing a image and imu topics.')
parser.add_argument('--bag', metavar='bag', help='ROS bag file')
parser.add_argument('--image-topics',  metavar='image_topics', nargs='+',
                    help='Image topics %(default)s')
parser.add_argument('--imu-topics',  metavar='imu_topics', nargs='+',
                    help='Imu topics %(default)s')
parser.add_argument('--output-folder',  metavar='output_folder', nargs='?',
                    default="output", help='Output folder %(default)s')
parser.add_argument('--create-yaml',  metavar='create_yaml', nargs='?',
                    default="empty",
                    help='create yaml files with default entries')

#print help if no argument is specified
if len(sys.argv)<2:
    parser.print_help()
    sys.exit(0)

#parse the args
parsed = parser.parse_args()

# check if default yamls should be created
if parsed.create_yaml != 'empty':
    create_yaml = True
else:
    create_yaml = False

if parsed.image_topics is None and parsed.imu_topics is None:
    print "ERROR: Need at least one camera or IMU topic."
    sys.exit(-1)

#create output folder
try:
    os.makedirs(parsed.output_folder)
except:
    pass

#prepare progess bar
iProgress = dc.Progress(1)
    
#extract images
if parsed.image_topics is not None:
    for cidx, topic in enumerate(parsed.image_topics):
        dataset = dc.BagImageDatasetReader(parsed.bag, topic)
        os.makedirs("{0}/cam{1}".format(parsed.output_folder, cidx))
        os.makedirs("{0}/cam{1}/data".format(parsed.output_folder, cidx))

        #create default yaml file for this topic
        print "Creating default sensor yaml file for topic {0} ...".format(dataset.topic)
        filenameYaml = "{0}/cam{1}/sensor.yaml".format(parsed.output_folder, cidx)
        fYaml = file(filenameYaml, 'w')
        data = dict(
            sensor_type = 'camera',
            p_BS_B = [ 0.0, 0.0, 0.0 ],
            q_SB = [ 1.0, 0.0, 0.0, 0.0 ],
            p_WR_W = [ 0.0, 0.0, 0.0 ],
            q_RW = [ 1.0, 0.0, 0.0, 0.0 ],
            camera_model = 'pinhole',
            intrinsics = [461.629, 460.152, 362.680, 246.049],
            distortion_model = 'radial-tangential',
            distortion_coefficients = [-0.27695497, 0.06712482, 0.00087538,
                                       0.00011556],
            resolution = [752, 480]
        )
        fYaml.write('#Default camera sensor yaml file\n\n')
        fYaml.write(yaml.dump(data))
        fYaml.close();
        print "      done.\n"

        #progress bar
        numImages = dataset.numImages()
        print "Extracting {0} images from topic {1}".format(numImages, dataset.topic)
        iProgress.reset(numImages)
        iProgress.sample()

        filename = "{0}/cam{1}/data.csv".format(parsed.output_folder, cidx)
        with open(filename, 'wb') as camfile:
            spamwriter = csv.writer(camfile, delimiter=',')
            spamwriter.writerow(["timestamp [ns]", "filename [string]"])

            for timestamp, image in dataset:
                params = list()
                params.append(cv.CV_IMWRITE_PNG_COMPRESSION)
                params.append(0) #0: loss-less  
                filenameFrame = "{0}{1:09d}.png".format(timestamp.secs, timestamp.nsecs)
                cv2.imwrite("{0}/cam{1}/data/{2}".format(parsed.output_folder, cidx, filenameFrame),
                            image, params)

                timestamp_int = int(timestamp.toSec()*1e9)
                spamwriter.writerow([timestamp_int, filenameFrame])

                iProgress.sample()

    print "      done.\n"
print

#extract imu data
if parsed.imu_topics is not None:
    for iidx, topic in enumerate(parsed.imu_topics):
        dataset = dc.BagImuDatasetReader(parsed.bag, topic)
        os.makedirs("{0}/imu{1}".format(parsed.output_folder, iidx))  

        #create default yaml file for this topic
        print "Creating default agent yaml file for topic {0} ...".format(dataset.topic)
        filenameYaml = "{0}/imu{1}/sensor.yaml".format(parsed.output_folder, iidx)
        fYaml = file(filenameYaml, 'w')
        data = dict(
          sensor_type = 'imu',
          p_BS_B = [ 0.0, 0.0, 0.0 ],
          q_SB = [ 1.0, 0.0, 0.0, 0.0 ],
          p_WR_W = [ 0.0, 0.0, 0.0 ],
          q_RW = [ 1.0, 0.0, 0.0, 0.0 ]
        )
        fYaml.write('#Default imu sensor yaml file\n\n')
        fYaml.write(yaml.dump(data))
        fYaml.close();
        print "      done.\n"

        #progress bar
        numMsg = dataset.numMessages()
        print "Extracting {0} IMU messages from topic {1}".format(numMsg, dataset.topic)
        iProgress.reset(numMsg)
        iProgress.sample()

        filename = "{0}/imu{1}/data.csv".format(parsed.output_folder, iidx)
        with open(filename, 'wb') as imufile:
            spamwriter = csv.writer(imufile, delimiter=',')
            spamwriter.writerow(["timestamp [ns]", "g_x [rad s^-1]", "g_y [rad s^-1]", "g_z [rad s^-1]",
                               "a_x [m s^-2]", "a_y [m s^-2]", "a_z [m s^-2]"])

            for timestamp, omega, alpha in dataset:
                timestamp_int = int(timestamp.toSec()*1e9)
                spamwriter.writerow([timestamp_int, omega[0], omega[1], omega[2],
                                 alpha[0], alpha[1], alpha[2] ])
                iProgress.sample()
            print "      done.\n"

