 function main()
clf;
rng(999);
detectorRES=512;
MTFmatrix=load(strcat('MTFmatrix',num2str(detectorRES),'.mat'));MTFmatrix=MTFmatrix.MTFmatrix;
gtPath='../deform/label/';
simPath='../deform/train/';
detectorScale=98.62/detectorRES;%nanometer/pixel  the number here means the real size you want to simulate
exposureTime=1;%second;
PARTICLERES=300;
%IMFPgold=20;%(nm)[2]
IMFPwater=185;%(nm)[2]
IMFPSiNx=144;%(nm)[2]
thicknessWater=150;%(nm)
thicknessCell=50;%(nm)
holderFactor=1;
conversionFactor=3.472;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for sampleNo=1:1000
    IMFPgold=20+rand()*60;
    beamFlux=500+rand()*1000;%electrons/(A2*s)    
    beamFlux=beamFlux*100*(detectorScale^2)*exposureTime;%electrons/(pixel)    
    disp(strcat('current iteration: ',num2str(sampleNo)))
    clf;
    water=ones(detectorRES)*thicknessWater;
    cell=ones(detectorRES)*2*thicknessCell;
    canvas=zeros(detectorRES+2*PARTICLERES,detectorRES+2*PARTICLERES);
    gt=zeros(detectorRES+2*PARTICLERES,detectorRES+2*PARTICLERES);
    particleN=randi(5)+20;
    fastparticleN=10;
    for i =1 :particleN
        pos=randi([1,detectorRES+PARTICLERES],[1 2])';
        particle=ray_tracing_rod_etch(PARTICLERES,detectorScale);
        gt(pos(1):pos(1)+PARTICLERES-1,pos(2):pos(2)+PARTICLERES-1)=gt(pos(1):pos(1)+PARTICLERES-1,pos(2):pos(2)+PARTICLERES-1)+particle;
        %particle=motionBlur(particle);
        canvas(pos(1):pos(1)+PARTICLERES-1,pos(2):pos(2)+PARTICLERES-1)=canvas(pos(1):pos(1)+PARTICLERES-1,pos(2):pos(2)+PARTICLERES-1)+particle;
        %drawnow
    end
    
    for i =1 :fastparticleN
        pos=randi([1,detectorRES+PARTICLERES],[1 2])';
        particle=ray_tracing_rod_etch(PARTICLERES,detectorScale);
        particle=motionBlurFast(particle);
        canvas(pos(1):pos(1)+PARTICLERES-1,pos(2):pos(2)+PARTICLERES-1)=canvas(pos(1):pos(1)+PARTICLERES-1,pos(2):pos(2)+PARTICLERES-1)+particle;
        %drawnow
    end
    
    gt=~logical(gt(PARTICLERES+1:PARTICLERES+detectorRES,PARTICLERES+1:PARTICLERES+detectorRES));
    sim=canvas(PARTICLERES+1:PARTICLERES+detectorRES,PARTICLERES+1:PARTICLERES+detectorRES);
    sim=sim*detectorScale; %pixel2nanometer
    water=water-sim;
    sim0=beamFlux*holderFactor*exp(-(sim/IMFPgold+water/IMFPwater+cell/IMFPSiNx));% #electrons in this pixel in this frame 
    sim=poissrnd(sim0);
    %sim=sim0;
    gt=gt(:,:)>0.5;
    sim= normrnd(sim,0);
    FT=fft2(sim);
    FT=fftshift(FT);
    FT=FT.*MTFmatrix;
    FT=ifftshift(FT);
    sim=abs(ifft2(FT));
    sim=sim*conversionFactor;

    bkg=sim(gt);
    
    sim=imresize(sim,[512 512]);
    gt=imresize(gt,[512 512]);
    
    fprintf('background: \x03BC:%.02f; \x03C3:%.02f\n', mean(bkg(:)),std(bkg(:)));

    sim=sim-min(sim(:));
    sim=sim/max(sim(:));
    imshow(sim);
    drawnow;
    gtname=strcat(gtPath,num2str(sampleNo),'.tif');
    simname=strcat(simPath,num2str(sampleNo),'.tif');
    %imwrite(gt,gtname);
    imwrite(sim,simname);
    imwrite(gt,gtname);
    end
    

end



function result=motionBlur(thicknessMap)
v=abs(normrnd(3,1));
result = zeros('like',thicknessMap);
for i = 1 : 100
result = (result+myImtranslate(thicknessMap,[normrnd(0,v), normrnd(0,v)])/100);
end
end

function result=motionBlurFast(thicknessMap)
v=abs(normrnd(50,5));
result = zeros('like',thicknessMap);
for i = 1 : 200
result = (result+myImtranslate(thicknessMap,[normrnd(0,v), normrnd(0,v)])/200);
end
end