function out=rod_rasterization(RES,scale)      %RES,scale                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len0=[4 45];                                          %%%%
radius0=[2.2 7.5];                                    %%%%  nm  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len=len0/scale;
radius=radius0/scale;

r=1;
th = -pi/2:pi/20:pi/2;
x = r * cos(th);
y = r * sin(th);
circle0=[x',y',zeros(length(x),1)]';    
sphereProtype=[];
for theta = -90:180/12:90
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

sphereProtype(1,:) = -sphereProtype(1,:);
sphere2=sphereProtype*r2;


leng=len(1)+rand()*min([len(2),6*max([max(sphere2(:)),max(sphere1(:))])]);

sphere1=sphere1+leng/2*[ones(length(sphere1),1),zeros(length(sphere1),1),zeros(length(sphere1),1)]';
sphere2=sphere2-leng/2*[ones(length(sphere1),1),zeros(length(sphere1),1),zeros(length(sphere1),1)]';

T=[sphere1,sphere2];
%scatter3(T(1,:),T(2,:),T(3,:));

	
theta = 00;%rand()*360;

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
T(1:2,:)=T(1:2,:)+RES/2;
T=T';

[k,~] = convhull(T);
%figure(1);
%hold on
for i = 1:length(k)
	mesh(:,:,i)=[T(k(i,1),:);T(k(i,2),:);T(k(i,3),:)];
    %fill3(mesh(:,1,i)',mesh(:,2,i)',mesh(:,3,i)',1);
	%nor(i,:)=normal(mesh(:,:,i)');
end
%{
%axis equal
vs =[];
ts = [];

v1s=zeros([length(k),2]);
v2s=v1s;
v3s=v1s;
for i = 1: length(k)
    v1s(i,:) = [mesh(1,1,i),mesh(1,2,i)];
    v2s(i,:) = [mesh(2,1,i),mesh(2,2,i)];
    v3s(i,:) = [mesh(3,1,i),mesh(3,2,i)];
end

inds1 = zeros([length(k),size(mesh,3)]);
inds2 = inds1;
inds3 = inds1;
mesh_s = permute(mesh,[1 3 2]);
mesh_x = mesh_s(:,:,1);
mesh_y = mesh_s(:,:,2);
xmin = min(mesh_x);
xmax = max(mesh_x);
ymin = min(mesh_y);
ymax = max(mesh_y);
for i = 1: length(k)
    inds1(i,:) = ((v1s(i,1)>=xmin) & (v1s(i,1)<=xmax) & (v1s(i,2)<=ymax) & (v1s(i,2)>=ymin));
    inds2(i,:) = ((v2s(i,1)>=xmin) & (v2s(i,1)<=xmax) & (v2s(i,2)<=ymax) & (v2s(i,2)>=ymin));
    inds3(i,:) = ((v3s(i,1)>=xmin) & (v3s(i,1)<=xmax) & (v3s(i,2)<=ymax) & (v3s(i,2)>=ymin));
end
for i = 1: length(k)
    v1 = [mesh(1,1,i),mesh(1,2,i)];
    t1 = thickness(v1,mesh,nor,inds1(i,:));
    v2 = [mesh(2,1,i),mesh(2,2,i)];
    t2 = thickness(v2,mesh,nor,inds2(i,:));
    v3 = [mesh(3,1,i),mesh(3,2,i)];
    t3 = thickness(v3,mesh,nor,inds3(i,:));
    vs = [vs;v1;v2;v3];
    ts = [ts;t1;t2;t3];
end
%}  

    mesh = reshape(permute(mesh,[1 3 2]),[length(mesh)*3 3]);
    mesh_t = mesh';
    ts = rasterization_mex(mesh_t(:)');
    [Xq,Yq] = meshgrid(1:1:RES);
    %scatter3(vs(:,1),vs(:,2),ts)
    out = griddata(mesh(:,1),mesh(:,2),ts,Xq,Yq);
    out(isnan(out)) = 0;
    out=out*scale;
    %figure(2)
    %imshow(out./max(out(:)))
end

function t = thickness(point,mesh,nor,inds)
    I = [];
    for i = 1 : size(mesh,3)
        if (inds(i))
            [I_tmp,check] = plane_line_intersect(nor(i,:),mesh(:,:,i)',[point -10000],[0 0 1]);
            if check==1
                %scatter3(I_tmp(:,1),I_tmp(:,2),I_tmp(:,3),200,'r');
                %drawnow
                I=cat(1,I,I_tmp);
            end
        end
    end
    if I
    	ma=max(I(:,3));
    	mi=min(I(:,3));
    	t=ma-mi;
    else
        t =0;
    end
end