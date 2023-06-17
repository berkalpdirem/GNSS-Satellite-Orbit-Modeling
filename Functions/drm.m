function [Result] = drm(calculation_epoch,pseudorange,Relatedepoch_Clockcorrection,sat_paramets,R0rcv,ION_ALPHA,ION_BETA,TGD,selection)
format long g
c=2.99792458*10^8;   %Velocity of light for WGS84
Sat_cor=new_satpos(calculation_epoch,pseudorange,Relatedepoch_Clockcorrection,sat_paramets,R0rcv);
az_zen_slantd_Slat_Slong=local (R0rcv,Sat_cor);
%calculation epoch=20,4,1,21780
tgps=cal2gpstime(20,4,1,calculation_epoch);
az=az_zen_slantd_Slat_Slong(1,1);
az=deg2rad(az);

zen=az_zen_slantd_Slat_Slong(2,1);
elv=90-zen;
elv=deg2rad(elv);

Slat=az_zen_slantd_Slat_Slong(4,1);
Slong=az_zen_slantd_Slat_Slong(5,1);

dion=cal_klob(Slat,Slong,(elv),az,ION_ALPHA,ION_BETA,tgps);
%Emission time correction
dt=Emission_Time_nm(calculation_epoch,pseudorange,Relatedepoch_Clockcorrection)-(calculation_epoch-(pseudorange/c));
%Delays:
if selection==1
    D=c*dt+dion+c*TGD;
    Result=D;
elseif selection==0
    D=c*dt;
    Result=D;
else
    disp('-----------------------')
    disp('PLEASE WRÝTE 1 or 0!!!!')
    disp('-----------------------')
end
end


