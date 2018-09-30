function []=pickup_compare_pacband(iFile,iRec,dirOut);
%%first load grid:
%grid_load('ECCOv3_grid/',1,'straight');
%%then either:
%for ii=1:71; pickup_compare_pacband(2,ii); pause; end;
%%or:
%for ii=1:71; pickup_compare_pacband(2,ii,'plots/'); close; end;

dirGrid='ECCOv3_grid/';
nFaces=1; fileFormat='straight';
dirPickup1='ECCOv3_oliver/';
dirPickup2='ECCOv3_steph/';

if iFile==1; fil='pickup_gud'; else; fil='pickup_ptracers'; end;

gcmfaces_global;
if isempty(mygrid)||~strcmp(mygrid.dirGrid,dirGrid);
    mygrid=[]; grid_load(dirGrid,nFaces,fileFormat);
end;
nR=length(mygrid.RC);

fld1=rdmds2gcmfaces([dirPickup1 fil '*'],NaN,'rec',iRec);
fld2=rdmds2gcmfaces([dirPickup2 fil '*'],NaN,'rec',iRec);

if iFile==1|isempty(which('PTRACERS_names'));
    meta=rdmds_meta([dirPickup1 fil '*']);
    ttl1=['log10 of ' deblank(meta.fldList{iRec}) ' in ' dirPickup1];
    ttl2=['log10 of ' deblank(meta.fldList{iRec}) ' in ' dirPickup2];
else;
    ttl1=['log10 of ' PTRACERS_names(iRec) ' in ' dirPickup1];
    ttl2=['log10 of ' PTRACERS_names(iRec) ' in ' dirPickup2];
end;

msk=mygrid.mskC(:,:,1).*(mygrid.XC>-170+360&mygrid.XC<-150+360);
msk(msk==0)=NaN; msk=repmat(msk,[1 1 length(mygrid.RC)]);
if iFile==1;
    figureL; m_map_gcmfaces(msk(:,:,1),0);
    pause; close;
end;

[zm1,X,Y]=calc_zonmean_T(msk.*fld1);
[zm2,X,Y]=calc_zonmean_T(msk.*fld2);

%cc=[min(prctile(zm1(:),10),prctile(zm2(:),10)) ...
%    max(prctile(zm1(:),90),prctile(zm2(:),90))];
%cc=round(cc*1e4)/1e4;

zm1(zm1<0)=0; zm1=log10(zm1);
zm2(zm2<0)=0; zm2=log10(zm2);

cc=zm1(:); cc=cc(isfinite(cc));
cc=[prctile(cc,5) prctile(cc,95)];
cc=round(cc*1e2)/1e2;
cc(1)=max(cc(1),cc(2)-2);

figure;
subplot(2,1,1); pcolor(X,Y,zm1); caxis(cc); shading interp; colorbar; title(ttl1,'Interpreter','none'); axis([0 60 -500 0]);
subplot(2,1,2); pcolor(X,Y,zm2); caxis(cc); shading interp; colorbar; title(ttl2,'Interpreter','none'); axis([0 60 -500 0]);
%subplot(3,1,3); pcolor(X,Y,zm1-zm2); shading interp; colorbar; title('difference (1-2)'); axis([0 60 -500 0]);
colormap(parula(16));

if ~isempty(whos('dirOut'));
    if ~isdir(dirOut); mkdir(dirOut); end;
    print(gcf,'-djpeg99',[dirOut 'pacband_' fil '_' num2str(iRec) '.jpg']);
end;
