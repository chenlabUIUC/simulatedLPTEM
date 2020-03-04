function result=myImtranslate(im,dir)
    dir(1)=floor(dir(1)+0.5000001);
    dir(2)=floor(dir(2)+0.5000001);
    size=length(im);
    result=circshift(im, [dir(2),dir(1)]);
    if (dir(1)>0 && dir(1)<size)
        result(:,1:dir(1))=0;
    elseif(dir(1)<0 && dir(1)>-size)
        result(:,end+dir(1)+1:end)=0; 
    elseif( (dir(1)>=size) || (dir(1)<=-size)   )
        result(:,:)=0;
    end
    if (dir(2)>0 && dir(2)<size)
        result(1:dir(2),:)=0;
    elseif(dir(2)<0 && dir(2)>-size)
        result(end+dir(2)+1:end,:)=0; 
    elseif( (dir(2)>=size) || (dir(2)<=-size)   )
        result(:,:)=0;
    end
end