function [gnss, gnss_r] = gnss_gen(ref, gnss)
% Ali Mohammadi_INS/GNSS

% gnss_gen: generates GNSS position and GNSS velocity in the n-frame from reference data.
%
% INPUT
%   ref: reference data structure.
%   gnss: GNSS data structure.
%
% OUTPUT
%   gnss: GNSS data structure with noisy measurements.
%   gnss_r: GNSS data structure with true measurements.
%%

[m,n] = size (ref.t);

if n > m, m = n; end

% Downsampling GNSS estimates from ref.freq to gnss.freq.
dt   = mean(diff(ref.t));
freq = 1/dt;
dspl = round(freq / gnss.freq);

gnss_r.t     = ref.t    (1:dspl:end, :);
gnss_r.lat   = ref.lat  (1:dspl:end, :);
gnss_r.lon   = ref.lon  (1:dspl:end, :);
gnss_r.h     = ref.h    (1:dspl:end, :);
gnss_r.vel   = ref.vel  (1:dspl:end, :);

gnss_r.freq = round(1/mean(diff(gnss_r.t)));

% Gaussian noise vectors
r1 = randn(size(gnss_r.t));
r2 = randn(size(gnss_r.t));
r3 = randn(size(gnss_r.t));

r4 = randn(size(gnss_r.t));
r5 = randn(size(gnss_r.t));
r6 = randn(size(gnss_r.t));

gnss.t   = gnss_r.t;
gnss.lat = gnss_r.lat + gnss.std(1) .* r1;
gnss.lon = gnss_r.lon + gnss.std(2) .* r2;
gnss.h   = gnss_r.h   + gnss.std(3) .* r3;
gnss.vel = gnss_r.vel + [gnss.stdv(1).*r4  gnss.stdv(2).*r5  gnss.stdv(3).*r6];

end

