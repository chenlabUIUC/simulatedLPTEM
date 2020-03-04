function result=motionBlur(thicknessMap,sigma,time)
v=abs(normrnd(sigma(1),sigma(2)));
result = zeros('like',thicknessMap);
for i = 1 : time
result = (result+myImtranslate(thicknessMap,[normrnd(0,v), normrnd(0,v)])/time);
end
end