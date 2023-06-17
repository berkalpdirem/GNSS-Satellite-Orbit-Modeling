
function [TRS_coordinates] = navigation_message(calculation_epoch,sat_paramets)
format long g
% I download 1 April's brdc.20n file and my PRN number is 22=(7+9+6).
% My calculations epoch 39790=((1+7+9+6)*1730)
% For my day second(39790) I select tenth hour  

% calculation_epoch=39790
% satallite_parameters =
% [0.340000000000D+02 -0.552187500000D+02 0.526379068658D-08 0.200340076059D+01
% -0.292062759399D-05 0.720023317262D-02 0.895746052265D-05 0.515353809166D+04 
% 0.295200000000D+06 0.102445483208D-06 -0.125091936140D+01 0.745058059692D-08 
% 0.929890972686D+00 0.192312500000D+03 -0.119443414136D+01 -0.821141346690D-08 
% 0.271439877989D-09 0.100000000000D+01 0.209900000000D+04 0.000000000000D+00 
% 0.200000000000D+01 0.000000000000D+00 -0.181607902050D-07 0.340000000000D+02
% 0.291680000000D+06 0.400000000000D+01 0.000000000000D+00 0.000000000000D+00]
  
IODE=sat_paramets(1,1);      %1-1, IODE (Issue of Data, Ephemeris)
crs=sat_paramets(1,2);       %1-2, Crs (meters). Amplitude of the sine harmonic correction term to the orbit radius
DeltaN=sat_paramets(1,3);    %1-3, Delta n (radians/sec. Mean motion difference from computed value
M0=sat_paramets(1,4);        %1-4, Mo (radians). Mean anomaly at reference time
cuc=sat_paramets(2,1);       %2-1, Cuc (radians). Amplitude of the cosine harmonic correction term to the argument of latitude
e=sat_paramets(2,2);         %2-2, e (unitless). Eccentricity
cus=sat_paramets(2,3);       %2-3, Cus (radians). Amplitude of the sine harmonic correction term to the argument of latitude
SqrtA=sat_paramets(2,4);     %2-4, sqrt(a) (sqrt(m)). Square root of the semi-major axis
TOE=sat_paramets(3,1);       %3-1, TOE. Time of Ephemeris (seconds into GPS week)
cic=sat_paramets(3,2);       %3-2, Cic (radians). Amplitude of the cosine harmonic correction term to the angle of inclination
Omega0=sat_paramets(3,3);    %3-3,OMEGA0. Longitude of ascending node of orbit plane at weekly epoch
cis=sat_paramets(3,4);       %3-4,Cis (radians). Amplitude of the sine harmonic correction term to the angle of inclination
i0=sat_paramets(4,1);        %4-1,io (radians). Inclination angle at reference time
crc=sat_paramets(4,2);       %4-2,Crc (meters). Amplitude of the cosine harmonic correction term to the orbit radius
Omega=sat_paramets(4,3);     %4-3,omega (radians).Argument of perigee
OmegaDot=sat_paramets(4,4);  %4-4,OmegaDot(radians/sec). Rate of right ascension
IDOT=sat_paramets(5,1);      %5-1,IDOT (radians/sec). Rate of inclination angle

a=(SqrtA)^2;                %Semi-major axis of ellipse
u=3.986005*10^14;           %Gravitional Constant
WE=7.2921151467*10^-5;      %Earth's angular velocity


%----------------------------Coordinate Calculations----------------------

                                     %Second of day = 39790=(23*1730)
t=calculation_epoch+259200;           %Gps week second = We have 259200=(3*24*60*60) second before 1 April  for Wps week                         
                                     %than we will add our second of day 


%--------------------------------------------------------------------------
tk=t-TOE;                             %Compute the time tk from ephemerides referance epoch Toe
%--------------------------------------------------------------------------
Mk=M0+(sqrt(u/a^3)+DeltaN)*tk;        %Compute mean anomaly
%--------------------------------------------------------------------------

e0=Mk;
while 1
   Ek=Mk+(e*sin(e0));
   if abs(Ek-e0)<10^-9
       e0=Ek;
       break                         %Solvng with iteration the kepler equations for the eccentric anomaly Ek
   else
       e0=Ek;
   end
end

%--------------------------------------------------------------------------

vk=atan2(((sqrt(1-e^2)*sin(Ek))/(1-e*cos(Ek))),((cos(Ek)-e)/(1-e*cos(Ek))));  %Compute the true anomaly Vk

%--------------------------------------------------------------------------
uk=Omega+vk+(cuc*cos(2*Omega+2*vk))+(cus*sin(2*Omega+2*vk));       %Compute the argument of latitude 
%--------------------------------------------------------------------------
rk=a*(1-e*cos(Ek))+(crc*cos(2*Omega+2*vk))+(crs*sin(2*Omega+2*vk));% Compute the radial distance
%--------------------------------------------------------------------------
ik=i0+IDOT*tk+(cic*cos(2*Omega+2*vk))+(cis*sin(2*Omega+2*vk));     %Compute the inclination ik of the orbital plane
%--------------------------------------------------------------------------
nk=Omega0+(OmegaDot-WE)*tk-WE*TOE;                                 %Compute the longitude of the ascending node nk
%--------------------------------------------------------------------------
R3nk=[cos(-nk) sin(-nk) 0 ; -sin(-nk) cos(-nk) 0 ; 0 0 1];
R1ik=[1 0 0 ; 0 cos(-ik) sin(ik) ; 0 -sin(-ik) cos(-ik)];  
R3uk=[cos(-uk) sin(-uk) 0 ; -sin(-uk) cos(-uk) 0 ; 0 0 1];        %Compute the coordinates in the TRS frame
Rk=[rk ; 0 ; 0];

TRS = R3nk*R1ik*R3uk*Rk;
TRS_coordinates=transpose(TRS);
end



                                                            







