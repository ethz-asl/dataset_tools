import cv
import cv_bridge
import cv2
import os
import numpy as np
import csv
import os

class DataWriter(object):
    def __init__(self, output_folder):
        
        self.output_folder = output_folder
        os.makedirs(self.output_folder)
        
        file = open("{0}/data.csv".format(self.output_folder), 'wb')
        self.writer = csv.writer(file, delimiter=',')

    def writeHeader(self, data_length):
        return
        
    def writeBodyLine(self, message):
        return
    
class ImuDataWriter(DataWriter):

    def writeHeader(self, data_length):
        self.writer.writerow("#8 header rows")
        self.writer.writerow("#{0} data rows".format(data_length))
        self.writer.writerow("#data extracted from ros Imu message http://docs.ros.org/api/sensor_msgs/html/msg/Imu.html")
        self.writer.writerow("#data format:")
        self.writer.writerow("#    column 0: timestamp [ns]")
        self.writer.writerow("#    columns 1 to 3: angular velocity, using a fixed-axis representation with rotation order x,y,z [rad s^-1]")
        self.writer.writerow("#    columns 4 to 6: linear acceleration [m s^-2]")                      
        self.writer.writerow(["#timestamp", "w_SB_x", "w_SB_y", "w_SB_z", "a_SB_x", "a_SB_y", "a_SB_z"])
        
    def writeBodyLine(self,message):
        
        timestamp = int(1e9 * message.header.stamp.secs + message.header.stamp.nsecs)
        omega = [message.angular_velocity.x, message.angular_velocity.y, message.angular_velocity.z]
        alpha = [message.linear_acceleration.x, message.linear_acceleration.y, message.linear_acceleration.z]

        self.writer.writerow([timestamp, omega[0],omega[1],omega[2], alpha[0],alpha[1],alpha[2]])

class ImageDataWriter(DataWriter):

    def writeHeader(self, data_length):
        self.writer.writerow("#7 header rows")
        self.writer.writerow("#{0} data rows".format(data_length))
        self.writer.writerow("#data extracted from ros Image message http://docs.ros.org/api/sensor_msgs/html/msg/Image.html")
        self.writer.writerow("#data format:")
        self.writer.writerow("#    column 0: timestamp [ns]")
        self.writer.writerow("#    column 1: filename (file can be found in ./data/ directory)")
        self.writer.writerow(["#timestamp", "filename"])
        os.makedirs("{0}/data/".format(self.output_folder))
        
    def writeBodyLine(self,message):
        
        timestamp = int(1e9 * message.header.stamp.secs + message.header.stamp.nsecs)
        image = np.array(cv_bridge.CvBridge().imgmsg_to_cv2(message))

        params = list()
        params.append(cv.CV_IMWRITE_PNG_COMPRESSION)
        params.append(0) #0: loss-less
               
        filename = "{0}.png".format(timestamp)
        cv2.imwrite("{0}/data/{1}".format(self.output_folder, filename), image, params )

        self.writer.writerow([timestamp, filename])
        
class ViconDataWriter(DataWriter):
    
    def writeHeader(self):
        self.writer.writerow(["#timestamp [ns]", "p_RS_R_x [m]", "p_RS_R_y [m]", "p_RS_R_z [m]", "q_RS_w []", "q_RS_x []", "q_RS_y []", "q_RS_z []"])
        
    def writeBodyLine(self,message):
        
        timestamp = int(1e9 * message.header.stamp.secs + message.header.stamp.nsecs)
        position = [message.transform.translation.x, message.transform.translation.y, message.transform.translation.z]
        orientation = [message.transform.rotation.w, message.transform.rotation.x, message.transform.rotation.y, message.transform.rotation.z]

        self.writer.writerow([timestamp, position[0], position[1], position[2], orientation[0], orientation[1], orientation[2], orientation[3]])

