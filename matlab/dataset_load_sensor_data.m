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
fileID = fopen(csvFilename);

switch(sensorType)

  case 'imu'
    csvRawData = textscan(fileID, '%u64,%f,%f,%f,%f,%f,%f', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.omega = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.a = [csvRawData{5}, csvRawData{6}, csvRawData{7}]';

  case 'camera'
    csvRawData = textscan(fileID, '%u64,%s', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.filenames = [csvRawData{2}]';
    
  case 'position'
    csvRawData = textscan(fileID, '%u64,%f,%f,%f', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    
  case 'visual-inertial'
    csvRawData = textscan(fileID, '%u64,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 'headerLines', 1);
    data.timestamp_m = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.q_SR = [csvRawData{5}, csvRawData{6}, csvRawData{7}, csvRawData{8}]';
    data.v_RS_R = [csvRawData{9}, csvRawData{10}, csvRawData{11}]';
    data.bg_S = [csvRawData{12}, csvRawData{13}, csvRawData{14}]';
    data.ba_S = [csvRawData{15}, csvRawData{16}, csvRawData{17}]';
    
  otherwise
    assert(false, 'unknown sensor type');

end

fclose(fileID);

end
