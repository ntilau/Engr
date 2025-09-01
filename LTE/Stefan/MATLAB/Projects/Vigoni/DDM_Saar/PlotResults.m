function PlotResults(field,xy,type,strtitle)
if strcmp(lower(type),'nodal')
    minx=min(xy(1,:));
    maxx=max(xy(1,:));
    miny=min(xy(2,:));
    maxy=max(xy(2,:));
    dx=(maxx-minx)/500;
    dy=(maxy-miny)/500;
    xi=[minx:dx:maxx];
    yi=[miny:dy:maxy];
    [Xi,Yi]=meshgrid(xi,yi);
    Zi=griddata(xy(1,:),xy(2,:),field(:,1),Xi,Yi);
    figure;
    surf(Xi,Yi,Zi); 
    shading interp
    axis equal;
    title(strtitle);
    xlabel('z [mm]');
    ylabel('x [mm]');
    az = 0;
    el = 90;
    view(az, el);
    colorbar;
    return 
end