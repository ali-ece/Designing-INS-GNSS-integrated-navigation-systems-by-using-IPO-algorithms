function wb_sim = gyro_gen (ref, imu)
% Ali Mohammadi_INS/GNSS

% gyro_gen: generates simulated gyros measurements from reference data and
%          imu error profile.
%
% INPUT
%		ref: data structure with true trajectory.
%		imu: data structure with IMU error profile.
%
% OUTPUT
%		wb_sim: Nx3 matrix with simulated gryos in the body frame [X Y Z] 
%     (rad, rad, rad).
%%

N = max(size(ref.t));
M = [N, 3];

%% SIMULATE GYRO

% If true turn rates are provided...
if (isfield(ref, 'wb'))
    
    gyro_b = ref.wb;
    
% If not, obtain turn rates from DCM
else
    gyro_raw = gyro_gen_delta(ref.DCMnb, ref.t);
    gyro_raw = [0 0 0; gyro_raw;];
    
    % Noise introduced by differentation at gyro_gen_delta() should be smoothed.
    gyro_b = my_sgolayfilt(gyro_raw);
end

%% SIMULATE TRANSPORTE AND EARTH RATES

g_err_b = zeros(M);
for i = 1:N
    
    dcmnb = reshape(ref.DCMnb(i,:), 3, 3);
    omega_ie_n = earthrate(ref.lat(i));
    omega_en_n = transportrate(ref.lat(i), ref.vel(i,1), ref.vel(i,2), ref.h(i));
    omega_in_b = dcmnb * (omega_en_n + omega_ie_n );
    g_err_b(i,:) = ( omega_in_b )';
end

%% SIMULATE NOISES

% -------------------------------------------------------------------------
% Simulate static bias as a constant random variable

[g_sbias] = noise_sbias (imu.gb_sta, N);

% -------------------------------------------------------------------------
% Simulate white noise

wn = randn(M);
g_wn = zeros(M);

for i=1:3

    g_wn(:, i) = imu.g_std(i).* wn(:,i);
end

% -------------------------------------------------------------------------
% Simulate dynamic bias (bias instability) as a first-order Gauss-Markov model

dt = 1/imu.freq; 
[g_dbias] = noise_dbias (imu.gb_corr, imu.gb_dyn, dt, M);

% -------------------------------------------------------------------------
% Simulate rate random walk

[g_rrw] = noise_rrw (imu.arrw, dt, M);

% -------------------------------------------------------------------------

wb_sim = gyro_b + g_err_b + g_wn + g_sbias + g_dbias + g_rrw;

end
