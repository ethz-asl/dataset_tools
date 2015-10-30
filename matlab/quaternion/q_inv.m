% ------------------------------------------------------------------------------
% Function : Computes quaternion inverse
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 01 FEB 2013 Initial version
%            V02 02 APR 2014 Formatting
% Comment  : Follows [1] (13)
% Status   : 
%
% p        : 4xN input quaternions [qx; qy; qz; qw]
%
% q        : 4xN inverse quaternions of p
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function q = q_inv(p)

% check input dimensions
assert(size(p,1)==4);
assert(p(1) >= 0);

N = size(p,2);
q=zeros(4,N);

% compute inverse
for n=1:N
  q(:,n) = [p(1,n);-p(2:4,n)];
end

end
