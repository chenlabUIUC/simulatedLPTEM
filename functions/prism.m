function out=prism(Edge0,disperse,thickness,RES,Sim_scale)
T=[[-0.866 0.866 0]',[-0.5 -0.5 1]'];
Egde_protype=1.732; 
Edge =normrnd(Edge0, Edge0*disperse);
thickness=thickness+thickness*((Edge-Edge0)/Edge0); %nm
scale=Edge/Egde_protype;
T=T'*scale;%nm
theta = rand()*360;
R = [cosd(theta) -sind(theta) ;
     sind(theta)  cosd(theta)];
T=(T'*R)';
T = T/Sim_scale;%nm->px
canvas=zeros(RES);
T=T+RES/2;
for i = 1:RES
    y=(1:RES)';
    x=ones([RES,1])*i;
    tmp=inpolygon(x,y,T(1,:)',T(2,:)');
    canvas(i,:)=tmp'*thickness;%nm
end
out=canvas;
end