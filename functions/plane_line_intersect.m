function [I,check]=plane_line_intersect(n,mesh,P0,u)
%plane_line_intersect computes the intersection of a plane and a ray
% Inputs: 
%       n: normal vector of the mesh 
%       mesh: 
               % p1x,p2x,p3x
               % p1y,p2y,p3y
               % p1z,p2z,p3z
                
%       P0: end point 1 of the segment P0P1
%       u:  normal vector of the ray
%
%Outputs:
%      I    is the point of interection 
%     Check is an indicator:
%      0 => disjoint (no intersection)
%      1 => the plane intersects P0P1 in the unique point I
%      2 => the segment lies in the plane
%      3 =>the intersection lies outside the ray [P0,inf]
%      4 => the intersection lies outside the mesh area
%
%This function is written by :
%                             Nassim Khaled
%                             Wayne State University
%                             Research Assistant and Phd candidate
%Modified by Lehan Yao
%            University of illinois at Champaign-Urbana
%            5/28/2019
%n=normal(mesh);
V0=mesh(:,1)';
I=[0 0 0];
w = P0 - V0;
D = n*u';
N = -n*w';
check=0;
if abs(D) < 10^-7        % The segment is parallel to plane
        if N == 0           % The segment lies in plane
            check=2;
            return
        else
            check=0;       %no intersection
            return
        end
end
%compute the intersection parameter
sI = N / D;
I = P0+ sI.*u;
if (sI < 0 )
    check= 3;          %The intersection point  lies outside the segment, so there is no intersection
else
    check=1;
    
%a0=triAreaCross(mesh(:,1),mesh(:,2),mesh(:,3));
%a1=triAreaCross(I',mesh(:,2),mesh(:,3));
%a2=triAreaCross(mesh(:,1),I',mesh(:,3));
%a3=triAreaCross(mesh(:,1),mesh(:,2),I');
%figure(5);clf;
%scatter(P0(1),P0(2),200,'red','filled')
%hold on
%fill3(mesh(1,:),mesh(2,:),mesh(3,:),1);
%scatter3(I(1),I(2),I(3))
%quiver3(0,0,0,n(1),n(2),n(3),200)
%axis equal
%if (or(abs(a1+a2+a3-a0)>0.1,a0<0.01))
%    check=4 ;
%end
if (~InPolygon(I(1),I(2),mesh(1,:),mesh(2,:)))
    check = 4;
end

end
end

function area=triAreaCross(pa,pb,pc)
a=pa-pb;
b=pc-pb;
a(3) = 0;
b(3) = 0;
C = cross(a,b);
area = 1/2*norm(C);
end