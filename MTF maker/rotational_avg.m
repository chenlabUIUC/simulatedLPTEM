function [newx,newy]=rotational_avg(I)
    [center(1),center(2)]=find(I(:,:)==max(I(:)));
    l=length(I);
    distx=[1:l]-center(1);distx=repmat(distx,l,1);
    disty=[1:l]'-center(2);disty=repmat(disty,1,l);
    dist=sqrt(distx.^2+disty.^2);
    dist=reshape(dist,[length(dist(:)),1]);
    I1D=reshape(I,[l^2,1]);
    I1D=cat(2,dist,I1D);
    mask=(I1D(:,1)<(l/2));
    distance=I1D(:,1);y=I1D(:,2);
    distance=distance(mask);
    y=y(mask);
    distanceBin=(1:l)-1;
    newy=zeros([l 1]);
    [~,LocB] = ismembertol(distance,distanceBin,0.5, 'DataScale', 1);
    for i = 1 : length(distanceBin)
       mask=(LocB==i);
       newy(i)=mean(y(mask));
    end
    %newy(1:20)=NaN;
    newy=newy';
    newx=1:l;
end