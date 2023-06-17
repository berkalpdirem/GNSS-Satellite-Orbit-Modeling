function [dion] = cal_klob(lat,lon,elv,azm,alfa,beta,tgps)
% This function compute the ionospheric slant delay for GPS code
% measeurement in L1 signal
% Inputs
% lat  : geodetic latitude (radian) from approximate coordinates in the observation file
% lon  : geodetic longitude(radian) from approximate coordinates in the observation file
% elv  : elevation angle   (radian) for the related satellite
% azm  : azimuth angle     (radian) for the related satellite
% alfa : Klobuchar coefficients (sec sec/semicircle sec/semicircle2 sec/semicircle3) 
% beta : Klobuchar coefficients (sec sec/semicircle sec/semicircle2 sec/semicircle3)
% tgps : gps time (seconds of week) is calculated using "cal2gpstime.m" function at the emission time of related satellite
% Output
% dion : ionospheric slant delay (meter)
% Reference
% GNSS Data Processing, Vol. I: Fundamentals and Algorithms (ESA TM-23/1, May 2013)

% velocity of light
c = 299792458; %m/s
% calculate the Earth-centred angle
Re = 6378; %km
h  =  350; %km
cns = (Re/(Re + h))*cos(elv); 
eca = pi/2 - elv - asin(cns); % rad
% compute the latitude of IPP
ax = sin(lat)*cos(eca) + cos(lat)*sin(eca)*cos(azm);
lat_ipp = asin(ax); % rad
% compute the longitude of IPP
lon_ipp = lon + (eca*sin(azm))/(cos(lat_ipp));
% Find the geomagnetic latitude of the IPP
f_pol = deg2rad(78.3);% rad
l_pol = deg2rad(291);% rad
as = sin(lat_ipp)*sin(f_pol) + cos(lat_ipp)*cos(f_pol)*cos(lon_ipp-l_pol);
geo = asin(as);
% Find the local time at the IPP
t = 43200*(lon_ipp/pi) + tgps;
t = mod(t,86400.);                    % Seconds of day
if t>=86400
    t = t - 86400;
elseif t<=0
    t = t + 86400;
end

tsd = geo/pi;
AI = alfa(1) + alfa(2)*tsd + alfa(3)*(tsd^2) + alfa(4)*(tsd^3);%seconds
PI = beta(1) + beta(2)*tsd + beta(3)*(tsd^2) + beta(4)*(tsd^3);%seconds
if AI<0
    AI = 0;
end
if PI<72000
    PI = 72000;
end

% Compute the phase of ionospheric delay
XI = (2*pi*(t - 50400))/PI; %radian
% Compute the slant factor (ionospheric mapping function)
F = (1 - cns^2)^(-1/2);
% Compute the ionospheric time delay
if abs(XI)<(pi/2)
    I1 = (5*10^-9 + AI*cos(XI))*F;
elseif abs(XI)>=(pi/2)
    I1 = (5*10^-9)*F;
end

dion = I1*c;
end