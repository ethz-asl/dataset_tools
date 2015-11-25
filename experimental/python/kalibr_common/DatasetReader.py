import rosbag
import os
import csv
import numpy as np
import pylab as pl
import Progress as pro

class BagDatasetReaderIterator(object):
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

class BagDatasetReader(object):
    def __init__(self, bagfile, topic, output_folder=None, bag_from_to=None):
        self.bagfile = bagfile
        self.topic = topic
        self.bag = rosbag.Bag(bagfile)
        self.output_folder = output_folder
        self.uncompress = None
        if topic is None:
            raise RuntimeError("Please pass in a topic name referring to a stream in the bag file\n{0}".format(self.bag));

        # Get the message indices
        conx = self.bag._get_connections(topics=topic)
        indices = self.bag._get_indexes(conx)

        try:
            self.index = indices.next()
        except:
            raise RuntimeError("Could not find topic {0} in {1}.".format(topic, self.bagfile))

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
        print "BagDatasetReader: truncated {0} / {1} messages.".format(len(indices)-len(valid_indices), len(indices))

        return valid_indices

    def __iter__(self):
        # Reset the bag reading
        return self.readDataset()

    def readDataset(self):
        return BagDatasetReaderIterator(self, self.indices)

    def readDatasetShuffle(self):
        indices = self.indices
        np.random.shuffle(indices)
        return BagDatasetReaderIterator(self,indices)

    def numMessages(self):
        return len(self.indices)

    def writeBodyLine(self, message, writer):
            writer.writerow(message)
                
    def writeToCSV(self):
        
        os.makedirs(self.output_folder)
        
        # prepare progess bar
        iProgress = pro.Progress2(self.numMessages())

        print "Extracting {0} messages from topic {1}".format(self.numMessages(), self.topic)
        iProgress.sample()

        with open("{0}/data.csv".format(self.output_folder), 'wb') as file:
            spamwriter = csv.writer(file, delimiter=',')
            self.writeHeader(spamwriter)
            for data in self:
                self.writeBodyLine(data,spamwriter)
                iProgress.sample() 
            print "\r      done.                                                          "
        print
