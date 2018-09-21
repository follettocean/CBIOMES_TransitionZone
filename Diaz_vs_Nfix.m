

%%compute

for ii=1:5;
    tmp1=sprintf('c%02d',ii+9);
    ncload(['interp/PlanktonBiomass/' tmp1 '.0001.nc'],tmp1);
    eval(['tmp2=permute(' tmp1 ',[4 3 2 1]);']); clear(tmp1);
    if ii==1; diaz=0; end;
    diaz=diaz+squeeze(tmp2(:,:,1,:));
end;

ncload('interp/BiologicalRates/Nfix.0001.nc','Nfix');
Nfix=permute(Nfix,[4 3 2 1]);
Nfix=squeeze(Nfix(:,:,1,:));

%%plot

ncload('interp/BiologicalRates/Nfix.0001.nc','lon','lat');
lon=permute(lon,[2 1]); lat=permute(lat,[2 1]);

for mm=1:12;
    figure;
    pcolor(lon,lat,diaz(:,:,mm)); caxis([0 0.2]); shading flat; colorbar; hold on;
    contour(lon,lat,Nfix(:,:,mm),[0:0.5:5]*1e-7,'m'); title(num2str(mm));
end;


