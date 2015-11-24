import time
import datetime
import sys
import cv
import cv_bridge
import cv2
import rosbag
import os
import numpy as np
import pylab as pl

class Time(object):
    def __init__(self, sec, nsec):
        self.secs = sec
        self.nsecs = nsec
        self.normalize()

    def normalize(self):
        nsec_part = self.nsecs % 1000000000;
        sec_part = self.nsecs / 1000000000;
        self.secs += sec_part;
        self.nsecs = nsec_part;

    def toSec(self):
        return self.secs + self.nsecs / 1e9

    def toNSec(self):
        return self.secs * 1e9 + self.nsecs

class Progress(object):
    def __init__(self, numIterations):
        """
        Progress tracker that calculates and prints the time until a process is finished.
        """
        self.started = False
        self.elapsed = 0
        self.startTime = 0
        self.numIterations = numIterations
        self.iteration = 0

    def sample(self, steps=1):
        """
        Call this function at each iteration. It prints the remaining steps and time.
        """
        if self.started:
            self.iteration = self.iteration + steps
            self.elapsed = time.time() - self.startTime
            timePerRun = self.elapsed / self.iteration
            totalTime = self.numIterations * timePerRun
            
            m, s = divmod(totalTime-self.elapsed, 60)
            h, m = divmod(m, 60)
            t_remaining_str = ""
            if h > 0: t_remaining_str = "%d h " % h
            if m > 0: t_remaining_str = t_remaining_str + "%dm " % m
            if s > 0: t_remaining_str = t_remaining_str + "%ds" % s
            print "\r  Progress {0} / {1} \t Time remaining: {2}                 ".format(self.iteration, self.numIterations, t_remaining_str),
            sys.stdout.flush()
        else:
            self.startTime = time.time()
            self.iteration = 0
            self.started = True
        
    def reset(self, numIterations = -1):
        """
        Reset the progress tracker
        """
        self.started = False
        self.elapsed = 0
        self.startTime = 0
        self.iteration = 0
        if numIterations != -1:
            self.numIterations = numIterations

class BagImageDatasetReaderIterator(object):
    def __init__(self,dataset,indices=None):
        self.dataset = dataset
        if indices is None:
            self.indices = np.arange(dataset.numImages())
        else:
            self.indices = indices
        self.iter = self.indices.__iter__()
    def __iter__(self):
        return self
    def next(self):
        idx = self.iter.next()
        return self.dataset.getImage(idx)

class BagImageDatasetReader(object):
    def __init__(self, bagfile, imagetopic, bag_from_to=None):
        self.bagfile = bagfile
        self.topic = imagetopic
        self.bag = rosbag.Bag(bagfile)
        self.uncompress = None
        if imagetopic is None:
            raise RuntimeError("Please pass in a topic name referring to the image stream in the bag file\n{0}".format(self.bag));

        self.CVB = cv_bridge.CvBridge()
        # Get the message indices
        conx = self.bag._get_connections(topics=imagetopic)
        indices = self.bag._get_indexes(conx)
        
        try:
            self.index = indices.next()
        except:
            raise RuntimeError("Could not find topic {0} in {1}.".format(imagetopic, self.bagfile))
        
        self.indices = np.arange(len(self.index))
        
        #sort the indices by header.stamp
        self.indices = self. sortByTime(self.indices)
        
        #go through the bag and remove the indices outside the timespan [bag_start_time, bag_end_time]
        if bag_from_to:
            self.indices = self.truncateIndicesFromTime(self.indices, bag_from_to)
    
    #sort the ros messegaes by the header time not message time
    def sortByTime(self, indices):
        timestamps=list()
        for idx in self.indices:
            topic, data, stamp = self.bag._read_message(self.index[idx].position)
            timestamp = data.header.stamp.secs*1e9 + data.header.stamp.nsecs
            timestamps.append(timestamp)
        
        sorted_tuples = sorted(zip(timestamps, indices))
        sorted_indices = [tuple_value[1] for tuple_value in sorted_tuples]
        return sorted_indices

    def truncateIndicesFromTime(self, indices, bag_from_to):
        #get the timestamps
        timestamps=list()
        for idx in self.indices:
            topic, data, stamp = self.bag._read_message(self.index[idx].position)
            timestamp = data.header.stamp.secs + data.header.stamp.nsecs/1.0e9
            timestamps.append(timestamp)

        bagstart = min(timestamps)
        baglength = max(timestamps)-bagstart

        #some value checking
        if bag_from_to[0]>=bag_from_to[1]:
            raise RuntimeError("Bag start time must be bigger than end time.".format(bag_from_to[0]))
        if bag_from_to[0]<0.0:
            print "Bag start time of {0} s is smaller 0".format(bag_from_to[0])
        if bag_from_to[1]>baglength:
            print "Bag end time of {0} s is bigger than the total length of {1} s".format(bag_from_to[1], baglength)

        #find the valid timestamps
        valid_indices = []
        for idx, timestamp in enumerate(timestamps):
             if timestamp>=(bagstart+bag_from_to[0]) and timestamp<=(bagstart+bag_from_to[1]):
                 valid_indices.append(idx)  
        print "BagImageDatasetReader: truncated {0} / {1} images.".format(len(indices)-len(valid_indices), len(indices))
        return valid_indices
    
    def __iter__(self):
        # Reset the bag reading
        return self.readDataset()
    
    def readDataset(self):
        return BagImageDatasetReaderIterator(self, self.indices)

    def readDatasetShuffle(self):
        indices = self.indices
        np.random.shuffle(indices)
        return BagImageDatasetReaderIterator(self,indices)

    def numImages(self):
        return len(self.indices)

    def getImage(self,idx):
        topic, data, stamp = self.bag._read_message(self.index[idx].position)
        ts = Time( data.header.stamp.secs, data.header.stamp.nsecs )
        if data._type == 'mv_cameras/ImageSnappyMsg':
            if self.uncompress is None:
                from snappy import uncompress
                self.uncompress = uncompress
            img_data = np.reshape(self.uncompress(np.fromstring(data.data, dtype='uint8')),(data.height,data.width), order="C")
            
        else:
            img_data = np.squeeze(np.array(self.CVB.imgmsg_to_cv2(data, "mono8")))
        return (ts, img_data)

