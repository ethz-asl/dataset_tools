% ------------------------------------------------------------------------------
% Function : multiply quaternions
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function r = q_mul_multi(q, p)
sq = size(q);
sp = size(p);

assert(sq(1) == 4);
assert(sp(1) == 4);

N = sq(2);
assert(sp(2) == N);

r = zeros(4, N);

for i=1:N
    r(:, i) = [ - q(2,i)*p(2,i) - q(3,i)*p(3,i) - q(4,i)*p(4,i) + q(1,i)*p(1,i) ;
                + q(1,i)*p(2,i) + q(4,i)*p(3,i) - q(3,i)*p(4,i) + q(2,i)*p(1,i) ;
                - q(4,i)*p(2,i) + q(1,i)*p(3,i) + q(2,i)*p(4,i) + q(3,i)*p(1,i) ;
                + q(3,i)*p(2,i) - q(2,i)*p(3,i) + q(1,i)*p(4,i) + q(4,i)*p(1,i) ];
    
    r(:, i) = q_min(r(:, i));
end
end
