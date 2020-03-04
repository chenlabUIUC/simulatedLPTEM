function n=normal(mesh)
v1=mesh(:,2)-mesh(:,1);
v2=mesh(:,3)-mesh(:,1);
n=cross(v1,v2);
n=n/norm(n);
%scatter3(mesh(2,1),mesh(2,2),mesh(2,3))
%fill3(mesh(:,1),mesh(:,2),mesh(:,3),1)
end