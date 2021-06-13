%%%%
%This routuine calculates the sensing matrix according to the
%analysis done in Salazar et. al "Spectral Zooming and Reoslution Limits
%of spatial spectral compressive spectral imagers".
%For the case when Delta_c/(1-s)>Delta_d (Non Superresolved scenarario).
%Please refer to Eq. (19) of mentione paper for futher details. 

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
function [g,band,H]=sensing_geq(Delta_c,Delta_d,M,N,t,alpha_lambda_min,alpha_lambda_max,s)

acum=1; %auxiliar variable used to emsamble the matrix H
L=ceil((alpha_lambda_max-alpha_lambda_min)*s/Delta_c); %Number of bands according to Eqs. (17) and (20)
g=zeros(M,N); %initilization of g

 %Size of the recovered image
M_im=M/Delta_c;
N_im=N;

for k=0:L-1
    alpha_lambda=alpha_lambda_min+k*(Delta_c/s); %position of the band
for m=0:M-1
    
    offset=floor(roundn((s*alpha_lambda)/(Delta_c),-4)); %variable that has into account the shifting process between bands

    m_p=floor(roundn((m*Delta_d*(1-s)+s*alpha_lambda)/Delta_c,-5))+1; %Calculation of the limits of the summation over x given in equation (19) of the paper
    lim=roundn((m_p*Delta_c-s*alpha_lambda)/(1-s),-5); 
    
    if ((m+1)*Delta_d<=lim) %Calculation of P paramter according to Eq (14)
        p=1;
    else
        p=(lim-(m)*Delta_d)/Delta_d; 
    end
   
    for n=0:N-1
        n_pd=n*Delta_d/Delta_c; % Calculation of the limits of summation over the Y dimension, given in the Eq. (19)
        n_pu=(n+1)*Delta_d/Delta_c-1;
     for n_p=n_pd:n_pu

        if m_p==alpha_lambda %Calculation of the effective coded aperture according to Eq. 17 of the paper
           band(n_p+1,m+1,k+1)=t(n_p+1,m_p+1)*(p);
        else
            
            if (m_p>=M_im) 
               band(n_p+1,m+1,k+1)=t(n_p+1,m_p-1+1)*(p);
            else    
             
                band(n_p+1,m+1,k+1)=t(n_p+1,m_p-1+1)*(p)+t(n_p+1,m_p+1)*(1-p); 
            end
        end
        
          pos_sensor(acum)=(n+1)+m*M; %emsambling the H matrix
          pos_image(acum)=(n_p+1)+(m-offset)*M_im +k*N_im*M_im; 
          val(acum)=band(n_p+1,m+1,k+1);
          g(n+1,m+1)=g(n+1,m+1)+band(n_p+1,m+1,k+1);
          acum=acum+1;
     end
    end
end
end
pos_image(end+1)=N_im*M_im*L; %Creation of the Sparse forwarded matrix, dimensions N*M x N_im*M_im*L
pos_sensor(end+1)=N*M;
val(end+1)=0;
H=sparse(pos_sensor,pos_image,val);    
         