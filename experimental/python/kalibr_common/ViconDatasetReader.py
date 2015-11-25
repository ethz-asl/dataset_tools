import rosbag
import os
import numpy as np
import pylab as pl
from DatasetReader import BagDatasetReader

class BagViconDatasetReader(BagDatasetReader):

    def getMessage(self,idx):
        topic, data, stamp = self.bag._read_message(self.index[idx].position)

        ts = int(1e9 * data.header.stamp.secs + data.header.stamp.nsecs)
        position = np.array( [data.transform.translation.x, data.transform.translation.y, data.transform.translation.z])
        orientation = np.array( [data.transform.rotation.w, data.transform.rotation.x, data.transform.rotation.y, data.transform.rotation.z] )

        message = [timestamp, position[0], position[1], position[2], orientation[0], orientation[1], orientation[2], orientation[3]]
        return message

    def writeHeader(self, writer):
        writer.writerow(["#timestamp [ns]", "p_RS_R_x [m]", "p_RS_R_y [m]", "p_RS_R_z [m]", "q_RS_w []", "q_RS_x []", "q_RS_y []", "q_RS_z []"])