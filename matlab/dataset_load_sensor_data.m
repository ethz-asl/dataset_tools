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
    data.t = csvRawData{1}';
    data.omega = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.a = [csvRawData{5}, csvRawData{6}, csvRawData{7}]';
    fclose(fileID);
    
  case 'camera'
    fileID = fopen(csvFilename);
    csvRawData = textscan(fileID, '%u64,%s', 'headerLines', 1);
    data.t = csvRawData{1}';
    data.filenames = [csvRawData{2}]';
    fclose(fileID);
    
  case 'position'
    fileID = fopen(csvFilename);
    csvRawData = textscan(fileID, '%u64,%f,%f,%f', 'headerLines', 1);
    data.t = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    fclose(fileID);
    
  case 'pose'
    fileID = fopen(csvFilename);
    csvRawData = ...
      textscan(fileID, '%u64,%f,%f,%f,%f,%f,%f,%f', 'headerLines', 1);
    data.t = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.q_RS = ...
      q_min([csvRawData{5}, csvRawData{6}, csvRawData{7}, csvRawData{8}]');
    fclose(fileID);
    
  case 'visual-inertial'
    fileID = fopen(csvFilename);
    csvRawData = ...
      textscan(fileID, ....
      '%u64,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', ...
      'headerLines', 1);
    data.t = csvRawData{1}';
    data.p_RS_R = [csvRawData{2}, csvRawData{3}, csvRawData{4}]';
    data.q_RS = ...
      q_min([csvRawData{5}, csvRawData{6}, csvRawData{7}, csvRawData{8}]');
    data.v_RS_R = [csvRawData{9}, csvRawData{10}, csvRawData{11}]';
    data.bw_S = [csvRawData{12}, csvRawData{13}, csvRawData{14}]';
    data.ba_S = [csvRawData{15}, csvRawData{16}, csvRawData{17}]';
    fclose(fileID);
    
  case 'camera_target'
    
    % target points
    csvFilenameTarget = [sensorFolderName, '/data_target.csv'];
    fileIDTarget = fopen(csvFilenameTarget);
    csvRawDataTarget = textscan(fileIDTarget, '%f,');
    NTargetPoints = length(csvRawDataTarget{1}) / 3;
    data.targetPoints_ = reshape(csvRawDataTarget{1}, NTargetPoints, 3)';
    fclose(fileIDTarget);
    
    % undistorted measurements
    csvFilenameUndistorted = [sensorFolderName, '/data_undistorted.csv'];
    fileIDUndistorted = fopen(csvFilenameUndistorted);
    csvRawDataUndistorted = ...
      textscan(fileIDUndistorted, ...
      ['%u64', repmat(',%f', 1, NTargetPoints * 3), '\n'], ...
      'headerLines', 0);
    X = [csvRawDataUndistorted{2:end}];
    NFrames = length(csvRawDataUndistorted{1});
    data.undistortedMeasurements_ = {};
    for nf = 1:NFrames
      data.undistortedMeasurements_{nf} = reshape(X(nf, :), 3, NTargetPoints);
    end
    data.t_m_ = [csvRawDataUndistorted{1}]';
    fclose(fileIDUndistorted);
    
    % pose estimates T_t_c (camera to target)
    csvFilenamePoseEstimates = [sensorFolderName, '/data_pose_estimates.csv'];
    fileIDPoseEstimates = fopen(csvFilenamePoseEstimates);
    csvRawDataPoseEstimates = ...
      textscan(fileIDPoseEstimates, ...
      ['%u64', repmat(',%f', 1, 4*4), '\n'], ...
      'headerLines', 0);
    X = [csvRawDataPoseEstimates{2:end}];
    NFrames = length(csvRawDataUndistorted{1});
    for nf = 1:NFrames
      data.T_TC_{nf} = reshape(X(nf, :), 4, 4)';
      data.q_TC_(:, nf) = q_C2q(data.T_TC_{nf}(1:3, 1:3));
      data.p_TC_T_(:, nf) = data.T_TC_{nf}(1:3, 4);
    end
    data.t = [csvRawDataPoseEstimates{1}]';
    fclose(fileIDPoseEstimates);
    
  case 'pointcloud'
    data = [];
    
  otherwise
    assert(false, 'unknown sensor type');
    
end

end
