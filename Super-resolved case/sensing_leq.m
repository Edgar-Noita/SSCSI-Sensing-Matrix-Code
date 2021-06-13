%%%%
%This routuine calculates the sensing matrix according to the
%analysis done in Salazar et. al "Spectral Zooming and Reoslution Limits
%of spatial spectral compressive spectral imagers".
%For the case when Delta_c/(1-s)<Delta_d (superrresolution scenarario).
%Please refer to Eq. (18) of mentione paper for futher details. 

%%%%
%REQUIRTED INPUTS:
%Delta_c: Coded aperture size respect to the sensor size

%Delta_d: Generally 1, since it is the length reference

%M x N: Size of the detector

%t: Coded aperture

%alpha_lambds_min: Location of first spectral band with respect to the
%sensor size
%alpha_lambda_max: Location of last spectral band with respect to the
%sensor size

%s: Coded aperture position.

%%%%
%OUTPUS:
%g: M x N matrix that give the projection of the code on the sensor

%band: M*(Delta_d/Delta_c) x ceil(N*(Delta_d/Delta_c)*(1-s)) x L matrix
%containing the coding pattern for each band

%H: Forwarded Matrix H of the model

function [g,band,H]=sensing_leq(Delta_c,Delta_d,M,N,t,alpha_lambda_min,alpha_lambda_max,s)

g=zeros(M,N); %initilization of g
L=ceil((alpha_lambda_max-alpha_lambda_min)*s/Delta_c); %Calculation of number of bands according to Eqs. (17) and (20)

%Size of the recovered image. 
M_im=M/Delta_c; 
N_im=nextpow2(ceil((Delta_d/Delta_c)*N*(1/1-s))); %This is done in order to have a power of 2 image size
N_im=(2^N_im); 


acum=1; %Auxiliar variables used to the emsamble the H matrix
pos_sensor=[];
pos_image=[];
val=[];
band=[];

for k=0:L-1
    alpha_lambda=alpha_lambda_min+k*(Delta_c/s); %position of the band kth band with respect to teh code
    
    for m=0:M-1
        m_pd=floor(roundn((m*Delta_d*(1-s)+s*alpha_lambda)/(Delta_c),-5)); %Calculation of the limits of the summation over x given in equation (18) of the paper
        m_pu=floor(roundn(((m+1)*Delta_d*(1-s)+s*alpha_lambda)/(Delta_c),-5)); %round(x,-5) is used to avoid errors in the floor process
    
        offset=floor(roundn((s*alpha_lambda)/(Delta_c),-4));%Variable that has into account the shifting process of the bands to concatenate the codes
        
        for n=0:N-1
            n_pd=n*Delta_d/Delta_c; % Calculation of the limits of summation over the Y dimension, given in the equation (18)
            n_pu=(n+1)*Delta_d/Delta_c-1;
       
        for m_p=m_pd:m_pu
           
            if m_p==m_pd %Calculation of the W_(m,m') variables according to the logic given in Eq. (12) of the paper 
                    Wp=(((m_p+1)*Delta_c-s*alpha_lambda)/(1-s)-m*Delta_d)/(Delta_c/(1-s));
                  
                else
                    if m_p==m_pu
                       Wp=((m+1)*Delta_d-((m_p)*Delta_c-s*alpha_lambda)/(1-s))/(Delta_c/(1-s));
                     
                    else
                        Wp=1; 
                    end                
            end
            
             
             for n_p=n_pd:n_pu
                
                 pos_sensor(acum)=(n+1)+(m)*N; %Postion of the sensor in the H matrix
                 pos_image(acum)=(n_p+1)+(m_p-offset)*N_im +k*N_im*M_im; %Position of the voxel in the H matrix
                 val(acum)=Wp*t(n_p+1,m_p+1); %Value of the element in the H matrix
                 g(n+1,m+1)=g(n+1,m+1)+Wp*t(n_p+1,m_p+1); %Sensor measurements
                 band(n_p+1,m_p+1-offset,k+1)=t(n_p+1,m_p+1);% Coded aperture for each band
                 acum=acum+1; 
             end
        end
        end
    end   
end
pos_image(end+1)=N_im*M_im*L; %Creation of the Sparse forwarded matrix, dimensions N*M x N_im*M_im*L
pos_sensor(end+1)=N*M;
val(end+1)=0;
H=sparse(pos_sensor,pos_image,val);    