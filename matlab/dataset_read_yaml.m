% ------------------------------------------------------------------------------
% Function : Read ASL Dataset Yaml file, convert numerical values
% Project  :
% Author   : ASL, ETH
% Version  : V01  07JUL2015 Initial version.
% Comment  :
% Status   : 
% ------------------------------------------------------------------------------


function yamlContent = asl_dataset_read_yaml(yamlFile)

yamlContent = ReadYaml(yamlFile);

assert(isfield(yamlContent, 'type'), 'no type specified for sensor');

fieldNamesYaml = fieldnames(yamlContent);
NFieldsYaml = length(fieldNamesYaml);

for iField=1:NFieldsYaml
  yamlEntry = getfield(yamlContent, fieldNamesYaml{iField});
  if(isfield(yamlEntry, 'data'))
    % found data entry, convert to matrix
    dataRaw = cell2mat(getfield(yamlEntry, 'data'));
    cols = getfield(yamlEntry, 'cols');
    rows = getfield(yamlEntry, 'rows');
    data = reshape(dataRaw, rows, cols);
    
    yamlContent = setfield(yamlContent, fieldNamesYaml{iField}, data);
  end
end

switch(yamlContent.type)
  case 'imu'
    
  otherwise
    disp(' >>> unknown sensor type detected');
end

end
