% ------------------------------------------------------------------------------
% Function : Load sensor data
% Project  : ASL Datasets
% Author   : ASL, ETH
% Version  : V01  08JUL2015 Initial version.
% Comment  :
% Status   : 
% ------------------------------------------------------------------------------


function data = asl_dataset_load_sensor_data(sensorType, sensorFolderName)

csvFilename = [sensorFolderName, '/data.csv'];   % TODO
fileID = fopen(csvFilename);

switch(sensorType)

  case 'imu'
    csvRawData = textscan(fileID, '%u64 %f %f %f %f %f %f');
    data.timestamp_m = csvRawData{1}';
    data.omega = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.a = [csvRawData{5}, csvRawData{6}, csvRawData{7}]';

  case 'camera'

  otherwise
    assert(false, 'unknown sensor type');

end

fclose(fileID);

end
