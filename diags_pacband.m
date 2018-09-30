function [PbdPtrAll,listIn]=diags_pacband(tt,doSave);
%[PbdPtr,listIn]=diags_pacband(61,1);

gcmfaces_global;

if isempty(whos('tt')); tt=1; end;
if isempty(whos('doSave')); doSave=0; end;

runDir=[pwd filesep];
filIn='ptr_3d_set1.'; dirIn=[runDir 'diags_ptr' filesep];
filOut='ptr_pbd_set1.'; dirOut=[runDir 'diags_pacband' filesep];

listIn=dir([dirIn filIn '*data']);
listIn=listIn(tt);

nt=length(listIn);
nr=length(mygrid.RC);

%msk=mygrid.mskC(:,:,1).*(mygrid.XC>-170+360&mygrid.XC<-150+360);
msk=mygrid.mskC(:,:,1).*(mygrid.XC>-170&mygrid.XC<-150);
msk(msk==0)=NaN; msk=repmat(msk,[1 1 length(mygrid.RC)]);
[PbdMsk,X,Y]=calc_zonmean_T(msk);

for tt=1:length(listIn);
  tic;
  display(listIn(tt).name(1:end-5));
  fld=rdmds2gcmfaces([dirIn listIn(tt).name(1:end-5)]);
  toc;
  nv=size(fld{1},4);
  PbdPtr=NaN*repmat(PbdMsk,[1 1 nv]);
  tic;
  for ii=1:nv;
    [tmp,X,Y]=calc_zonmean_T(msk.*fld(:,:,:,ii));
    PbdPtr(:,:,ii)=tmp;
  end;
  toc;
  if doSave; 
    iter=listIn(tt).name(length(filIn)+1:end-5);
    save([dirOut filOut iter '.mat'],'X','Y','PbdPtr','iter');
  end;
  if tt==1; PbdPtrAll=repmat(PbdPtr,[1 1 1 nt]); end;
  PbdPtrAll(:,:,:,tt)=PbdPtr;
end;

return;

