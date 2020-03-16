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
The following steps should be executed:  
(Matlab version: R2019a)  
1. extract "functions/eigen.zip" to "functions/eigen/"
2. use Matlab to compile 3 cpp or c files in "functions"
3. run "simulation.mlapp" 

Note
---------------
To generate your own MTF, replace the video/image in "MTF maker/MTF_concavecube.m" and run the script  
The generated MTF data should be copied to "MTF data/"  

Revisions
---------------
