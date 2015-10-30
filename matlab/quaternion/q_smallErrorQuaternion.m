% ------------------------------------------------------------------------------
% Function : Generates a random, small rotation quaternion.
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 28MAY2015 Initial version.
% Status   : 
%
% r        : one sigma magnitude of angle of rotation (direction is random)
%
% ------------------------------------------------------------------------------

function q = q_smallErrorQuaternion(r)

% check input dimensions
assert(size(r, 1)==1);

N = size(r, 2);
q = zeros(4, N);

% compute small quaternions
for n=1:N
  k = randn(3, 1);
  k = k/sqrt(k'*k);
  r_n = r * randn(1, 1);
  q(:, n) = [ cos(r_n / 2);
              k * sin(r_n / 2)];
end

assert(sum(q(1, :) <= 0) == 0);

end
