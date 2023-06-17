function [az_zen_slantd_Slat_Slong] = local(R0rcv,cart)
plh=xyz2plh(R0rcv);
lat=rad2deg(plh(1,1));
long=rad2deg(plh(2,1));
h=plh(3,1);
deltaX=cart-R0rcv;
A=[-sind(lat)*cosd(long) -sind(long) cosd(lat)*cosd(long);
   -sind(lat)*sind(long)   cosd(long) cosd(lat)*sind(long);
          cosd(lat)            0             sind(lat)   ];
local_cor=(A')*deltaX;
local_x=local_cor(1,1);
local_y=local_cor(2,1);
local_z=local_cor(3,1);

slantd=sqrt(local_x^2 + local_y^2 + local_z^2)/1000;%Slant distance'unit km 
az=rad2deg(atan2(local_y,local_x));
zen=rad2deg(acos(local_z/(slantd*1000))); %For this calculation slant distance should be meter

sat_lat_long=xyz2plh(cart);
sat_lat=(sat_lat_long(1,1));
sat_long=(sat_lat_long(2,1));


az_zen_slantd_Slat_Slong=[az;zen;slantd;sat_lat;sat_long];

end