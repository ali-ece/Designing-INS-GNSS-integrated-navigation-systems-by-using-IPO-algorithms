function fb = acc_nav2body (acc_n, DCMnb)
% Ali Mohammadi_INS/GNSS

% acc_nav2body: transforms accelerations from navigation frame to body
% frame.
%
% INPUT
%		acc_n: Nx3 matrix with [fn, fe, fd] accelerations in the navigation 
%		frame.
%		DCMnb: Nx9 matrix with nav-to-body direct cosine matrix (DCM). 
%		Each row contains [a11 a21 a31 a12 a22 a32 a13 a23 a33] elements 
%		from each DCM.
%
% OUTPUT
%		fb: Nx3 matrix with [fx, fy, fz] simulated accelerations in the
%		body frame.
%%

fb = zeros(size(acc_n));

for k = 1:max(size(acc_n)),
    
    DCMnb1 = reshape(DCMnb(k,:), 3, 3);
    fb(k,:) = ( DCMnb1 * ( acc_n(k,:)') )';
    
end

end
