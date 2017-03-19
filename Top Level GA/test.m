a = 13.65; % your float point number
n = 16;         % number bits for integer part of your number      
m = 25;         % number bits for fraction part of your number
% binary number
d2b = fix(rem(a*pow2(-(n-1):m),2))
% the inverse transformation
b2d = d2b*pow2(n-1:-1:-m).' 