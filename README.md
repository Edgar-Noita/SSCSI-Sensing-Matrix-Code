# SSCSI-Sensing-Matrix-Code

This repository allows the user to access an create the SSCSI sensing matrix for the different cases studied in detail in "Salazar et al. Spectral zooming and resolution limits of spatial spectral compressive spectral imagers". Please cite this if used.

A detailed explanation of the files can be found next:

sensing_leq.m: Function that models the sensing process for super-resolved problems (Eq. 18 of reference paper)

imp_leq.m: File that implements sensing_leq.m. Notice that Delta_c/(1-s)<Delta_d, and Delta_d is an integer multiple of Delta_d

sensing_geq.m: Function that models the sensing process for non-super-resolved problems (Eq. 19 of reference paper)

imp_geq.m: File that implements sensing_leq.m. Notice that Delta_c/(1-s)>Delta_d, and Delta_d is an integer multiple of Delta_d.

If you want to have access to the hyperspectral data, please contact the author.

# SSCSI Summary

Figure Below shows the SSCSI and the CASSI architectures. The figure was extrated from the reference paper. In SSCSI, the information arrives at the gray scale sensor in focus and the coding process depends on 2 parameters: the position of the mask with respect to the sensor and the dispersion process given by the grating.
![Alt text](https://github.com/Edgar-Noita/SSCSI-Sensing-Matrix-Code/blob/main/git_1.png "Title")


The forwarded model matrix has the shape as depicted below. The figure was extrated from the reference paper.

