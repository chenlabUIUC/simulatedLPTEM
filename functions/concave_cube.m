function out=concave_cube(Edge,dispersity,RES,sim_scale)
a=0.5;
s=0.7;sa=s*a;
M(:,:,1)=[[a,a,sa],
          [a,-a,0],
          [a,a,0]];
M(:,:,2)=[[a,a,0],
          [a,-a,0],
          [a,a,sa]];
M(:,:,3)=[[a,-a,0],
          [a,a,sa],
          [a,a,0]];
M(:,:,4)=[[a,-a,0],
          [a,a,0],
          [a,a,sa]];
M(:,:,5)=[[-a,-a,-sa],
          [a,-a,0],
          [a,a,0]];
M(:,:,6)=[[-a,-a,0],
          [a,-a,0],
          [a,a,sa]];
M(:,:,7)=[[-a,a,0],
          [-a,-a,-sa],
          [a,a,0]];
M(:,:,8)=[[-a,a,0],
          [-a,-a,0],
          [a,a,sa]];
M(:,:,9:16)=M(:,:,1:8);
M(3,:,9:16)=-M(3,:,9:16);
M(:,:,17)=[[a,a,sa],
          [a,a,0],
          [a,-a,0]];
M(:,:,18)=[[a,a,0],
          [a,a,sa],
          [a,-a,0]];
M(:,:,19)=[[-a,-a,0],
          [a,a,sa],
          [a,-a,0]];  
M(:,:,20)=[[-a,-a,-sa],
          [a,a,0],
          [a,-a,0]];       
M(:,:,21)=[[-a,-a,-sa],
          [-a,-a,0],
          [a,-a,0]];  
M(:,:,22)=[[-a,-a,0],
          [-a,-a,-sa],
          [a,-a,0]];        
M(:,:,23)=[[a,a,sa],
          [-a,-a,0],
          [a,-a,0]];  
M(:,:,24)=[[a,a,0],
          [-a,-a,-sa],
          [a,-a,0]];  
      
Edge =normrnd(Edge ,Edge*dispersity);
M=M.*Edge;%every thing in nm     
M=M./sim_scale;%nm->px     
theta = rand()*360;
RX = [1           0            0;
     0 cosd(theta) -sind(theta);
     0 sind(theta)  cosd(theta)];
theta = rand()*360;
RY = [cosd(theta) 0  sind(theta);
     0 1 0;
     -sind(theta) 0  cosd(theta)];
theta = rand()*360;
RZ = [cosd(theta) -sind(theta) 0;
     sind(theta)  cosd(theta) 0;
     0 0 1];      
for k = 1:24
    %M(:,:,k)=(M(:,:,k)'*RX)';
    %M(:,:,k)=(M(:,:,k)'*RY)';
    M(:,:,k)=(M(:,:,k)'*RZ)';
    M(1:2,:,k)=M(1:2,:,k)+RES/2;
end
      

package=cat(2,RES, reshape(M,size(M(:)')));
canvas=ray_tracing_mex(package);
out=canvas*sim_scale;
%imshow(out-min(out(:)))/(max(out(:))))
end
