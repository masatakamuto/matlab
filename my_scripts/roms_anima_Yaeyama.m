%
% === Copyright (c) 2014-2021 Takashi NAKAMURA  =====
%
% CASE 1=> YAEYAMA1; 2=> YAEYAMA2; 3=> YAEYAMA3
CASE = 1;

% F_drawUV = true;
F_drawUV = false;
id = 7;  % <- Select 1,2,3,100

if CASE == 1      % YAEYAMA1
    grd='F:\COAWST_DATA\Yaeyama\Yaeyama1\Grid\Yaeyama1_grd_v10.nc';
    his='H:\COAWST_OUTPUT\Yaeyama1\Yaeyama1_his_20010102.nc';
%     his='K:\COAWST\output\Yaeyama1_2\Y1_his_nst_ctrace_20190801.nc';
%     his='K:\COAWST\output\Yaeyama1_2\Y1_his_nst_ctrace_20190810.nc';
    out_dirstr = 'output/figs_png_Y1srf2';
elseif CASE == 2  % YAEYAMA2
    grd='F:\COAWST_DATA\Yaeyama\Yaeyama2\Grid\Yaeyama2_grd_v11.2.nc';
%     his='H:\COAWST_OUTPUT\Yaeyama2\Yaeyama2_his_19950529.nc';
%     his='K:\COAWST\output\Yaeyama1_2\Y2_his_nst_ctrace_20190801.nc';
    his='K:\COAWST\output\Yaeyama1_2\Y2_his_nst_ctrace_20190810.nc';
    out_dirstr = 'output/figs_png_Y2Ctrace';  % Surface
%     out_dirstr = 'output/figs_png_Y2btm';  % Bottom
elseif CASE == 3  % YAEYAMA3
    grd='F:\COAWST_DATA\Yaeyama\Yaeyama3\Grid\Yaeyama3_grd_v12.2.nc';
    his='H:\COAWST_OUTPUT\Yaeyama3\Yaeyama3_his_19990104.nc';
    out_dirstr = 'output/figs_png_Y3';
end
[status, msg] = mkdir( out_dirstr )

Nz=15; % Surface
% Nz=1; % Bottom

starting_date=datenum(2000,1,1,0,0,0); % 

% My color map
load('MyColormaps')
colormap6=superjet(128,'NuvibZctgyorWq');
title='Sea surface temperature (^oC)'; cmin=16; cmax=34; colmap=colormap6; ncname='temp'; % YAEYAMA1
% title='Sea Surface Temperature (^oC)'; cmin=17; cmax=32; colmap=jet(128); ncname='temp'; % YAEYAMA1
% title='Sea Surface Temperature (^oC)'; cmin=20; cmax=34; colmap=jet(128); ncname='temp'; % YAEYAMA2 surface
% title='Sea Bottom Temperature (^oC)'; cmin=20; cmax=34; colmap=jet(128); ncname='temp'; % YAEYAMA2 bottom

% title='Salinity (psu)'; cmin=33; cmax=35; colmap=jet(128); ncname='salt';

% title='Coarse POC (umolC L^-^1)'; cmin=0; cmax=2; colmap=colmap1; ncname='POC_02';
% title='Coarse PO^1^3C (umolC L^-^1)'; cmin=0; cmax=2; colmap=colmap1; ncname='PO13C_02';

% title='Detritus (umolC L^-^1)';  cmin=0; cmax=5; colmap=jet(128); ncname='POC_01';
% title='^1^3C in Detritus (umolC L^-^1)'; cmin=0; cmax=0.0001; colmap=colmap1; ncname='PO13C_01';

% title='Labile DOC (umolC L^-^1)';  cmin=0; cmax=50; colmap=jet(128); ncname='DOC_01';
% title='Labile DO^1^3C (umolC L^-^1)'; cmin=0; cmax=0.0005; colmap=colmap1; ncname='DO13C_01';

% title='Refractory DOC (umolC L^-^1)';  cmin=40; cmax=70; colmap=jet(128); ncname='DOC_02';
% title='Refractory DO^1^3C (umolC L^-^1)'; cmin=0; cmax=0.00001; colmap=colmap1; ncname='DO13C_02';

