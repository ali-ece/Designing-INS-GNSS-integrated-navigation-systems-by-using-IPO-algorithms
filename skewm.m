function S = skewm(v)
% Ali Mohammadi_INS/GNSS

% skewm: forms a skew-symmetric matrix from a 3-elements vector.
%
% INPUT
%   v: vector.
%
%	OUTPUT
%	  S: 3x3 skew-symmetric matrix.
%%

x = v(1);
y = v(2);
z = v(3);

S = [ 0 -z   y;
      z  0  -x;
     -y  x   0; ];

end
