function [ ] = diags_pacband_plot( dirIn , iRec, dirOut)
%DIAGS_PACBAND_PLOT plot tracer section at regular intervals
%
%diags_pacband_plot(diags_pacband.20180928/');

gcmfaces_global;
[zm1,X,Y]=calc_zonmean_T(mygrid.mskC);

%timTxt={'0000000732','0000044580','0000088404','0000132228'};
timTxt={'0000044580','0000132228'};
ttlTxt={'+5 years','+15 years'};

figure;
for tt=1:length(timTxt)
    load([dirIn 'ptr_pbd_set1.' timTxt{tt} '.mat']);
    ttl=['log10 of ' PTRACERS_names(iRec) ' at ' ttlTxt{tt}];
    zm=PbdPtr(:,:,iRec); zm(zm<0)=0; zm=log10(zm);
    if tt==1; 
        cc=zm(:); cc=cc(isfinite(cc));
        cc=[prctile(cc,5) prctile(cc,95)]; 
        cc=round(cc*1e2)/1e2;
        cc(1)=max(cc(1),cc(2)-2);
    end;
    subplot(2,1,tt); pcolor(X,Y,zm); caxis(cc); shading interp;
    colormap(parula(16)); colorbar; title(ttl); axis([0 60 -500 0]);
end

if ~isempty(whos('dirOut'));
    if ~isdir(dirOut); mkdir(dirOut); end;
    print(gcf,'-djpeg99',[dirOut 'pacband_ptr' num2str(iRec) '.jpg']);
end;
