% ------------------------------------------------------------------------------
% Function : load sensor data
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------


function data = dataset_load_sensor_data(sensorType, sensorFolderName)

csvFilename = [sensorFolderName, '/data.csv'];   % TODO

switch(sensorType)

  case 'imu'
    fileID = fopen(csvFilename);
    csvRawData = textscan(fileID, '%u64,%f,%f,%f,%f,%f,%f', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.omega = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.a = [csvRawData{5}, csvRawData{6}, csvRawData{7}]';
    fclose(fileID);

  case 'camera'
    fileID = fopen(csvFilename);
    csvRawData = textscan(fileID, '%u64,%s', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.filenames = [csvRawData{2}]';
    fclose(fileID);
    
  case 'position'
    fileID = fopen(csvFilename);
    csvRawData = textscan(fileID, '%u64,%f,%f,%f', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    fclose(fileID);
    
  case 'pose'
    fileID = fopen(csvFilename);
    csvRawData = textscan(fileID, '%u64,%f,%f,%f,%f,%f,%f,%f', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.q_SR = [csvRawData{5}, csvRawData{6}, csvRawData{7}, csvRawData{8}]';
    fclose(fileID);
    
  case 'visual-inertial'
    fileID = fopen(csvFilename);
    csvRawData = ...
        textscan(fileID, ....
                 '%u64,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', ...
                 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.q_SR = [csvRawData{5}, csvRawData{6}, csvRawData{7}, csvRawData{8}]';
    data.v_RS_R = [csvRawData{9}, csvRawData{10}, csvRawData{11}]';
    data.bw_S = [csvRawData{12}, csvRawData{13}, csvRawData{14}]';
    data.ba_S = [csvRawData{15}, csvRawData{16}, csvRawData{17}]';
    fclose(fileID);
    
  case 'pointcloud'
    data = [];
    
  otherwise
    assert(false, 'unknown sensor type');

end

end
