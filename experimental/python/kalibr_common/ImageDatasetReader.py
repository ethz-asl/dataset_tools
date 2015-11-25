import cv
import cv_bridge
import cv2
import os
import numpy as np
from DatasetReader import BagDatasetReader

class BagImageDatasetReader(BagDatasetReader):

    def getMessage(self,idx):
        topic, data, stamp = self.bag._read_message(self.index[idx].position)
        ts = int(1e9 * data.header.stamp.secs + data.header.stamp.nsecs)
        img_data = np.array(cv_bridge.CvBridge().imgmsg_to_cv2(data))
        return (ts, img_data)

    def writeHeader(self, writer):
        writer.writerow(["#timestamp [ns]", "filename"])
        os.makedirs("{0}/data/".format(self.output_folder))
    
    def writeBodyLine(self, message, writer):

        params = list()
        params.append(cv.CV_IMWRITE_PNG_COMPRESSION)
        params.append(0) #0: loss-less
        
        timestamp = message[0]
        image = message[1]
        
        filename = "{0}.png".format(timestamp)
        cv2.imwrite("{0}/data/{1}".format(self.output_folder, filename), image, params )

        writer.writerow([timestamp, filename])