function out=rice(RES,scale)                        
%RES=128;
%scale=601/1024;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len0=84.02078721;       len0_std=3.102596081;         %%%%
radius0=4.907940558;    radius0_std=0.31262022;       %%%%  nm
wid0=30.70825;          wid0_std=1.049264165;         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len=len0/scale;len_std=len0_std/scale;                
radius=radius0/scale;radius_std=radius0_std/scale;           
wid=wid0/scale;wid_std=wid0_std/scale;  

forced_len_std=len*0.1;%%%%%%%%
forced_wid_std=wid*0.1;%%%%%%%%%
wid=normrnd(wid,forced_wid_std);
%len=normrnd(len,len_std);
len=normrnd(len,forced_len_std);


r=wid/1.9;
center_plane=[[0 0           0           0           0          ],
              [0 r*cosd(18)  r*cosd(54) -r*cosd(54) -r*cosd(18) ],
              [r r*sind(18) -r*sind(54) -r*sind(54)  r*sind(18) ]];

r=1;
th = 0:pi/8:2*pi;
x = r * cos(th);
y = r * sin(th);
circle0=[x',y',zeros(length(x),1)]';    
sphereProtype=[];
for theta = 0:180/8:360;
R = [cosd(theta) 0  sind(theta);
     0 1 0;
     -sind(theta) 0  cosd(theta)];
    %disp(theta)
    circle=(circle0'*R)';
    sphereProtype=[sphereProtype,circle];
end

sphere1=sphereProtype*normrnd(radius,radius_std);
sphere2=sphereProtype*normrnd(radius,radius_std);

sphere1=sphere1+len/2*[ones(length(sphere1),1),zeros(length(sphere1),1),zeros(length(sphere1),1)]';
sphere2=sphere2-len/2*[ones(length(sphere1),1),zeros(length(sphere1),1),zeros(length(sphere1),1)]';

T=[sphere1,sphere2,center_plane];
%scatter3(T(1,:),T(2,:),T(3,:));

	
theta = rand()*360;

R = [1           0            0;
     0 cosd(theta) -sind(theta);
     0 sind(theta)  cosd(theta)];
T=(T'*R)';

R = [cosd(theta) 0  sind(theta);
     0 1 0;
     -sind(theta) 0  cosd(theta)];
%T=(T'*R)';
theta = rand()*360;
R = [cosd(theta) -sind(theta) 0;
     sind(theta)  cosd(theta) 0;
     0 0 1];
T=(T'*R)';
T(1,:)=T(1,:)+RES/2;
T(2,:)=T(2,:)+RES/2;
X=convhull(T(1,:),T(2,:),T(3,:));

for k = 1:length(X)
	mesh(:,:,k)=[T(1,X(k,:)')',T(2,X(k,:)')',T(3,X(k,:)')']';
	nor(k,:)=normal(mesh(:,:,k));
end
package=cat(2,RES, reshape(mesh,[1 length(mesh(:))]));
canvas=ray_tracing_mex(package);
%imshow(canvas/max(canvas(:)));
out=canvas;
end
