function result=motionBlur_RW(thicknessMap,D,expTime)
%D = 1;  D should be px^2/s
%times = 100;
%expTime = 1;
times = 800;
t = expTime/times;
sigma = sqrt(2*D*t);
d=normrnd(0,sigma,[2 times]);
p = cumsum(d,2)';
%plot(p(:,1),p(:,2))
result = zeros('like',thicknessMap);
for i = 1 : times
result = (result+myImtranslate(thicknessMap,p(i,:))/times);
end
end