class BagImuDatasetReaderIterator(object):
    def __init__(self,dataset,indices=None):
        self.dataset = dataset
        if indices is None:
            self.indices = np.arange(dataset.numMessages())
        else:
            self.indices = indices
        self.iter = self.indices.__iter__()
    def __iter__(self):
        return self
    def next(self):
        idx = self.iter.next()
        return self.dataset.getMessage(idx)

class BagImuDatasetReader(object):
    def __init__(self, bagfile, imutopic, bag_from_to=None):
        self.bagfile = bagfile
        self.topic = imutopic
        self.bag = rosbag.Bag(bagfile)
        self.uncompress = None
        if imutopic is None:
            raise RuntimeError("Please pass in a topic name referring to the imu stream in the bag file\n{0}".format(self.bag));

        # Get the message indices
        conx = self.bag._get_connections(topics=imutopic)
        indices = self.bag._get_indexes(conx)
        
        try:
            self.index = indices.next()
        except:
            raise RuntimeError("Could not find topic {0} in {1}.".format(imutopic, self.bagfile))
        
        self.indices = np.arange(len(self.index))
        
        #sort the indices by header.stamp
        self.indices = self. sortByTime(self.indices)
        
        #go through the bag and remove the indices outside the timespan [bag_start_time, bag_end_time]
        if bag_from_to:
            self.indices = self.truncateIndicesFromTime(self.indices, bag_from_to)
            
    #sort the ros messegaes by the header time not message time
    def sortByTime(self, indices):
        timestamps=list()
        for idx in self.indices:
            topic, data, stamp = self.bag._read_message(self.index[idx].position)
            timestamp = data.header.stamp.secs*1e9 + data.header.stamp.nsecs
            timestamps.append(timestamp)
        
        sorted_tuples = sorted(zip(timestamps, indices))
        sorted_indices = [tuple_value[1] for tuple_value in sorted_tuples]
        return sorted_indices
    
    def truncateIndicesFromTime(self, indices, bag_from_to):
        #get the timestamps
        timestamps=list()
        for idx in self.indices:
            topic, data, stamp = self.bag._read_message(self.index[idx].position)
            timestamp = data.header.stamp.secs + data.header.stamp.nsecs/1.0e9
            timestamps.append(timestamp)

        bagstart = min(timestamps)
        baglength = max(timestamps)-bagstart
        print "bagstart",bagstart
        print "baglength",baglength
        #some value checking
        if bag_from_to[0]>=bag_from_to[1]:
            raise RuntimeError("Bag start time must be bigger than end time.".format(bag_from_to[0]))
        if bag_from_to[0]<0.0:
            print "Bag start time of {0} s is smaller 0".format(bag_from_to[0])
        if bag_from_to[1]>baglength:
            print "Bag end time of {0} s is bigger than the total length of {1} s".format(bag_from_to[1], baglength)

        #find the valid timestamps
        valid_indices = []
        for idx, timestamp in enumerate(timestamps):
             if timestamp>=(bagstart+bag_from_to[0]) and timestamp<=(bagstart+bag_from_to[1]):
                 valid_indices.append(idx)  
        print "BagImuDatasetReader: truncated {0} / {1} messages.".format(len(indices)-len(valid_indices), len(indices))
        
        return valid_indices
    
    def __iter__(self):
        # Reset the bag reading
        return self.readDataset()
    
    def readDataset(self):
        return BagImuDatasetReaderIterator(self, self.indices)

    def readDatasetShuffle(self):
        indices = self.indices
        np.random.shuffle(indices)
        return BagImuDatasetReaderIterator(self,indices)

    def numMessages(self):
        return len(self.indices)
    
    def getMessage(self,idx):
        topic, data, stamp = self.bag._read_message(self.index[idx].position)
        
        timestamp = Time( data.header.stamp.secs, data.header.stamp.nsecs )
        omega = np.array( [data.angular_velocity.x, data.angular_velocity.y, data.angular_velocity.z])
        alpha = np.array( [data.linear_acceleration.x, data.linear_acceleration.y, data.linear_acceleration.z] )
        
        return (timestamp, omega, alpha)
