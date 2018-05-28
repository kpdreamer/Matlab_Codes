clc;clear;close all
% for test
%%
%read data
cd('F:\临时工作区\海洋随机信号处理作业')
NRRS443_list = dir('GlobrColor_data\*NRRS443*.nc');
NRRS490_list = dir('GlobrColor_data\*NRRS490*.nc');
NRRS555_list = dir('GlobrColor_data\*NRRS555*.nc');
NRRS670_list = dir('GlobrColor_data\*NRRS670*.nc');
num_of_data = ength(NRRS443_list);
NRRS443 = zeros(332,484,num_of_data);
NRRS490 = NRRS443;NRRS555=NRRS443;NRRS670=NRRS443;
for ii = 1:num_of_data
    file_443=strcat('GlobrColor_data\',NRRS443_list(ii).name);
    NRRS443(:,:,ii)=ncread(file_443,'NRRS443_mean');
    file_490=strcat('GlobrColor_data\',NRRS490_list(ii).name);
    NRRS490(:,:,ii)=ncread(file_490,'NRRS490_mean');
    file_555=strcat('GlobrColor_data\',NRRS555_list(ii).name);
    NRRS555(:,:,ii)=ncread(file_555,'NRRS555_mean');
    file_670=strcat('GlobrColor_data\',NRRS670_list(ii).name);
    NRRS670(:,:,ii)=ncread(file_670,'NRRS670_mean');
end
lon=ncread(file_443,'lon');
lat=ncread(file_443,'lat');
NRRS443(NRRS443<0)=nan;
NRRS490(NRRS490<0)=nan;
NRRS555(NRRS555<0)=nan;
NRRS670(NRRS670<0)=nan;
Rrs_fit=[reshape(NRRS443,[],1),reshape(NRRS490,[],1),reshape(NRRS555,[],1),reshape(NRRS670,[],1)];
%%
%tansform Rrs to Kd380
filename='效果较好的SeaUVC参数\pca_coef_kmeans.txt';
coef=dlmread(filename,'',1,0);
filename='standarded.txt';
sta=dlmread(filename,'',0,0);
ln_Rrs=log(Rrs_fit);
for ii=1:4
    std_Rrs(:,ii)=(ln_Rrs(:,ii)-sta(ii,1))./sta(ii,2);
end
pca_tst=std_Rrs*coef;

filelist=dir('效果较好的SeaUVC参数\regression*.txt');
for ii=1:length(filelist)
    filename=strcat('效果较好的SeaUVC参数\',filelist(ii).name);
    b(:,:,ii)=dlmread(filename,'',0,0);
end
num_clu =length(b(:,1));
x_temp=pca_tst(:,[1 2]);
num=length(x_temp(:,1));
filename='效果较好的SeaUVC参数\centre_SeaUVC.txt';
clu_centre=dlmread(filename,'',0,0);
Y=zeros(num,1);
for ii=1:num
    y=(x_temp(ii,1)-clu_centre(:,1)).^2+...
        (x_temp(ii,2)-clu_centre(:,2)).^2;
    y_ind=find(y==min(y));
    if isempty(y_ind)
        Y(ii,1)=nan;
    else
        Y(ii,1)=y_ind;
    end
end

kdd=zeros(size(Y));
kdd(:)=nan;
for ii=1:num_clu
    temp_pca=pca_tst((Y==ii),:);
    temp_kdd=b(ii,1)+temp_pca(:,1:3)*b(ii,2:3+1)';%通过主成分和算得的回归系数计算kd
    kdd(Y==ii,:)=temp_kdd;
    clear temp_pca temp_kdd
end
kd_380=reshape(kdd,[332,484,num_of_data]);
%%
%
