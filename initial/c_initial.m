function [status]=c_initial(S)

%
% C_INITIAL:  Create a ROMS initial conditions NetCDF file
%
% [status]=c_initial(S)
%
% This function creates a ROMS initial conditions NetCDF file using
% specified parameters in structure array, S.
%
% On Input:
%
%    S           Initial condidions creation parameters (structure array):
%
%                  S.ncname           NetCDF file name
%                  S.spherical        Spherical grid switch
%                  S.Vtransform       Vertical transformation equation
%                  S.Lm               Number of interior RHO-points in X
%                  S.Mm               Number of interior RHO-points in Y
%                  S.N                Number of vertical levels
%                  S.NT               Number of active and passive tracers
%
% On Output:
%
%    status      Error flag.
%

% svn $Id$
%=========================================================================%
%  Copyright (c) 2002-2020 The ROMS/TOMS Group                            %
%    Licensed under a MIT/X style license                                 %
%    See License_ROMS.txt                           Hernan G. Arango      %
%=========================================================================%

%--------------------------------------------------------------------------
%  Get initial condition creation parameters.
%--------------------------------------------------------------------------

if (isfield(S,'ncname')),
  ncname=S.ncname;
else
  error(['C_INITIAL - Cannot find dimension parameter: ncname, ',       ...
         'in structure array S']);
end

if (isfield(S,'spherical')),
  spherical=S.spherical;
else
  spherical=0;
end

if (isfield(S,'Vtransform')),
  Vtransform=S.Vtransform;
else
  error(['C_INITIAL - Cannot find dimension parameter: Vtransform, ',   ...
         'in structure array S']);
end

if (isfield(S,'Lm')),
  Lp=S.Lm+2;
else
  error(['C_INITIAL - Cannot find dimension parameter: Lm, ',           ...
         'in structure array S']);
end

if (isfield(S,'Mm')),
  Mp=S.Mm+2;
else
  error(['C_INITIAL - Cannot find dimension parameter: Mm, ',           ...
         'in structure array S']);
end

if (isfield(S,'N')),
  N=S.N;
else
  error(['C_INITIAL - Cannot find dimension parameter: N, ',            ...
         'in structure array S']);
end,

if (isfield(S,'NT')),
  NT=S.NT;
else
  error(['C_INITIAL - Cannot find dimension parameter: NT, ',           ...
         'in structure S']);
end

%--------------------------------------------------------------------------
%  Set dimensions.
%--------------------------------------------------------------------------

Dname.xr   = 'xi_rho';       Dsize.xr   = Lp;
Dname.xu   = 'xi_u';         Dsize.xu   = Lp-1;
Dname.xv   = 'xi_v';         Dsize.xv   = Lp;
Dname.xp   = 'xi_psi';       Dsize.xp   = Lp-1;
Dname.yr   = 'eta_rho';      Dsize.yr   = Mp;
Dname.yu   = 'eta_u';        Dsize.yu   = Mp;
Dname.yv   = 'eta_v';        Dsize.yv   = Mp-1;
Dname.yp   = 'eta_psi';      Dsize.yp   = Mp-1;
Dname.Nr   = 's_rho';        Dsize.Nr   = N;
Dname.Nw   = 's_w';          Dsize.Nw   = N+1;
Dname.NT   = 'tracer';       Dsize.NT   = NT;
Dname.time = 'ocean_time';   Dsize.time = nc_constant('nc_unlimited');

%--------------------------------------------------------------------------
%  Set Variables.
%--------------------------------------------------------------------------

%  Vertical grid variables.

Vname.Vtransform  = 'Vtransform';
Vname.Vstretching = 'Vstretching';
Vname.theta_s     = 'theta_s';
Vname.theta_b     = 'theta_b';
Vname.Tcline      = 'Tcline';
Vname.hc          = 'hc';
Vname.s_rho       = 's_rho';
Vname.s_w         = 's_w';
Vname.Cs_r        = 'Cs_r';
Vname.Cs_w        = 'Cs_w';

%  Horizontal grid variables.

Vname.spherical   = 'spherical';
Vname.h           = 'h';

if (spherical),
  Vname.rlon      = 'lon_rho';
  Vname.rlat      = 'lat_rho';
  Vname.ulon      = 'lon_u';
  Vname.ulat      = 'lat_u';
  Vname.vlon      = 'lon_v';
  Vname.vlat      = 'lat_v';
