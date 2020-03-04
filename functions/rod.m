function out=rod(RES,scale)      %RES,scale                  
%RES=500;
%scale=98.62/512;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len0=[0 45];                                          %%%%
radius0=[2.2 7.5];                                      %%%%  nm  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len=len0/scale;
radius=radius0/scale;

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

r1=radius(1)+rand()*(radius(2)-radius(1));
r2=r1-0.1+rand()*r1*0.2;
sphere1=sphereProtype*r1;
sphere2=sphereProtype*r2;


leng=len(1)+rand()*min([len(2),6*max([max(sphere2(:)),max(sphere1(:))])]);

sphere1=sphere1+leng/2*[ones(length(sphere1),1),zeros(length(sphere1),1),zeros(length(sphere1),1)]';
sphere2=sphere2-leng/2*[ones(length(sphere1),1),zeros(length(sphere1),1),zeros(length(sphere1),1)]';

T=[sphere1,sphere2];
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
end
package=cat(2,RES, reshape(mesh,[1 length(mesh(:))]));
canvas=ray_tracing_mex(package);
%imshow(canvas/max(canvas(:)));
out=canvas*scale;
end
