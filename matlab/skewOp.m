% ------------------------------------------------------------------------------
% Function : Skew-symmetric matrix operator
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 01 FEB 2013 Initial version
%            V02 02 APR 2014 Formatting
%            V03 10 SEP 2014 Slightly faster
%                12JUN2015   Fill W directly (not tested if faster)
% Comment  : Follows [1] (6)
% Status   : 
%
% w        : 3x1 input vector
%
% W        : 3x3 skew-symmetric matrix
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function W = skewOp(w)
%   w1 = w(1,1);
%   w2 = w(2,1);
%   w3 = w(3,1);
%   W = zeros(3, 3);
%   W(1, 2) = -w3;
%   W(1, 3) = w2;
%   W(2, 1) = w3;
%   W(2, 3) = -w1;
%   W(3, 1) = -w2;
%   W(3, 2) = w1;
  W = [0, -w(3), w(2);
       w(3), 0, -w(1);
       -w(2), w(1), 0];
end
