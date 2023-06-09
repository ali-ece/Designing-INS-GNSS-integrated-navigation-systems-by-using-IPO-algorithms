function rw = allan_get_rw (tau, allan, dt)
% Ali Mohammadi_INS/GNSS

% allan_get_rw: gets random walk values from Allan variance.
%
% INPUT
%   tau:   Nx1 Allan variance time vector (seconds).
%   allan: Nx1 Allan variance.
%   dt: sampling time from the signal under analysis.
%
% OUTPUT
%   rw: random walk values.
%%

fprintf('allan_get_rw: Random angle parameter is valid ONLY if Allan variance curve presents a -0.5 slope.\n')

idx = find ( tau == 1 );    % Index for tau = 1 s

if ( ~isempty(idx) )        % if there is a precise value for tau = 1 s...
    
    rw =  (allan(idx));
    
else                        % if not...
    
    % Upsample values between 0.5 < tau < 1.5
    idx = find ( tau >= 0.5 & tau <= 1.5 );
    
    if ( isempty(idx) )
        error('allan_get_rw: ERROR, idx is empty')
    end
    
    tau_d = tau(idx);
    allan_d = allan(idx);
    
    % Upsampled time vector
    tau_up = tau(idx(1)):dt:tau(end);
    
    % Upsampled allan var. vector
    allan_up = interp1(tau_d, allan_d, tau_up, 'linear');
    
    jdx = find (tau_up == 1); % Index of tau = 1 s
    if ( isempty(jdx) )
        error('allan_get_rw: ERROR, jdx is empty')
    end
    
    rw =  allan_up(jdx);
    
end
