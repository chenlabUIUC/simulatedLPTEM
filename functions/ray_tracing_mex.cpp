#include<iostream>
#include <cmath>
#include <set>
#include "eigen\Eigen/Dense"
#include "mex.hpp"
#include "mexAdapter.hpp"
using namespace Eigen;
using namespace std;

double triAreaCross(double pa[3], double pb[3],double pc[3]){
	double a[3] = {};
	double b[3] = {};
	for (int i=0;i<3;i++){
		a[i]=pa[i]-pb[i];
		b[i]=pc[i]-pb[i];
	}
	double c[3] = {a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]}; 
    double area=0;
    for (int i=0;i<3;i++){
		area+=pow(c[i],2);
	}
	area=0.5*sqrt(area);
	//printf("\narea is : %f\n",area);
	return area;
}


bool ray_mesh_intersection(double mesh[3][3], double p0[3], double u[3], double output[3]){
	
	double I[3]={0,0,0};
	double v0[3]={mesh[0][0],mesh[1][0],mesh[2][0]};
	double v1[3]={mesh[0][1],mesh[1][1],mesh[2][1]};
	double v2[3]={mesh[0][2],mesh[1][2],mesh[2][2]};
	double w[3],N=0,D=0;
	double a[3],b[3];
	
	for (int i=0;i<3;i++){
		w[i]=p0[i]-v0[i];
		a[i]=v1[i]-v0[i];
		b[i]=v2[i]-v1[i];
	}
	
	double n[3] = {a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]}; 
	for (int i=0;i<3;i++){
		D+=n[i]*u[i];
		N-=n[i]*w[i];
	}

	if (abs(D) < pow(10,-7) ) {				//The segment is parallel to plane
		  return 0;
          
    }      

	double sI = N / D;
	for (int i=0;i<3;i++){
		I[i]=p0[i]+sI*u[i];
	}

 	if (sI < 0 ){
 		return 0;
	 }

	double a0=triAreaCross(v0,v1,v2);
	double a1=triAreaCross(I,v1,v2);
	double a2=triAreaCross(v0,I,v2);
	double a3=triAreaCross(v0,v1,I);

if (abs(a1+a2+a3-a0)>0.01)
    return 0;

for (int i=0;i<3;i++){
		output[i]=I[i];
	}
return 1;
			
}



int ray_tracing(int RES, Matrix3f meshs[],int size,double * output){
	MatrixXf canvas = MatrixXf::Zero(RES,RES);	
	double u[3]={0,0,1};
	double p0[3]={0,0,-1000};
	double mesh[3][3]={};
	double recive[3]={};
	bool check=0;
	double h;
	int count;
	set<double,greater<double>> hs;  
	set<double>::iterator itr;
	for(int i=0;i<RES;i++){
		for(int j=0; j<RES;j++){
			hs.clear();
			for(int k=0; k<size;k++){
				p0[0]=i;p0[1]=j;		
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						mesh[m][n]=meshs[k](m,n);
					}
				}
			    check = ray_mesh_intersection(mesh,p0,u,recive);
			    if(check){
			    	hs.insert(recive[2]);
				}
			    
			}
		h=0;
		if(hs.size()==1) h=*(hs.begin());
		else if    (hs.size()>1){
			count=1;
			for (itr=hs.begin();itr!=hs.end();itr++){
				h+= (count%2)*(*itr)-(!(count%2))*(*itr);
			count++;
			}
		}
		canvas(i,j)=h;
	
		}
		
	}
	for(int i=0;i<RES;i++){
		for(int j=0; j<RES;j++){
			*(output+RES*j+i)=canvas(i,j);
			}
	}
}

class MexFunction : public matlab::mex::Function {
matlab::data::ArrayFactory factory;
public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
    double data[73];
	short RES;
	int(size);
	int n=1;
	
	matlab::data::TypedArray<double> inArray = inputs[0];
	size=(int)(inArray.getDimensions()[1]-1)/9;
    Matrix3f meshs[size];
    RES=(short)inArray[0];
	matlab::data::TypedArray<double> outArray=factory.createArray<double>({RES, RES});
	
	
	for (int i=0;i<size;i++){
		for(int j=0;j<3;j++){
			for(int k=0;k<3;k++){
				meshs[i](k,j)=inArray[n];
				n++;
			}
		}
	
	}
	
	double canvas[RES][RES] = {};
	ray_tracing(RES,meshs,size,&canvas[0][0]);

	for (int i=0;i<RES;i++){
		for (int j=0;j<RES;j++){
		outArray[i][j]=canvas[i][j];
		}
	}
	outputs[0]=outArray;
	}
};

