function [Rsat_final] = new_satpos(calculation_epoch,pseudorange,Relatedepoch_Clockcorrection,sat_paramets,R0rcv)
We=7292115*10^-11;   %Earth's angular velocity for WGS84
c=2.99792458*10^8;   %Velocity of light for WGS84

EmmisionTimeNm=Emission_Time_nm(calculation_epoch,pseudorange,Relatedepoch_Clockcorrection);
TRS=navigation_message(EmmisionTimeNm,sat_paramets);
TRS=TRS';
%Applied for last correction with related parameters
deltat=(sqrt((TRS(1,:)-R0rcv(1,:))^2+(TRS(2,:)-R0rcv(2,:))^2+(TRS(3,:)-R0rcv(3,:))^2))/c;
Rsat_final=[cos(We*deltat) sin(We*deltat) 0 ; -sin(We*deltat) cos(We*deltat) 0 ; 0 0 1]*TRS;
end