function out=sphere(sz,dispersity,RES,Sim_scale)                        
Radius=sz/2; 
Radius =normrnd(Radius, Radius*dispersity);%nm
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
    circle=(circle0'*R)';
    sphereProtype=[sphereProtype,circle];
end
T=sphereProtype*Radius;%nm
theta = rand()*360;
R = [1           0            0;
     0 cosd(theta) -sind(theta);
     0 sind(theta)  cosd(theta)];
T=(T'*R)';
theta = rand()*360;
R = [cosd(theta) -sind(theta) 0;
     sind(theta)  cosd(theta) 0;
     0 0 1];
T=(T'*R)';

T=T/Sim_scale;%nm->px
T(1,:)=T(1,:)+RES/2;
T(2,:)=T(2,:)+RES/2;

X=convhull(T(1,:),T(2,:),T(3,:));
for k = 1:length(X)
	mesh(:,:,k)=[T(1,X(k,:)')',T(2,X(k,:)')',T(3,X(k,:)')']';
end
package=cat(2,RES, reshape(mesh,[1 length(mesh(:))]));
canvas=ray_tracing_mex(package);
out=canvas*Sim_scale; %px->nm
end
