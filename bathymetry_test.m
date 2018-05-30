clc;clear;close all
% test for bathymetry plot 
%%
m_proj('Mercator','lon',[117 123],'lat',[36 42])
% m_etopo2('contourf',-100:1:0,'edgecolor','none');
[elevations,lat,lon]=mygrid_sand2([117 123 36 42]);
  m_contour(lon,lat,elevations);
m_gshhs_l('patch',[.5 .8 0],'edgecolor','none');
m_grid('linewi',2,'layer','top');
caxis([-40 0])
colormap(m_colmap('blue')); 