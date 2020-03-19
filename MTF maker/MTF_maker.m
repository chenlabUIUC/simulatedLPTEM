% NAME:  MTF_maker.m
% PURPOSE:  This script is designed to extract and output the modulation transfer function 
%           (MTF) from noisy TEM image(s).
% INCLUDE:
%           rotational_avg.m: calculate 1D center rotational averaged value from a 2D matrix
% INPUT:
%           imagePath:    string. Name of the folder storing your sample images. 
%                         supports jpg and tif (don't put random files inside)
%           samplingArea: int, scalar. How much area you want to sample from the image(s)
%                         Should include pure noise, no feature(particle).
%                         Better larger than 50 pixels.
%           cropStart:    int, 1-by-2. The strating pixel position you want to sample.
%                         When the script is running, watch the red box. Make sure no
%                         feature(particle) is inside.
%           outputRES:    int, scalar. Size of the output, should be the same of the image 
%                         you want to simulate
% OUTPUT:
%           a 2D matrix recording MTF of your sample image(s): MTFmatrix{%outputRES}.mat
% REFERENCE: L. Yao, et. al. ACS. Cent. Sci (2020)
% HISTORY:  written by Lehan, 2019/07/15
%   edited by Lehan, 2020/3/19, package the code together
%
%%%%%%%%%%parameter input%%%%%%%%%
imagePath='MTF sample images';
samplingArea = 200; %px, better larger than 50 pixels
outputRES=512;
cropStart = [510,545];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
nameList = dir(imagePath);
nameList_new = {};
for i = 1 :length(nameList)
    name = nameList(i).name;
    if length(name)<5
        continue;
    end
    if or(name(end-3:end)=='.tif', name(end-3:end)=='.jpg')
        nameList_new{end+1} = name;
    end
end
y=zeros([1,samplingArea]);
figure(1);clf;set(gca, 'YDir','reverse');
for i = 1: length(nameList_new)
    I0 = imread([imagePath,'/',nameList_new{i}]);
    I0 = mean(I0,3)/255;
    I=I0(cropStart(1):cropStart(1)+samplingArea-1,cropStart(2):cropStart(2)+samplingArea-1);
    I=double(I);
    imshow(I0);
    hold on
    box = repmat(cropStart,5,1);
    box(2,1) =  box(2,1)+samplingArea;
    box(3,:) =  box(3,:)+samplingArea;
    box(4,2) =  box(4,2)+samplingArea;
    plot(box(:,1),box(:,2),'color','r','LineWidth',1.5)
    drawnow
    FT=fft2(I);
    FT=fftshift(FT);
    FT=abs(FT).^2;
    [x,y_tmp]=rotational_avg(FT);
    y=y+y_tmp;
    disp(strcat('current frame:',num2str(i)));
end
y=y.^0.5;
x=x./samplingArea;
%%
figure(2);clf;set(gca, 'YDir','normal');
y_=y;
frequency=0.05;
y_(x<frequency)=NaN;
new_x=0:0.001:frequency+0.05;
reg_y=y_(x>=frequency);reg_y=reg_y(~isnan(reg_y));
reg_x=x(x>=frequency);reg_x=reg_x(~isnan(reg_y));
reg_y=reg_y(reg_x>frequency & reg_x<frequency+0.05);
reg_x=reg_x(reg_x>frequency & reg_x<frequency+0.05);
a=[ones(length(reg_x),1) reg_x']\reg_y';
newy=a(2).*new_x+a(1);
y_(x<frequency)=a(2).*x(x<frequency)+a(1);
y_=y_/(max(newy));
y_=cat(2,[1],y_);
x=cat(2,[0],x);
plot(x,y_,'blue');
hold on
plot(x(x<frequency),y_(x<frequency),'red');
xlim([0 0.5]);ylabel('MTF');
ylim([0 1]);xlabel ('frequency')
%%
figure(3);clf;
scale=outputRES/samplingArea;
center(1)=outputRES/2+1;center(2)=outputRES/2+1;
distx=[1:outputRES]-center(1);distx=repmat(distx,outputRES,1);
disty=[1:outputRES]'-center(2);disty=repmat(disty,1,outputRES);
dist=sqrt(distx.^2+disty.^2);
dist=(floor((dist+0.499999)/scale));
for i = 1:length(dist(:))
       dist(i)=y_(dist(i)+1);
end
dist(isnan(dist))=0;
imshow(dist);
colormap('parula')
MTFmatrix=dist;
save(['MTFmatrix',num2str(outputRES)],'MTFmatrix');
disp(['saved to ','MTFmatrix',num2str(outputRES),'.mat'])