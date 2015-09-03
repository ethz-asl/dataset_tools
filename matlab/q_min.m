% ------------------------------------------------------------------------------
% Function : make sure quaternion is minimal
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function q_min_ = q_min(q_)

N = size(q_, 2);

q_min_ = zeros(4, N);

for  i=1:N
  if(q_(1, i) >= 0)
    q_min_(:, i) = q_(:, i);
  else
    q_min_(:, i) = -q_(:, i);
  end
end

end