else
  Vname.rx        = 'x_rho';
  Vname.ry        = 'y_rho';
  Vname.ux        = 'x_u';
  Vname.uy        = 'y_u';
  Vname.vx        = 'x_v';
  Vname.vy        = 'y_v';
end

%  Initial conditions variables.

Vname.time        = 'ocean_time';
Vname.zeta        = 'zeta';
Vname.ubar        = 'ubar';
Vname.vbar        = 'vbar';
Vname.u           = 'u';
Vname.v           = 'v';
Vname.temp        = 'temp';
Vname.salt        = 'salt';

%--------------------------------------------------------------------------
%  Create initial conditions NetCDF file.
%--------------------------------------------------------------------------

[ncid,status]=mexnc('create',ncname,'clobber');
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error(['C_INITIAL: CREATE - unable to create file: ', ncname]);
end

%--------------------------------------------------------------------------
%  Define dimensions.
%--------------------------------------------------------------------------

[did.xr,status]=mexnc('def_dim',ncid,Dname.xr,Dsize.xr); 
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error(['C_INITIAL: ncdimdef - unable to define dimension: ',Dname.xr]);
end

[did.xu,status]=mexnc('def_dim',ncid,Dname.xu,Dsize.xu);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error(['C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.xu]);
end

[did.xv,status]=mexnc('def_dim',ncid,Dname.xv,Dsize.xv);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error(['C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.xv]);
end

[did.yr,status]=mexnc('def_dim',ncid,Dname.yr,Dsize.yr);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error(['C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.yr]);
end

[did.yu,status]=mexnc('def_dim',ncid,Dname.yu,Dsize.yu);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error([ 'C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.yu]);
end

[did.yv,status]=mexnc('def_dim',ncid,Dname.yv,Dsize.yv);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error([ 'C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.yv]);
end

[did.Nr,status]=mexnc('def_dim',ncid,Dname.Nr,Dsize.Nr);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error([ 'C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.Nr]);
end

[did.Nw,status]=mexnc('def_dim',ncid,Dname.Nw,Dsize.Nw);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error([ 'C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.Nw]);
end

[did.NT,status]=mexnc('def_dim',ncid,Dname.NT,Dsize.NT);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error([ 'C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.NT]);
end

[did.time,status]=mexnc('def_dim',ncid,Dname.time,Dsize.time);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error([ 'C_INITIAL: DEF_DIM - unable to define dimension: ',Dname.time]);
end

%--------------------------------------------------------------------------
%  Create global attributes.
%--------------------------------------------------------------------------

type='INITIALIZATION file';
lstr=max(size(type));
[status]=mexnc('PUT_ATT_TEXT',ncid,nc_constant('nc_global'),            ...
               'type',nc_constant('nc_char'),lstr,type);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error('C_INITIAL: PUT_ATT_TEXT - unable to global attribure: type.');
end

history=['Initial file using Matlab script: c_initial, ',date_stamp];
lstr=max(size(history));
[status]=mexnc('put_att_text',ncid,nc_constant('nc_global'),            ...
               'history',nc_constant('nc_char'),lstr,history);
if (status ~= 0),
  disp('  ');
  disp(mexnc('strerror',status));
  error('C_INITIAL: PUT_ATT_TEXT - unable to global attribure: history.');
end

%--------------------------------------------------------------------------
%  Define configuration variables.
%--------------------------------------------------------------------------

% Define spherical switch.

Var.name            = Vname.spherical;
Var.type            = nc_constant('nc_int');
Var.dimid           = [];
Var.long_name       = 'grid type logical switch';
Var.flag_values     = [0 1];
Var.flag_meanings   = ['Cartesian', blanks(1), ...
                       'spherical'];
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

% Define vertical coordinate variables.

Var.name            = Vname.Vtransform;
Var.type            = nc_constant('nc_int');
Var.dimid           = [];
Var.long_name       = 'vertical terrain-following transformation equation';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.Vstretching;
Var.type            = nc_constant('nc_int');
Var.dimid           = [];
Var.long_name       = 'vertical terrain-following stretching function';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.theta_s;
Var.type            = nc_constant('nc_double');
Var.dimid           = [];
Var.long_name       = 'S-coordinate surface control parameter';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.theta_b;
Var.type            = nc_constant('nc_double');
Var.dimid           = [];
Var.long_name       = 'S-coordinate bottom control parameter';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.Tcline;
Var.type            = nc_constant('nc_double');
Var.dimid           = [];
Var.long_name       = 'S-coordinate surface/bottom layer width';
Var.units           = 'meter';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.hc;
Var.type            = nc_constant('nc_double');
Var.dimid           = [];
Var.long_name       = 'S-coordinate parameter, critical depth';
Var.units           = 'meter';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.s_rho;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.Nr];
Var.long_name       = 'S-coordinate at RHO-points';
Var.valid_min       = -1;
Var.valid_max       = 0;
Var.positive        = 'up';
if (Vtransform == 1),
  Var.standard_name = 'ocean_s_coordinate_g1';
elseif (Vtransform == 2),
  Var.standard_name = 'ocean_s_coordinate_g2';
end,
Var.formula_terms   = 's: s_rho C: Cs_r eta: zeta depth: h depth_c: hc';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.s_w;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.Nw];
Var.long_name       = 'S-coordinate at W-points';
Var.valid_min       = -1;
Var.valid_max       = 0;
Var.positive        = 'up';
if (Vtransform == 1),
  Var.standard_name = 'ocean_s_coordinate_g1';
elseif (Vtransform == 2),
  Var.standard_name = 'ocean_s_coordinate_g2';
end,
Var.formula_terms   = 's: s_w C: Cs_w eta: zeta depth: h depth_c: hc';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.Cs_r;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.Nr];
Var.long_name       = 'S-coordinate stretching function at RHO-points';
Var.valid_min       = -1;
Var.valid_max       = 0;
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.Cs_w;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.Nw];
Var.long_name       = 'S-coordinate stretching function at W-points';
Var.valid_min       = -1;
Var.valid_max       = 0;
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var


%  Define bathymetry.

Var.name            = Vname.h;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.yr did.xr];
Var.long_name       = 'bathymetry at RHO-points';
Var.units           = 'meter';
if (spherical),
  Var.coordinates   = 'lon_rho lat_rho';
else
  Var.coordinates   = 'x_rho y_rho';
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

%  Define horizontal grid variables.

if (spherical),
  Var.name          = Vname.rlon;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yr did.xr];
  Var.long_name     = 'longitude of RHO-points';
  Var.units         = 'degree_east';
  Var.standard_name = 'longitude';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.rlat;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yr did.xr];
  Var.long_name     = 'latitute of RHO-points';
  Var.units         = 'degree_north';
  Var.standard_name = 'latitude';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.ulon;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yu did.xu];
  Var.long_name     = 'longitude of U-points';
  Var.units         = 'degree_east';
  Var.standard_name = 'longitude';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.ulat;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yu did.xu];
  Var.long_name     = 'latitute of U-points';
  Var.units         = 'degree_north';
  Var.standard_name = 'latitude';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.vlon;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yv did.xv];
  Var.long_name     = 'longitude of V-points';
  Var.units         = 'degree_east';
  Var.standard_name = 'longitude';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.vlat;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yv did.xv];
  Var.long_name     = 'latitute of V-points';
  Var.units         = 'degree_north';
  Var.standard_name = 'latitude';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

else

  Var.name          = Vname.rx;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yr did.xr];
  Var.long_name     = 'X-location of RHO-points';
  Var.units         = 'meter';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.ry;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yr did.xr];
  Var.long_name     = 'Y-location of RHO-points';
  Var.units         = 'meter';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.ux;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yu did.xu];
  Var.long_name     = 'X-location of U-points';
  Var.units         = 'meter';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.uy;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yu did.xu];
  Var.long_name     = 'Y-location of U-points';
  Var.units         = 'meter';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.vx;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yv did.xv];
  Var.long_name     = 'X-location of V-points';
  Var.units         = 'meter';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var

  Var.name          = Vname.vy;
  Var.type          = nc_constant('nc_double');
  Var.dimid         = [did.yv did.xv];
  Var.long_name     = 'Y-location of V-points';
  Var.units         = 'meter';
  [~,status]=nc_vdef(ncid,Var);
  if (status ~= 0), return, end,
  clear Var
  
