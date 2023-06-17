function [Emission_Time_nm] = Emission_Time_nm(trcv,pseudorange,clock_corrections)
format long g
c=2.99792458*10^8;     %Velocity of light for WGS84(m/sec)


%----------------------------------------------------Emission_Time_Navigation Message----------------------------------------------------------------------------
Clock_corrections_eppoch=clock_corrections(1,1);
Clock_Bias=clock_corrections(1,2);          %Split the clock correction parameters
Clock_Dirft=clock_corrections(1,3);
Clock_Drift_Rate=clock_corrections(1,4);

t=trcv-(pseudorange/c);                         %My reception eppoch for Daily sec
t0=Clock_corrections_eppoch;          			%1 April's 06.00'seppoch for sattallite clock correction parameters from navigation massage for Daily sec

Emission_Time_correction_nm=Clock_Bias+Clock_Dirft*(t-t0)+Clock_Drift_Rate*(t-t0)^2;  %Calculations of the emission time correction from navigation message
Emission_Time_nm=trcv-(pseudorange/c)-Emission_Time_correction_nm;
end