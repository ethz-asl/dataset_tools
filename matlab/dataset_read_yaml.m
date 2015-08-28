% ------------------------------------------------------------------------------
% Function : read yaml file, convert numerical entries
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------


function yamlContent = dataset_read_yaml(yamlFile)

yamlContent = ReadYaml(yamlFile);

assert(isfield(yamlContent, 'sensor_type'), 'no sensor_type specified for sensor');

fieldNamesYaml = fieldnames(yamlContent);
NFieldsYaml = length(fieldNamesYaml);

for iField=1:NFieldsYaml
  yamlEntry = getfield(yamlContent, fieldNamesYaml{iField});
  if(isfield(yamlEntry, 'data'))
    % found data entry, convert to matrix
    dataRaw = cell2mat(getfield(yamlEntry, 'data'));
    cols = getfield(yamlEntry, 'cols');
    rows = getfield(yamlEntry, 'rows');
    data = reshape(dataRaw, rows, cols)';
    
    yamlContent = setfield(yamlContent, fieldNamesYaml{iField}, data);
  end
end

end
