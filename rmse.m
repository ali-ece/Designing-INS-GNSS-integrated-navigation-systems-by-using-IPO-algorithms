function rmserr = rmse (estimate, true)
% Ali Mohammadi_INS/GNSS

% rmse: rooted mean squarred error between two vectors.
%
% INPUT:
%   estimate: Nx1 estimate values.
%   true:     Nx1 true values, reference.
%
% OUTPUT:
%    rmserr: rooted mean squarred error.
%%

if( any(isnan(estimate)) || any(isnan(true)) )
    error('rmse: input vector with at least one NaN value');
end

if ( length (estimate) ~= length (true) )   
    error('rmse: vectors must have the same length')
end

rmserr =  sqrt ( mean ( ( estimate - true).^2 ) ) ;

end
