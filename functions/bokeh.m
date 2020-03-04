function result=bokeh(thicknessMap,distribution)
r = distribution(1)+rand()*distribution(2);
if r 
    f = fspecial('disk', r);
    result = imfilter(thicknessMap,f);
else
    result = thicknessMap;
end
end