% title='DIC (umol kg^-^1)'; cmin=1800; cmax=2000; colmap=jet(128); ncname='TIC';
% title='DI^1^3C (umol kg^-^1)'; cmin=0; cmax=0.0005; colmap=colmap1; ncname='TI13C';

% title='Dinoflagellate (umolC L^-^1)';  cmin=0; cmax=3; colmap=jet(128); ncname='phytoplankton_01';
% title='^1^3C in Dinoflagellate (umolC L^-^1)'; cmin=0; cmax=0.000001; colmap=colmap1; ncname='phyt13C_01';

% title='Diatom (umolC L^-^1)';  cmin=0; cmax=30; colmap=jet(128); ncname='phytoplankton_02';
% title='^1^3C in Diatom (umolC L^-^1)'; cmin=0; cmax=0.00001; colmap=colmap1; ncname='phyt13C_02';

% title='Coccolithophorids (umolC L^-^1)';  cmin=0; cmax=10; colmap=jet(128); ncname='phytoplankton_03';
% title='^1^3C in Coccolithophorids (umolC L^-^1)'; cmin=0; cmax=0.00001; colmap=colmap1; ncname='phyt13C_03';

% title='Particulate Inorganic C (umolC L^-^1)';  cmin=0; cmax=5; colmap=jet(128); ncname='PIC_01';
% title='Particulate Inorganic ^1^3C (umolC L^-^1)'; cmin=0; cmax=0.000001; colmap=colmap1; ncname='PI13C_01';

% title='Zooplankton (umolC L^-^1)';  cmin=0; cmax=10; colmap=jet(128); ncname='zooplankton_01';
% title='^1^3C in Zooplankton (umolC L^-^1)'; cmin=0; cmax=0.1; colmap=colmap1; ncname='zoop13C_01';

if id == 3
    scale=0.08;  % for Wave
    s_interval=4; % for SHIRAHO & YAEYAMA1 & YAEYAMA3
elseif id == 100
%     scale=1.5;  % for Wind
    scale=1;  % for Wind
    s_interval=6;  % for Wind
    Vmax = 20;  % for Wind
else
    if CASE ==1       % YAEYAMA1
        scale=8;
        s_interval=8;
        Vmax = 3;
    elseif CASE == 2  % YAEYAMA2
        scale=8;
        s_interval=8;
        Vmax = 3;
    elseif CASE == 3  % YAEYAMA3
        scale=8;
        s_interval=8;
        Vmax = 3;
    end
end


LOCAL_TIME=' (UTC)';
%LOCAL_TIME=' (JST)';
%LOCAL_TIME=' (UTC+9)';
% LOCAL_TIME='';

wet_dry = 0;  % Dry mask OFF: 0, ON: 1

unit = 'km'; 
% 'm', 'latlon'
% unit = 'latlon';
LevelList = [-1 1 10];

h          = ncread(his,'h');
% y_rho    = ncread(his,'lat_rho');
% x_rho    = ncread(his,'lon_rho');
x_rho      = ncread(grd,'x_rho');
y_rho      = ncread(grd,'y_rho');
x_rho=(x_rho-min(min(x_rho)))/1000; % m->km
y_rho=(y_rho-min(min(y_rho)))/1000; % m->km

mask_u   = ncread(his,'mask_u');
mask_v   = ncread(his,'mask_v');
mask_rho   = ncread(his,'mask_rho');

[Im, Jm] = size(h);

c(1:Im,1:Jm)=0;

k=0;
i=1;

if CASE == 1      % YAEYAMA1
    xmin=min(min(x_rho))-1;   xmax=max(max(x_rho))+1;  ymin=min(min(y_rho))-1;   ymax=max(max(y_rho))+1;
    xsize=640; ysize=520;
elseif CASE == 2  % YAEYAMA2
    xmin=min(min(x_rho))-0.3;   xmax=max(max(x_rho))+0.3;  ymin=min(min(y_rho))-0.3;   ymax=max(max(y_rho))+0.3;
    xsize=620; ysize=550;
elseif CASE == 3  % YAEYAMA3
    xmin=min(min(x_rho))-0.1;   xmax=max(max(x_rho))+0.1;  ymin=min(min(y_rho))-0.1;   ymax=max(max(y_rho))+0.1;
    xsize=640; ysize=520;
else
    xmin=min(min(x_rho));   xmax=max(max(x_rho));  ymin=min(min(y_rho));   ymax=max(max(y_rho));
    xsize=520; ysize=520;   
