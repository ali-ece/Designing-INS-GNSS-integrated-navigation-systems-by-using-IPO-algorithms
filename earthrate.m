function omega_ie_n = earthrate(lat, precision)
% Ali Mohammadi_INS/GNSS

% earthrate: turn rate of the Earth in the navigation frame.
%%

if nargin < 2, precision = 'double'; end

if strcmp(precision, 'single')
    
    omega_ie_n = single((7.2921155e-5) .* [ single(cos(lat));  single(0) ; single(-sin(lat)) ]); 
else
    
    omega_ie_n = (7.2921155e-5) .* [ (cos(lat));  0 ; -sin(lat) ]; 
end
