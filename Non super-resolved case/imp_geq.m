

%This file shows an example of how to call the function sensing_geq.m
close all
clear
Delta_c=[1,0.5]; 
Delta_d=1; %This means that relation between the coded aperture pitch size and
%the detector pitch size is 1/Delta_c(arbitraty units)
 
M=128; %Detector size 128 x 128%
N=128;

s_m=[0.1,0.4,0.9;0.6,0.8,0.9];
for i=1:length(Delta_c)
   
    t= randi([0 1], [128/Delta_c(i),128/Delta_c(i)]); %Noitce that teh coded aperture must have 1/Delta_c x
    %1/Delta_c more elements than the detector pitch size
  

    alpha_lambda_min=0; %the smallest wavelength impinges on the left most part
    %of the coded aperture
    alpha_lambda_max=128; %the biggest wavelength impinges on the right most part
    %of the coded aperture
    for j=1:size(s_m,2) 
        s=s_m(i,j); %Notice that in all cases Deta_c/(1-s)>Delta_d
        [g,band,H]=sensing_geq(Delta_c(i),Delta_d,M,N,t,alpha_lambda_min,alpha_lambda_max,s);
        figure
        suptitle(strcat('Results for s= ', num2str(s),' and \Delta_c= ',num2str(Delta_c(i))));
        subplot(1,3,1);
        imshow(g,[]); %projection of the coded aperture onto the sensor
        title('Projected pattern to the sensor');
     
        subplot(1,3,2);
        imshow(band(:,:,1),[]); %first band
        title('Pattern corresponding to the first band');
        
        subplot(1,3,3);
        imshow(band(:,:,end),[]); %last band
        title('Pattern corresponding to the last band');
       
    end
     clearvars -except s_m M N Delta_c Delta_d

end
