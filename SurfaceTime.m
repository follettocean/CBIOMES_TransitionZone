function SurfaceTime(Tmap,var,qs)
%This code will plot the 2D maps of the ECCOv4-gud model. Tmap is a
%structure containing the fields from the climatology. var is either a
%variable ie. Tmap.name or a fieldname if Tmap=[]. qs sets the pause time
%between frames, qs=[] will set to manual stepping. Local is (movie2D9_17,
%for Chris)
if isempty(Tmap)
    load('9_11.mat','Tmap')
    var=Tmap.(var);
end
figure; 
for n=1:12
     clf;
     B=bwboundaries(squeeze(Tmap.Cr4(:,:,n)==1));
     X=squeeze(Tmap.lonmat(1,:,n));
     Y=squeeze(Tmap.latmat(:,1,1));
     imagesc(X,Y,(squeeze(var(:,:,n))));colorbar
     set(gca,'YDir','normal');hold on;
     plot(X(B{1}(:,2)),Y(B{1}(:,1)),'k-','LineWidth',2);
%      if qs==1
%         quiver(squeeze(Tmap.lonmat(:,:,n)),squeeze(Tmap.latmat(:,:,n)),squeeze(Tmap.ur(:,:,n)),squeeze(Tmap.vr(:,:,n)),0);
%      else
        streamslice(squeeze(Tmap.lonmat(:,:,n)),squeeze(Tmap.latmat(:,:,n)),squeeze(Tmap.ur(:,:,n)),squeeze(Tmap.vr(:,:,n)));
%      end
        xlim([-180 -130]);ylim([22 50]);
        title(['Month ' num2str(n)])
        xlabel('Longitude')
        ylabel('Latitude')
        drawnow
        if ~isempty(qs)
            pause(qs);
        else
            pause;
        end
 end