class OdomDataWriter(DataWriter):

    def writeHeader(self, data_length):
        self.writer.writerow("#9 header rows")
        self.writer.writerow("#{0} data rows".format(data_length))
        self.writer.writerow("#data extracted from ros Odometry message http://docs.ros.org/api/nav_msgs/html/msg/Odometry.html")
        self.writer.writerow("#data format:")
        self.writer.writerow("#    column 0: timestamp [ns]")
        self.writer.writerow("#    columns 1 to 3: postion [m]")
        self.writer.writerow("#    columns 4 to 7: active Hamilton unit quaternion with scalar term first (WXYZ)")
        self.writer.writerow("#    columns 8 to 43: 6x6 covariance matrix. In order, the parameters are: (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis) using a fixed-axis representation")
        self.writer.writerow(["#timestamp", 
                         "p_G_B_x", "p_G_B_y", "p_G_B_z", 
                         "q_G_B_w", "q_G_B_x", "q_G_B_y", "q_G_B_z",
                         "cov[0,0]","cov[1,0]","cov[2,0]","cov[3,0]","cov[4,0]","cov[5,0]",
                         "cov[0,1]","cov[1,1]","cov[2,1]","cov[3,1]","cov[4,1]","cov[5,1]",
                         "cov[0,2]","cov[1,2]","cov[2,2]","cov[3,2]","cov[4,2]","cov[5,2]",
                         "cov[0,3]","cov[1,3]","cov[2,3]","cov[3,3]","cov[4,3]","cov[5,3]",
                         "cov[0,4]","cov[1,4]","cov[2,4]","cov[3,4]","cov[4,4]","cov[5,4]",
                         "cov[0,5]","cov[1,5]","cov[2,5]","cov[3,5]","cov[4,5]","cov[5,5]"])
    
    def writeBodyLine(self,message):
        
        timestamp = [int(1e9 * message.header.stamp.secs + message.header.stamp.nsecs)]
        position = [message.pose.pose.position.x,message.pose.pose.position.y,message.pose.pose.position.z]
        orientation = [message.pose.pose.orientation.w,message.pose.pose.orientation.x,message.pose.pose.orientation.y,message.pose.pose.orientation.z]
        covariance = list(message.pose.covariance)

        self.writer.writerow(timestamp + position + orientation + covariance)

class LeicaDataWriter(DataWriter):
    
    def writeHeader(self, data_length):
        self.writer.writerow("#7 header rows")
        self.writer.writerow("#{0} data rows".format(data_length))
        self.writer.writerow("#data extracted from ros PointStamped message http://docs.ros.org/api/geometry_msgs/html/msg/PointStamped.html")
        self.writer.writerow("#data format:")
        self.writer.writerow("#    column 0: timestamp [ns]")
        self.writer.writerow("#    columns 1 to 3: position (XYZ) [m]")                    
        self.writer.writerow(["#timestamp", "p_LG_LB_x", "p_LG_LB_y", "p_LG_LB_z"])
        
    def writeBodyLine(self,message):
        
        timestamp = int(1e9 * message.header.stamp.secs + message.header.stamp.nsecs)
        point = [message.point.x, message.point.y, message.point.z]

        self.writer.writerow([timestamp, point[0],point[1],point[2]])

class LeicaStatusWriter(DataWriter):

    def writeHeader(self, data_length):
        self.writer.writerow("#7 header rows")
        self.writer.writerow("#{0} data rows".format(data_length))
        self.writer.writerow("#data extracted from leica_interface/Status message")
        self.writer.writerow("#data format:")
        self.writer.writerow("#    column 0: timestamp [ns]")
        self.writer.writerow("#    column 1: leica prism tracking status [True/False]")                   
        self.writer.writerow(["#timestamp", "tracking"])
        
    def writeBodyLine(self,message):
        
        timestamp = int(1e9 * message.header.stamp.secs + message.header.stamp.nsecs)

        self.writer.writerow([timestamp, message.tracking])        