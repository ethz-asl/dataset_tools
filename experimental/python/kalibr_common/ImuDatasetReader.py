import rosbag
import os
import numpy as np
import pylab as pl
from DatasetReader import BagDatasetReader

class BagImuDatasetReader(BagDatasetReader):

    def getMessage(self,idx):
        topic, data, stamp = self.bag._read_message(self.index[idx].position)

        timestamp = int(1e9 * data.header.stamp.secs + data.header.stamp.nsecs)
        omega = np.array( [data.angular_velocity.x, data.angular_velocity.y, data.angular_velocity.z])
        alpha = np.array( [data.linear_acceleration.x, data.linear_acceleration.y, data.linear_acceleration.z] )

        message = [timestamp, omega[0],omega[1],omega[2], alpha[0],alpha[1],alpha[2]]
        
        return message

    def writeHeader(self, writer):
        writer.writerow(["#timestamp [ns]", "w_SB_x [rad s^-1]", "w_SB_y [rad s^-1]", "w_SB_z [rad s^-1]", "a_SB_x [m s^-2]", "a_SB_y [m s^-2]", "a_SB_z [m s^-2]"])
    