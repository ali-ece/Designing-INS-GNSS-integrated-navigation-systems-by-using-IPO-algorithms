function  navego_plot (ref, gnss, nav_e, gnss_r, nav_r, ref_g, ref_n)
% Ali Mohammadi_INS/GNSS

% navego_plot: plots results from INS/GNSS integration dataset.
%
% INPUT:
%   ref,    reference dataset.
%   gnss,   GNSS dataset.
%   nav_e,  INS/GNSS integration dataset.
%   gnss_r, GNSS dataset interpolated by reference time vector.
%   nav_r,  INS/GNSS dataset interpolated by reference time vector.
%   ref_n,  reference dataset adjusted by INS/GNSS interpolation.
%   ref_g,  reference dataset interpolated by GNSS interpolation.
%
% OUTPUT
%   several figures.
%%

% D2R = (pi/180);     % degrees to radians
R2D = (180/pi);     % radians to degrees

% Standard deviation * 3 vector from navigation estimates
sig3_v = abs(nav_e.Pp(:, 1:16:end).^(0.5)) .* 3; % Only take diagonal elements from Pp

% TRAJECTORY
figure;
plot3(ref_n.lon.*R2D, ref_n.lat.*R2D, ref_n.h, '--k')
hold on
plot3(nav_r.lon.*R2D, nav_r.lat.*R2D, nav_r.h, '-.b')
plot3(nav_r.lon.*R2D, nav_r.lat.*R2D, nav_r.h, 'og')
plot3(ref_n.lon(1).*R2D, ref_n.lat(1).*R2D, ref_n.h(1), 'or', 'MarkerSize', 10, 'LineWidth', 2)
axis tight
title('TRAJECTORY')
xlabel('Longitude [deg]')
ylabel('Latitude [deg]')
zlabel('Altitude [m]')
view(0, 90)
legend('REF', 'INS/GNSS', 'Location','best');
grid

% ATTITUDE
figure;
subplot(311)
plot(ref.t, R2D.*ref.roll, '--k', nav_e.t, R2D.*nav_e.roll,'-.b');
ylabel('[deg]')
xlabel('Time [s]')
legend('REF', 'INS/GNSS');
title('ROLL');
grid

subplot(312)
plot(ref.t, R2D.*ref.pitch, '--k', nav_e.t, R2D.*nav_e.pitch,'-.b');
ylabel('[deg]')
xlabel('Time [s]')
legend('REF', 'INS/GNSS')
title('PITCH');
grid

subplot(313)
plot(ref.t, R2D.* ref.yaw, '--k', nav_e.t, R2D.*nav_e.yaw,'-.b');
ylabel('[deg]')
xlabel('Time [s]')
legend('REF', 'INS/GNSS')
title('YAW');
grid

% ATTITUDE ERRORS
figure;
subplot(311)
plot(nav_r.t, (nav_r.roll - ref_n.roll).*R2D, '-.b' );
hold on
plot (nav_e.tg, R2D.*sig3_v(:,1), '--k', nav_e.tg, -R2D.*sig3_v(:,1), '--k' )
ylabel('[deg]')
xlabel('Time [s]')
legend('INS/GNSS', '3\sigma');
title('ROLL ERROR');
grid

subplot(312)
plot(nav_r.t, (nav_r.pitch - ref_n.pitch).*R2D, '-.b' );
hold on
plot (nav_e.tg, R2D.*sig3_v(:,2), '--k', nav_e.tg, -R2D.*sig3_v(:,2), '--k' )
ylabel('[deg]')
xlabel('Time [s]')
legend('INS/GNSS', '3\sigma');
title('PITCH ERROR');
grid

subplot(313)

yaw_err = correct_yaw(nav_r.yaw - ref_n.yaw);
plot(nav_r.t, yaw_err.*R2D, '-.b' );
hold on
plot (nav_e.tg, R2D.*sig3_v(:,3), '--k', nav_e.tg, -R2D.*sig3_v(:,3), '--k' )
ylabel('[deg]')
xlabel('Time [s]')
legend('INS/GNSS', '3\sigma');
title('YAW ERROR');
grid

% VELOCITIES
figure;
subplot(311)
plot(ref.t, ref.vel(:,1), '--k', gnss.t, gnss.vel(:,1),'-c', nav_e.t, nav_e.vel(:,1),'-.b' );
xlabel('Time [s]')
ylabel('[m/s]')
legend('REF', 'GNSS', 'INS/GNSS');
title('NORTH VELOCITY');
grid

subplot(312)
plot(ref.t, ref.vel(:,2), '--k', gnss.t, gnss.vel(:,2),'-c', nav_e.t, nav_e.vel(:,2),'-.b' );
xlabel('Time [s]')
ylabel('[m/s]')
legend('REF', 'GNSS', 'INS/GNSS');
title('EAST VELOCITY');
grid

subplot(313)
plot(ref.t, ref.vel(:,3), '--k', gnss.t, gnss.vel(:,3),'-c', nav_e.t, nav_e.vel(:,3),'-.b' );
xlabel('Time [s]')
ylabel('[m/s]')
legend('REF', 'GNSS', 'INS/GNSS');
title('DOWN VELOCITY');
grid

