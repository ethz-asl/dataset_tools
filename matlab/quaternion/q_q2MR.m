% ------------------------------------------------------------------------------
% Function : Quaternion right multiplication matrix from quaternion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 16 AUG 2014 Initial version
% Comment  : Follows [1] (17)
% Status   : Only implemented equation from reference.
%
% q        : 4x1 quaternion, [qx; qy; qz; qw]
%
% ML       : 4x4 uaternion right multiplication matrix
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function MR = q_q2MR(q)

% check if input dimensions are correct
si = size(q);
assert(si(1)==4);
assert(si(2)==1);

q1 = q(1);
q2 = q(2);
q3 = q(3);
q4 = q(4);
MR = [q1, -q2, -q3, -q4;
      q2, q1, -q4, q3;
      q3, q4, q1, -q2;
      q4, -q3, q2, q1];
    
end
