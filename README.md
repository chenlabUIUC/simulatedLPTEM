# simulatedLPTEM
This code package is developed to generate simulated liquid-phase TEM images as the training dataset for machine learning based liquid-phase TEM movie segmention.  
Current version: 1.0  
Date: 3/2020  
For more information about the project, algorithms, and related publications please refer to the [Chen Group website](https://chenlab.matse.illinois.edu/).

Reference
---------------
If you find our approach useful, please cite: L. Yao, Z. Ou, B. Luo, C. Xu, Q. Chen, "Machine-learning based segmentation of liquid-phase TEM videos to map interaction landscape, anisotropic etching, and self-assembly of nanoparticles" sumbitted (2020)

Getting started
---------------
The following steps should be executed only once (installation):  
(Matlab version: R2019a)  
1. go to "/functions" and extract "eigen.zip" to "functions/eigen/"  
2. open Matlab and redirect to "/functions".  
3. use Matlab to compile 3 cpp/c files in "/functions" by typing commands:  
   mex InPolygon.c  
   mex rasterization_mex.cpp  
   mex ray_tracing_mex.cpp  
   (if you don't have a compiler in Matlab, go to Add-Ons, search and install "MinGW-w64 C/C++ compiler")  
   
To run the program:  
1. open "simulation.mlapp" in Matlab  
2. click "run" and the user interface (UI) will jump out  
3. select "prism" in "model" in UI and click "preview" to enjoy the example  

Note
---------------
The program reads ".mat" files from "/MTF data" as MTF of the simulated images. Example MTF data is provided. To generate your own MTF data, replace the image(s) in "MTF maker/MTF sample images" with your own noise image(s) and run the script "MTF maker/MTF_maker.m".  
The generated MTF data is stored in "MTF maker/" and named with "MTFmatrixXXX.mat". It should be copied to "MTF data/" to be used by the simulation program.  

Revisions
---------------
