import Progress as pro
import warnings

from DataWriter import *

from DatasetReader import BagDatasetReader

class CSVWriter(object):
    def __init__(self, bagfile, topic, output_folder, bag_from_to=None):
               
        self.dataset = BagDatasetReader(bagfile,topic,bag_from_to)
        self.topic = topic
        
        sensor_options = {"sensor_msgs/Imu" : ImuDataWriter,
                        "sensor_msgs/Image" : ImageDataWriter,
                        "geometry_msgs/PointStamped" : LeicaDataWriter,
                        "leica_interface/Status" : LeicaStatusWriter,
                        "nav_msgs/Odometry" : OdomDataWriter,
                          "mav_msgs/Actuators" : ActuatorDataWriter}
        
        message_type = self.dataset.getMessageType();

        try:
            sensor_writer = sensor_options[message_type]
            self.data_writer = sensor_writer("{0}{1}".format(output_folder,topic))
        except KeyError:
            warnings.warn("No csv writer for messages of type {0} found, skipping".format(message_type))
            self.data_writer = DataWriter("{0}{1}".format(output_folder,topic))
            
        
    def write(self):
        
        # prepare progess bar
        iProgress = pro.Progress2(self.dataset.numMessages())

        print "Extracting {0} messages from topic {1}".format(self.dataset.numMessages(), self.topic)
        iProgress.sample()

        self.data_writer.writeHeader(self.dataset)
        for data in self.dataset:
            self.data_writer.writeBodyLine(data)
            iProgress.sample() 
        print "\r      done.                                                          "