end

% xmin=min(min(x_rho))-0.01;   xmax=max(max(x_rho));  ymin=min(min(y_rho));   ymax=max(max(y_rho));
% xmin=123.6;   xmax=max(max(x_rho));  ymin=23.95;   ymax=max(max(y_rho));

% xmin=116;   xmax=max(max(x_rho));  ymin=-6.5;   ymax=max(max(y_rho));  % for Berau1
% xsize=400; ysize=700; % for Berau1

close all
% clear ubar vber ubar2 vbar2 ubar3 vbar3

mask_u = mask_u ./mask_u;
mask_v = mask_v ./mask_v;
mask_rho = mask_rho ./mask_rho;

if id <100
%time = ncread(his,'ocean_time',[i],[1]);
    time = ncread(his,'ocean_time');
else
    time = ncread(his1,'time');
end
imax=length(time);

tmp = zeros(size(x_rho));

% Down sampling
x_rho2=x_rho(1:s_interval:Im,1:s_interval:Jm);
y_rho2=y_rho(1:s_interval:Im,1:s_interval:Jm);
x_rho2=x_rho(1:s_interval:Im,1:s_interval:Jm);
y_rho2=y_rho(1:s_interval:Im,1:s_interval:Jm);
% ubar3=ubar2(1:s_interval:Im,1:s_interval:Jm);
% vbar3=vbar2(1:s_interval:Im,1:s_interval:Jm);
ubar3=zeros(size(x_rho2));
vbar3=zeros(size(x_rho2));

if id <100
    date=starting_date+time(i+1)/24/60/60;
else
    date=starting_date+time(i+1);
end
date_str=strcat(datestr(date,31),'  ',LOCAL_TIME);

if id==1 || id==2
    [h_quiver,h_surf,h_contour,h_annot]=createvplot7(x_rho,y_rho,tmp,x_rho2,y_rho2,ubar3,vbar3,h,scale,date_str,'Velocity (m s^-^1)',0,Vmax,colmap4,xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList);
elseif id == 3
    [h_quiver,h_surf,h_contour,h_annot]=createvplot7(x_rho,y_rho,tmp,x_rho2,y_rho2,ubar3,vbar3,h,scale,date_str,'Hs (m)',0,1.5,jet(128),xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList);
elseif id == 4
    [h_quiver,h_surf,h_contour,h_annot]=createvplot7(x_rho,y_rho,tmp,x_rho2,y_rho2,ubar3,vbar3,h,scale,date_str,'Temperature (^oC)',27,35,jet(128),xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList);
elseif id == 5
    [h_quiver,h_surf,h_contour,h_annot]=createvplot7(x_rho,y_rho,tmp,x_rho2,y_rho2,ubar3,vbar3,h,scale,date_str,'Water elevation (m)',-1.5,2.5,jet(128),xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList);
elseif id == 6
    [h_quiver,h_surf,h_contour,h_annot]=createvplot7(x_rho,y_rho,tmp,x_rho2,y_rho2,ubar3,vbar3,h,scale,date_str,'Salinity (psu)',31,35,jet(128),xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList);
elseif id == 7
    [h_quiver,h_surf,h_contour,h_annot]=createvplot7(x_rho,y_rho,tmp,x_rho2,y_rho2,ubar3,vbar3,h,scale,date_str,title,cmin,cmax,colmap,xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList);
elseif id == 100
    [h_quiver,h_surf,h_contour,h_annot]=createvplot7(x_rho,y_rho,tmp,x_rho2,y_rho2,ubar3,vbar3,h,scale,date_str,'Wind velocity (m s^-^1)',0,Vmax,colmap4,xsize,ysize,xmin,xmax,ymin,ymax,unit,LevelList);
end

drawnow
%set(figure(1),'OuterPosition',[0 0 320 700])%[0 0 400 800]