end,

%--------------------------------------------------------------------------
%  Define initial conditions variables.
%--------------------------------------------------------------------------

Var.name            = Vname.time;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time];
Var.long_name       = 'time since initialization';
Var.units           = 'seconds';
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.zeta;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time did.yr did.xr];
Var.long_name       = 'free-surface';
Var.units           = 'meter';
Var.time            = Vname.time;
if (spherical),
  Var.coordinates   = strcat([Vname.rlon,' ',Vname.rlat,' ',Vname.time]); 
else
  Var.coordinates   = strcat([Vname.rx,' ',Vname.ry,' ',Vname.time]); 
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.ubar;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time did.yu did.xu];
Var.long_name       = 'vertically integrated u-momentum component';
Var.units           = 'meter second-1';
Var.time            = Vname.time;
if (spherical),
  Var.coordinates   = strcat([Vname.ulon,' ',Vname.ulat,' ',Vname.time]); 
else
  Var.coordinates   = strcat([Vname.ux,' ',Vname.uy,' ',Vname.time]); 
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.vbar;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time did.yv did.xv];
Var.long_name       = 'vertically integrated v-momentum component';
Var.units           = 'meter second-1';
Var.time            = Vname.time;
if (spherical),
  Var.coordinates   = strcat([Vname.vlon,' ',Vname.vlat,' ',Vname.time]); 
