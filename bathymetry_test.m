clc;clear;close all
% test for bathymetry plot
%%
m_proj('Mercator','lon',[117 129],'lat',[24 42])
% m_etopo2('contourf',-7000:20:0,'edgecolor','none');
cmaxtic =[4,90,141;
    43,140,190;
    116,169,207;
    189,201,225;
    241,238,246];
my_cmap = interpolate_cbrewer(cmaxtic, 'linear', 64);
my_cmap = my_cmap./255;
[elevations,lon,lat]=m_etopo2([117 129 24 42]);
elevations(elevations >= 0) = 0;
elevations(elevations == 0) = nan;
m_contourf(lon,lat,-log(-elevations));
m_gshhs_i('patch',[96/255 96/255 96/255],'edgecolor','none');
m_grid('linewi',2,'layer','top');
colormap(my_cmap)
% caxis([-1000 50])
% c_map = m_colmap('blue');
% colormap(c_map)