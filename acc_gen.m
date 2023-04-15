function [fb_sim] = acc_gen (ref, imu)
% Ali Mohammadi_INS/GNSS

% acc_gen: generates simulated accelerometers measurements from reference
%  data and imu error profile.
%
% INPUT
%		ref: data structure with true trajectory.
%		imu: data structure with IMU error profile.
%
% OUTPUT
%		fb_sim: Nx3 matrix with simulated accelerations in the
%		body frame [X Y Z] (m/s^2, m/s^2, m/s^2).
%%

N = max(size(ref.t));
M = [N, 3];

%% SIMULATE ACC

% If true accelerations are provided...
if (isfield(ref, 'fb'))
    
    acc_b = ref.fb;
    
% If not, obtain acceleration from velocity
elseif (isfield(ref, 'vel'))
    
    acc_raw = (diff(ref.vel)) ./ [diff(ref.t) diff(ref.t) diff(ref.t)];
    acc_raw = [ 0 0 0; acc_raw; ];
    
    % Noise introduced by differentation should be smoothed.
    acc_ned = my_sgolayfilt(acc_raw);
    acc_b = acc_nav2body(acc_ned, ref.DCMnb);
    
% If not, obtain acceleration from position
else
    
    % Method: LLH > ECEF > NED
    [~, acc_ned] = pllh2vned (ref);
    acc_b = acc_nav2body(acc_ned, ref.DCMnb);
end

%% SIMULATE GRAVITY AND CORIOLIS

% Gravity and Coriolis in nav-ref
grav_n = gravity(ref.lat, ref.h);
cor_n  = coriolis(ref.lat, ref.vel, ref.h);

% Gravity and Coriolis from nav-ref to body-ref
grav_b = zeros(M);
cor_b = zeros(M);
for i = 1:N
    dcm_nb = reshape(ref.DCMnb(i,:), 3, 3);
    gb = dcm_nb * grav_n(i,:)';
    corb =  dcm_nb * cor_n(i,:)';
    grav_b(i,:) = gb';
    cor_b(i,:) = corb';
end

%% SIMULATE NOISES

% -------------------------------------------------------------------------
% Simulate static bias as a constant random variable

[a_sbias] = noise_sbias (imu.ab_sta, N);

% -------------------------------------------------------------------------
% Simulate white noise

wn = randn(M);
a_wn = zeros(M);

for i=1:3

    a_wn(:, i) = imu.a_std(i).* wn(:,i);
end

% -------------------------------------------------------------------------
% Simulate dynamic bias (bias instability) as a first-order Gauss-Markov model

dt = 1/imu.freq; 
[a_dbias] = noise_dbias (imu.ab_corr, imu.ab_dyn, dt, M);

% -------------------------------------------------------------------------
% Simulate rate random walk

[a_rrw] = noise_rrw (imu.vrrw, dt, M);

% -------------------------------------------------------------------------

fb_sim = acc_b - cor_b + grav_b + a_wn + a_sbias + a_dbias + a_rrw;

end
