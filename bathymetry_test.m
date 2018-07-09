clc;clear;close all
% test for bathymetry plot 
%%
m_proj('Mercator','lon',[117 129],'lat',[24 42])
% m_etopo2('contourf',-7000:20:0,'edgecolor','none');
[elevations,lon,lat]=m_etopo2([117 129 24 42]);
elevations(elevations >= 0) = 0;
elevations(elevations == 0) = nan;
m_contourf(lon,lat,-log(-elevations));
m_gshhs_i('patch',[96/255 96/255 96/255],'edgecolor','k');
m_grid('linewi',2,'layer','top');
% caxis([-1000 50])
% c_map = m_colmap('blue');