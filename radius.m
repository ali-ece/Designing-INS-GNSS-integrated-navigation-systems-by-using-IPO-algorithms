function [RM,RN] = radius(lat)
% Ali Mohammadi_INS/GNSS

% radius: calculates meridian and normal radii of curvature.
%
% INPUT:
%   lat, Nx1 latitude (rad).
%
% OUTPUT:
%   RM, Nx1 meridian radius of curvature (m).
%   RN, Nx1 normal radius of curvature (m).
%
%   Output values preserve the precision of latitude, single or double 
%   precision.
%%

if (isa(lat,'single')) 
    
    a = single(6378137.0);
    e = single(0.0818191908426);
    
    e2 = e^2;
    den = 1 - e2 .* single(sin(lat)).^2;

else
    
    a = (6378137.0);
    e = (0.0818191908426);
    
    e2 = e^2;
    den = 1 - e2 .* (sin(lat)).^2;
end

% Meridian radius of curvature: radius of curvature for north-south motion.
RM = a .* (1-e2) ./ (den).^(3/2);

% Normal radius of curvature: radius of curvature for east-west motion. 
% AKA transverse radius.
RN = a ./ sqrt(den);

end