else
  Var.coordinates   = strcat([Vname.vx,' ',Vname.vy,' ',Vname.time]); 
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.u;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time did.Nr did.yu did.xu];
Var.long_name       = 'u-momentum component';
Var.units           = 'meter second-1';
Var.time            = Vname.time;
if (spherical),
  Var.coordinates   = strcat([Vname.ulon,' ',Vname.ulat,' ',            ...
                              Vname.s_rho,' ',Vname.time]); 
else
  Var.coordinates   = strcat([Vname.ux,' ',Vname.uy,' ',                ...
                              Vname.s_rho,' ',Vname.time]); 
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.v;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time did.Nr did.yv did.xv];
Var.long_name       = 'v-momentum component';
Var.units           = 'meter second-1';
Var.time            = Vname.time;
if (spherical),
  Var.coordinates   = strcat([Vname.vlon,' ',Vname.vlat,' ',            ...
                              Vname.s_rho,' ',Vname.time]); 
else
  Var.coordinates   = strcat([Vname.vx,' ',Vname.vy,' ',                ...
                              Vname.s_rho,' ',Vname.time]); 
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.temp;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time did.Nr did.yr did.xr];
Var.long_name       = 'potential temperature';
Var.units           = 'Celsius';
Var.time            = Vname.time;
if (spherical),
  Var.coordinates   = strcat([Vname.rlon,' ',Vname.rlat,' ',            ...
                              Vname.s_rho,' ',Vname.time]); 
else
  Var.coordinates   = strcat([Vname.rx,' ',Vname.ry,' ',                ...
                              Vname.s_rho,' ',Vname.time]); 
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

Var.name            = Vname.salt;
Var.type            = nc_constant('nc_double');
Var.dimid           = [did.time did.Nr did.yr did.xr];
Var.long_name       = 'salinity';
Var.time      = Vname.time;
if (spherical),
  Var.coordinates   = strcat([Vname.rlon,' ',Vname.rlat,' ',            ...
                              Vname.s_rho,' ',Vname.time]); 
else
  Var.coordinates   = strcat([Vname.rx,' ',Vname.ry,' ',                ...
                              Vname.s_rho,' ',Vname.time]); 
end,
[~,status]=nc_vdef(ncid,Var);
if (status ~= 0), return, end,
clear Var

%--------------------------------------------------------------------------
%  Leave definition mode and close NetCDF file.
%--------------------------------------------------------------------------

[status]=mexnc('enddef',ncid);
if (status == -1),
  disp('  ');
  disp(mexnc('strerror',status));
  error('C_INITIAL: ENDDEF - unable to leave definition mode.');
end,

[status]=mexnc('close',ncid);
if (status == -1),
  disp('  ');
  disp(mexnc('strerror',status));
  error(['C_INITIAL: CLOSE - unable to close NetCDF file: ', ncname]);
end

return

