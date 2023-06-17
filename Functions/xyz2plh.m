function[ellp]=xyz2plh(cart)
cart_x=cart(1,1);
cart_y=cart(2,1);
cart_z=cart(3,1);
%semimajor axis of the Earth(meters)(WGS 84)
a=6378137.0;
%Flattening of the Earth(WGS 84)
f=1/298.257223563;
%eccentricity(WGS 84)
e=sqrt(2*f-f^2);
%Iteration calculations for lat,long,h
h=0;
long=atan2(cart_y,cart_x);
lat=atan2(cart_z/sqrt(cart_x^2+cart_y^2),1-e^2);
while true
    lati=lat;
    N=a/(sqrt(1-(e^2)*(sin(lat)^2)));
    h=(sqrt(cart_x^2+cart_y^2))/cos(lat)-N;
    lat=atan2(cart_z/sqrt(cart_x^2+cart_y^2),1-(N/(N+h)*e^2));
    if  abs(lati-lat)<10^-12
        break
    end
end
ellp=[lat;long;h];
end