% VELOCITIES ERRORS
figure;
subplot(311)
plot(gnss_r.t, (gnss_r.vel(:,1) - ref_g.vel(:,1)), '-c');
hold on
plot(nav_r.t, (nav_r.vel(:,1) - ref_n.vel(:,1)), '-.b' );
plot (nav_e.tg, sig3_v(:,4), '--k', nav_e.tg, -sig3_v(:,4), '--k' )
xlabel('Time [s]')
ylabel('[m/s]')
legend('GNSS', 'INS/GNSS', '3\sigma');
title('VELOCITY NORTH ERROR');
grid

subplot(312)
plot(gnss_r.t, (gnss_r.vel(:,2) - ref_g.vel(:,2)), '-c');
hold on
plot(nav_r.t, (nav_r.vel(:,2) - ref_n.vel(:,2)), '-.b' );
plot (nav_e.tg, sig3_v(:,5), '--k', nav_e.tg, -sig3_v(:,5), '--k' )
xlabel('Time [s]')
ylabel('[m/s]')
legend('GNSS', 'INS/GNSS', '3\sigma');
title('VELOCITY EAST ERROR');
grid

subplot(313)
plot(gnss_r.t, (gnss_r.vel(:,3) - ref_g.vel(:,3)), '-c');
hold on
plot(nav_r.t, (nav_r.vel(:,3) - ref_n.vel(:,3)), '-.b' );
plot (nav_e.tg, sig3_v(:,6), '--k', nav_e.tg, -sig3_v(:,6), '--k' )
xlabel('Time [s]')
ylabel('[m/s]')
legend('GNSS', 'INS/GNSS', '3\sigma');
title('VELOCITY DOWN ERROR');
grid

% POSITION
figure;
subplot(311)
plot(ref.t, ref.lat .*R2D, '--k', gnss.t, gnss.lat.*R2D, '-c', nav_e.t, nav_e.lat.*R2D, '-.b');
xlabel('Time [s]')
ylabel('[deg]')
legend('REF', 'GNSS', 'INS/GNSS' );
title('LATITUDE');
grid

subplot(312)
plot(ref.t, ref.lon .*R2D, '--k', gnss.t, gnss.lon.*R2D, '-c', nav_e.t, nav_e.lon.*R2D, '-.b');
xlabel('Time [s]')
ylabel('[deg]')
legend('REF', 'GNSS', 'INS/GNSS' );
title('LONGITUDE');
grid

subplot(313)
plot(ref.t, ref.h, '--k', gnss.t, gnss.h, '-c', nav_e.t, nav_e.h, '-.b')
xlabel('Time [s]')
ylabel('[m]')
legend('REF', 'GNSS', 'INS/GNSS');
title('ALTITUDE');
grid

% POSITION ERRORS
[RN,RE]  = radius(nav_r.lat);
LAT2M_1 = RN + nav_r.h;
LON2M_1 = (RE + nav_r.h).*cos(nav_r.lat);

[RN,RE]  = radius(gnss.lat);
LAT2M_G = RN + gnss.h;
LON2M_G = (RE + gnss.h).*cos(gnss.lat);

[RN,RE]  = radius(gnss_r.lat);
LAT2M_GR = RN + gnss_r.h;
LON2M_GR = (RE + gnss_r.h).*cos(gnss_r.lat);

figure;
subplot(311)
plot(gnss_r.t,  LAT2M_GR.*(gnss_r.lat - ref_g.lat), '-c')
hold on
plot(nav_r.t, LAT2M_1.*(nav_r.lat - ref_n.lat), '-.b')
plot (nav_e.tg, LAT2M_G.*sig3_v(:,7), '--k', nav_e.tg, -LAT2M_G.*sig3_v(:,7), '--k' )
xlabel('Time [s]')
ylabel('[m]')
legend('GNSS', 'INS/GNSS', '3\sigma');
title('LATITUDE ERROR');
grid

subplot(312)
plot(gnss_r.t, LON2M_GR.*(gnss_r.lon - ref_g.lon), '-c')
hold on
plot(nav_r.t, LON2M_1.*(nav_r.lon - ref_n.lon), '-.b')
plot(nav_e.tg, LON2M_G.*sig3_v(:,8), '--k', nav_e.tg, -LON2M_G.*sig3_v(:,8), '--k' )
xlabel('Time [s]')
ylabel('[m]')
legend('GNSS', 'INS/GNSS', '3\sigma');
title('LONGITUDE ERROR');
grid

subplot(313)
plot(gnss_r.t, (gnss_r.h - ref_g.h), '-c')
hold on
plot(nav_r.t, (nav_r.h - ref_n.h), '-.b')
plot(nav_e.tg, sig3_v(:,9), '--k', nav_e.tg, -sig3_v(:,9), '--k' )
xlabel('Time [s]')
ylabel('[m]')
legend('GNSS', 'INS/GNSS', '3\sigma');
title('ALTITUDE ERROR');
grid

% BIAS ESTIMATION
figure;
subplot(311)
plot(nav_e.tg, nav_e.b(:, 1).*R2D, '-.b');
xlabel('Time [s]')
ylabel('[deg]')
title('KF BIAS ESTIMATION X');
grid

subplot(312)
plot(nav_e.tg, nav_e.b(:, 2).*R2D, '-.b');
xlabel('Time [s]')
ylabel('[deg]')
title('KF BIAS ESTIMATION Y');
grid

subplot(313)
plot(nav_e.tg, nav_e.b(:, 3).*R2D, '-.b');
xlabel('Time [s]')
ylabel('[deg]')
title('KF BIAS ESTIMATION Z');
grid
