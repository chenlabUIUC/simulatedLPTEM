# TEM-simulation
written by Lehan Yao  
This code package is developed to generate synthetic liquid phase TEM images.  
Current version: 1.0
Date: 3/2020
For more information about the project, algorithms, and related publications please refer to the [Chen Group website](https://chenlab.matse.illinois.edu/).

Reference
---------------
If you find our statistical approach useful for analyzing your data, please cite: Z. Ou, L. Yao, H. An, B. Shen, Q. Chen. Nat. Commun. (2020).

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
