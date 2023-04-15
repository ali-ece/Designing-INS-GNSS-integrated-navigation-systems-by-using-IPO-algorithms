function [b_dyn, t_corr] = allan_get_b_dyn (tau, allan)
% Ali Mohammadi_INS/GNSS

% allan_get_b_dyn: gets dynamic bias values from Allan variance.
%
% INPUT
%   tau: Nx1 Allan variance time vector in seconds.
%   allan: Nx1 Allan variance vector.
% 
% OUTPUT
%   b_dyn: dynamic bias values.
%   t_corr: correlation time values.
%%

idx = find (allan == min(allan));   % Index for minimun value of AV.   

b_dyn = allan(idx) ;              % BI. For gyro, rad-per-sec.
                                    % BI. For acc,  meters-per-sec^2.
t_corr = tau(idx)  ;               % BI, correlation time, in seconds.  
