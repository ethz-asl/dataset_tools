import rosbag
import os
import numpy as np
import pylab as pl
from DatasetReader import BagDatasetReader

class BagLeicaDatasetReader(BagDatasetReader):
   
    def getMessage(self,idx):
        topic, data, stamp = self.bag._read_message(self.index[idx].position)

        timestamp = int(1e9 * data.header.stamp.secs + data.header.stamp.nsecs)
        point = np.array( [data.point.x, data.point.y, data.point.z])

        message = [timestamp, point[0],point[1],point[2]]
        return message

    def writeHeader(self, writer):
        writer.writerow(["#timestamp [ns]", "p_LS_LB_x [m]", "p_LS_LB_y [m]", "p_LS_LB_z [m]"])
    