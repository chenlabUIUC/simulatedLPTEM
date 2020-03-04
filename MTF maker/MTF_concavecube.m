filename=strcat('142.avi');

video=VideoReader(filename);
i=0;
frames=[];
while hasFrame(video)
    i=i+1;
    frame = readFrame(video);
    if(i>352)
    frame=frame(856:856+329,492:492+329);
    frames=cat(3,frames,frame);
    %disp(i);
    %imshow(frame);
    %drawnow
    end
end
clear video;
pd=fitdist(frames(:),'Normal');
fprintf('background: \x03BC:%.02f; \x03C3:%.02f\n', pd.mu,pd.sigma);
%%
s=size(frames);
RES=s(1);
y=zeros([1,RES]);
for i = 1: s(3)
    I=frames(:,:,i);I=double(I);
    imshow(I/255);
    drawnow
    FT=fft2(I);
    FT=fftshift(FT);
    FT=abs(FT).^2;
    [x,y_tmp]=rotational_avg(FT);
    y=y+y_tmp;
    disp(strcat('current frame:',num2str(i)));

end
y=y.^0.5;
x=x./RES;
%%
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
xlim([0 0.5]);ylabel('MTF');
ylim([0 1]);xlabel ('frequency')
%%
MTFRES=1024;
scale=MTFRES/RES;
center(1)=MTFRES/2+1;center(2)=MTFRES/2+1;
distx=[1:MTFRES]-center(1);distx=repmat(distx,MTFRES,1);
disty=[1:MTFRES]'-center(2);disty=repmat(disty,1,MTFRES);
dist=sqrt(distx.^2+disty.^2);
dist=(floor((dist+0.499999)/scale));


for i = 1:length(dist(:))
       dist(i)=y_(dist(i)+1);
end
dist(isnan(dist))=0;
imshow(dist);
MTFmatrix=dist;
save(strcat('MTFmatrix',num2str(MTFRES)),'MTFmatrix');