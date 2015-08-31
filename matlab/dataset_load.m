% ------------------------------------------------------------------------------
% Function : load dataset
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------


function dataset = dataset_load(datasetPath)

dataset = [];
dataset.body = {};


%% scan for bodys

disp('');
disp(' >> scanning dataset...');
datasetFolderContent = dir(datasetPath);
NFolderBody = length(datasetFolderContent);
for iFolderBody = 1:NFolderBody
  if((datasetFolderContent(iFolderBody).isdir) && ...
      (datasetFolderContent(iFolderBody).name(1) ~= '.'))
    bodyName = datasetFolderContent(iFolderBody).name;
    bodyFolderName = [datasetPath, '/', bodyName];
    bodyYamlFilename = [bodyFolderName, '/body.yaml'];
    
    % check if sensor.yaml exists
    if(exist(bodyYamlFilename, 'file') == 2)
      disp(['    body detected [', bodyName, ']']);
      dataset.body{end+1}.name = bodyName;
      dataset.body{end}.sensor = {};
      
      % scan for sensors
      bodyFolderContent = dir(bodyFolderName);
      NFolderSensor = length(bodyFolderContent);
      % for each sensor of the body
      for iFolderSensor = 1:NFolderSensor
        if((bodyFolderContent(iFolderSensor).isdir) && ...
            (bodyFolderContent(iFolderSensor).name(1) ~= '.'))
          sensorName = bodyFolderContent(iFolderSensor).name;
          sensorFolderName = [bodyFolderName, '/', sensorName];
          sensorYamlFilename = [sensorFolderName, '/sensor.yaml'];
          % check if sensor.yaml exists
          if(exist(sensorYamlFilename, 'file') == 2)
            dataset.body{end}.sensor{end+1} = ...
              dataset_read_yaml(sensorYamlFilename);
            dataset.body{end}.sensor{end}.name = sensorName;
            sensorType = dataset.body{end}.sensor{end}.sensor_type;
            dataset.body{end}.sensor{end}.data = ...
              dataset_load_sensor_data(sensorType, sensorFolderName);
            disp(['     sensor detected [', sensorName, '], [' sensorType ']']);
          end
        end
      end
    end
  end
end

assert(~isempty(dataset.body));

end
