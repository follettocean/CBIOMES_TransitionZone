function plotvTransectflow(Tmap,var,name,lon)
%This will plot a transect over time with the flow lines super imposed. 
%Tmap is a structure containing the fields from the climatology. var is either a
%variable ie. Tmap.name or a fieldname if Tmap=[]. name is the variable
%name which will show up in the title and lon is the longitude of the
%transect which will be between 22-50N. The current lat bounds are -180 to
%-130 W. Locally called plotflow9_17 (for Chris))
if isempty(Tmap)
    load('9_11.mat','Tmap')
    var=Tmap.(var);
end
[lat,n]=min(abs(Tmap.lonmat(1,:,1)-lon));
lat=lat(1);n=n(1);
plotvflowint([],squeeze(Tmap.month(:,n,:)),squeeze(Tmap.latmat(:,n,:)),ones(56,12),squeeze(Tmap.vr(:,n,:)),0,squeeze((var(:,n,:))),[name ' ' num2str(Tmap.lonmat(1,n,1))])

end
function plotvflowint(fig,tmat,latmat,tvecmonth,vmonth,anom,X,Xname)
if ~isempty(fig)
figure(fig);clf
else
    figure;
end
imagesc(tmat(1,:),latmat(:,1),X);set(gca,'YDir','normal');
hold on
if anom==1
v=vmonth-repmat(mean(vmonth,2),1,12);
n1=' Anomaly ';
else
    v=vmonth;
    n1=' ';
end
h2=streamslice(tmat,latmat,tvecmonth,v);
%h2=quiver(tmat,latmat,tvecmonth,v,0);
for n=1:length(h2); h2(n).LineWidth=1;h2(n).Color='k'; end
colorbar
title(['Surf. Flow' n1 'and ' Xname])
xlabel('Month')
ylabel('Latitude')
end