% for i=1:1:imax
for i=1:1:imax

    if id == 1
        ubar = ncread(his,'ubar',[1 1 i],[Inf Inf 1]);
        vbar = ncread(his,'vbar',[1 1 i],[Inf Inf 1]);
    elseif id == 2
        ubar = ncread(his,'u',[1 1 Nz i],[Inf Inf 1 1]).*mask_u;
        vbar = ncread(his,'v',[1 1 Nz i],[Inf Inf 1 1]).*mask_v;
    elseif id == 3
        dwave = ncread(his,'Dwave',[1 1 i],[Inf Inf 1]);
        tmp = ncread(his,'Hwave',[1 1 i],[Inf Inf 1]);
        ubar = cos(pi*dwave/180);
        vbar = sin(pi*dwave/180);
        if wet_dry == 1
            wetdry_mask_rho = ncread(his,'wetdry_mask_rho',[1 1 i],[Inf Inf 1]);
            wetdry_mask_rho = wetdry_mask_rho ./wetdry_mask_rho;
            tmp = tmp .* wetdry_mask_rho;
        end
    elseif id == 4
        ubar = ncread(his,'u',[1 1 Nz i],[Inf Inf 1 1]).*mask_u;
        vbar = ncread(his,'v',[1 1 Nz i],[Inf Inf 1 1]).*mask_v;
        tmp = ncread(his,'temp',[1 1 Nz i],[Inf Inf 1 1]);  % Surface
    elseif id == 5
        ubar = ncread(his,'u',[1 1 Nz i],[Inf Inf 1 1]).*mask_u;
        vbar = ncread(his,'v',[1 1 Nz i],[Inf Inf 1 1]).*mask_v;
        tmp = ncread(his,'zeta',[1 1 i],[Inf Inf 1]).*mask_rho;
    elseif id == 6
        ubar = ncread(his,'u',[1 1 Nz i],[Inf Inf 1 1]).*mask_u;
        vbar = ncread(his,'v',[1 1 Nz i],[Inf Inf 1 1]).*mask_v;
        tmp = ncread(his,'salt',[1 1 Nz i],[Inf Inf 1 1]);  % Surface
    elseif id == 7
        if F_drawUV
            ubar = ncread(his,'u',[1 1 Nz i],[Inf Inf 1 1]).*mask_u;
            vbar = ncread(his,'v',[1 1 Nz i],[Inf Inf 1 1]).*mask_v;
        end
        tmp = ncread(his,ncname,[1 1 Nz i],[Inf Inf 1 1]);  % Surface
    elseif id == 100
        ubar = ncread(his1,'Uwind',[1 1 i],[Inf Inf 1]);
        vbar = ncread(his2,'Vwind',[1 1 i],[Inf Inf 1]);
    end


    if id <100
        date=starting_date+time(i)/24/60/60;
    else
        date=starting_date+time(i);
    end
    date_str=strcat(datestr(date,31),'  ',LOCAL_TIME);

    if id == 1 || id == 2
        ubar2(1:Im, 1:Jm)=NaN;
        ubar2(2:Im, 1:Jm)=ubar;%.*scale;
        vbar2(1:Im, 1:Jm)=NaN;
        vbar2(1:Im, 2:Jm)=vbar;%.*scale;
        tmp=hypot(ubar2,vbar2);
    elseif id == 3
        ubar2=ubar;
        vbar2=vbar;
        vel=hwave;
    elseif id == 100
        ubar2=ubar;
        vbar2=vbar;
        tmp=hypot(ubar2,vbar2);
    else
        if F_drawUV
            ubar2(1:Im, 1:Jm)=NaN;
            ubar2(2:Im, 1:Jm)=ubar;%.*scale;
            vbar2(1:Im, 1:Jm)=NaN;
            vbar2(1:Im, 2:Jm)=vbar;%.*scale;
        end
    end

    if F_drawUV
        % Down sampling
        ubar3=ubar2(1:s_interval:Im,1:s_interval:Jm);
        vbar3=vbar2(1:s_interval:Im,1:s_interval:Jm);
    end
    
    set(h_surf,'CData',tmp)
    if F_drawUV
        set(h_quiver,'UData',ubar3*scale)
        set(h_quiver,'VData',vbar3*scale)
    end
    set(h_annot,'String',date_str)

    drawnow
    
    fname = strcat( ncname, datestr(date,'_yyyymmddHHMM') );
    hgexport(figure(1), strcat(out_dirstr,'/', fname,'.png'),hgexport('factorystyle'),'Format','png');
%     hgexport(figure(1), strcat('output/figs_eps/', fname,'.eps'),hgexport('factorystyle'),'Format','eps');

end


