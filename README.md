# GNSS-Satellite-Orbit-Modeling
3rd Term GNSS Final Project

Before the starting project code I controled my sub function(previous homeworks). I deleted all sp3 file inputs from my sub funcitons.Because of that I didn’t work sp3 file.I change the functions’s inputs for work with brdc file’s inputs.I wrote a new satpos function without lagrange interpolation.

![image](https://github.com/berkalpdirem/GNSS-Satellite-Orbit-Modeling/assets/48286863/9d77915e-e3df-470c-8dab-0326550ff108)

After the this function I ran the my local function and got the azimuth,zenith,latitude and longitude. With this information I put the this variables to cal_klop function with call2gpstime function and got the ionosphere delay.Than I got the emission time correction with multiplication with velocity of light lastly I got the total group delay with multiplication with velocity of light. I ignore the troposphere delay. As a result I added all finding delays and I found d :
For these funciton correcitons my sub functions were ready.
For my main script file firstly I entered my related inputs. Than I put the these inputs to structure arrays. My related satellites are : G04 G05 G07 G08 G09 G13 G27 G28 G30
My epoch is (2+1+4+3+1+7+9+6)*660. It is approximate equal 06.03.Than I should the take 06.00 ‘s inputs.I embeded the these inputs to structure arrays.
Than I assign 0 value for I want to find result. After that I created empty arrays for to fill at for loop. The continuation I create a loop for enter my all satallite’s inputs. Firstly I call my drm function.With this function I calculated delay. Than I called my new satpos funciton and got the my satallites coordinates. With this informations I started the build least square matrix. Firstly I build p0:

![image](https://github.com/berkalpdirem/GNSS-Satellite-Orbit-Modeling/assets/48286863/e2ae629f-7af3-43e6-8201-e1d7e34b07b1)

Our x,y and z coordinates will be my want to find receiver coordinates. But I entered the 0 value for they and I will iterated these coordinates. Xj,Yj and Zj are my satallite coordinates.Than I create L and A matrix for build least square.

![image](https://github.com/berkalpdirem/GNSS-Satellite-Orbit-Modeling/assets/48286863/0e8e19d0-eeda-47e2-ad05-56f462fa22fc)

With this structure I could get the vector of unknown parameters and got the dx,dy ,dz and receiver clock error before iteration.Than I create a iteration and it’s treshold ia 10^-3 for dx,dy,dz.

![image](https://github.com/berkalpdirem/GNSS-Satellite-Orbit-Modeling/assets/48286863/ab3da431-2507-4950-bb0e-eabc6f00d9ab)

Firstly I identified x0,y0 and z0 from dx,dy,dz inside the iteration.Than I created new empty L and A matrix. After that I start a for loop for add my all satallite observations with p0 and delays.After the for loop I create a new least square matrix with this new values. Than I controled the dx,dy,dz. If they are upper the 0.001 meter; itereation start again and put the new x0 y0 z0 value to start positon. Also p0 and L,A matrix created with these new x0,y0 and z0 values.
Finaly when dx,dy and dz under the my 0.001 threshold my x0,y0 and z0 values will be my receiver coordinates.
My code work with 2 differente part one of is using ionphere delay and using TGD other one is don’t use them. For this difference paths you should select one of them.

![image](https://github.com/berkalpdirem/GNSS-Satellite-Orbit-Modeling/assets/48286863/df1ef8f1-d00d-43e5-89d1-eb37b94a4267)

For first path(using ionosphere model and using TGD) my results:

![image](https://github.com/berkalpdirem/GNSS-Satellite-Orbit-Modeling/assets/48286863/f77b6ecb-8b66-4606-a1c3-c7a49f8b9784)

For second path(without ionosphere model and using TGD) my results:

![image](https://github.com/berkalpdirem/GNSS-Satellite-Orbit-Modeling/assets/48286863/86681f76-edf7-45de-b5d3-59db4960d670)

