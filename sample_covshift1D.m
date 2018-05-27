function [X_yn, X_yp, Z_yn, Z_yp] = sample_covshift2D(pT_X, varargin)
% Sample from class-conditional distributions, with equivalent posteriors,
% for both a source and a target domain. Function assumes Y = [-1, +1].
%
% Input:
%       pT_X            Target marginal data distribution
%
% Optional input:
%       p_y             Class-priors, default is balanced (each 1./2)
%       pS_X            Source data distribution, default is normal distribution 
%                       N(x | 0, 1)
%       p_yX            Posterior distribution, default is a cumulative normal 
%                       distribution: Phi( y*x | 0, 1)
%       ub              Upper bound for proposal distribution; a good way to 
%                       find a value is to take the target distributions 
%                       integral. For instance, for normal distributions, this 
%                       is sqrt(det(2*pi*sigma^2))
%       N               Source sample size
%       M               Target sample size
%       Sxl             Sampling range limits for pS(x|y)
%       Txl             Sampling range limits for pT(x|y)
%
% Output:
%       X_yn:           Samples from negative class-conditional, pS(x|y=-1)
%       X_yp:           Samples from positive class-conditional, pS(x|y=+1)
%       Z_yn:           Samples from negative class-conditional, pT(x|y=-1)
%       Z_yp:           Samples from positive class-conditional, pT(x|y=+1)
% 
% Example call:
%   pT_X = @(x) normpdf(x, 0, 2)
%   [Xn, Xp, Zn, Zp] = sample_covshift1D(pT_X, 'ub', sqrt(det(2*pi*2)))
%
% Copyright: Wouter M. Kouw
% Last update: 27-05-2018

addpath(genpath('util/'))

% Parse hyperparameters
argp = inputParser;
addOptional(argp, 'p_y', @(y) 1./2);
addOptional(argp, 'pS_X', @(x) normpdf(x, 0, 1));
addOptional(argp, 'p_yX', @(y, x) normcdf(y*x, 0, 1));
addOptional(argp, 'N', 100);
addOptional(argp, 'M', 200);
addOptional(argp, 'ub', sqrt(2*pi));
addOptional(argp, 'Sxl', [-10 10]);
addOptional(argp, 'Txl', [-10 10]);
parse(argp, varargin{:});

% TODO: assert pT_X is a function handle of 1 input, 1 output
% TODO: assert pS_X is a function handle of 1 input, 1 output
% TODO: assert p_y is a function handle of 1 input, 1 output
% TODO: assert p_yX is a function handle of two inputs, 1 output
% TODO: check if upper bound is large enough for given pT_X

% Compute number of samples to draw from each class-conditional distribution
Nn = round(argp.Results.N .* argp.Results.p_y(-1));
Np = round(argp.Results.N .* argp.Results.p_y(+1));
Mn = round(argp.Results.M .* argp.Results.p_y(-1));
Mp = round(argp.Results.M .* argp.Results.p_y(+1));

%% Distribution functions

% Source class-conditional likelihoods
pS_Xyn = @(x) (argp.Results.p_yX(-1,x) .* argp.Results.pS_X(x)) ./ argp.Results.p_y(-1);
pS_Xyp = @(x) (argp.Results.p_yX(+1,x) .* argp.Results.pS_X(x)) ./ argp.Results.p_y(+1);

% Target class-conditional distributions
pT_Xyn = @(x) (argp.Results.p_yX(-1,x) .* pT_X(x)) ./ argp.Results.p_y(-1);
pT_Xyp = @(x) (argp.Results.p_yX(+1,x) .* pT_X(x)) ./ argp.Results.p_y(+1);

%% Rejection sampling

% Sample from source class-conditional distributions
X_yn = sampleDist1D(pS_Xyn, argp.Results.ub, Nn, argp.Results.Sxl);
X_yp = sampleDist1D(pS_Xyp, argp.Results.ub, Np, argp.Results.Sxl);

% Sample from target class-conditional distributions
Z_yn = sampleDist1D(pT_Xyn, argp.Results.ub, Mn, argp.Results.Txl);
Z_yp = sampleDist1D(pT_Xyp, argp.Results.ub, Mp, argp.Results.Txl);

end