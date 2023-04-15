function samples_s = my_sgolayfilt (samples)
% Ali Mohammadi_INS/GNSS

% my_sgolayfilt: Savitzky-Golay Filtering with variable frame length.
%
% INPUT
%		samples: Nx1 samples to be smoothed.
%
% OUTPUT
%		samples_s: Nx1 smoothed samples.
%%

samples_size = max(size(samples));

sgo_framelen = floor( samples_size / 5);

% sgo_framelen should not be greater than 21.
if (sgo_framelen > 21)
    sgo_framelen = 21;
end

% sgo_framelen must be odd
if ( mod(sgo_framelen, 2) == 0 )
    sgo_framelen = sgo_framelen +1;
end

sgo_order = ceil( sgo_framelen / 2);

samples_s = sgolayfilt(samples, sgo_order, sgo_framelen);

end
