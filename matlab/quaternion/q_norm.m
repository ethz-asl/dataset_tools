% ------------------------------------------------------------------------------
% Function : normalize quaternion
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function p = q_norm(q)

% check input dimensions
assert(size(q,1)==4);

N = size(q,2);
p=zeros(4,N);

% normalize quaternions    
for i=1:N
  p(:,i) = q(:,i)/norm(q(:,i));
end

end

