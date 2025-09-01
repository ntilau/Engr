function [node,fields]=DrawFields(sfnamefem,sfnameres,flag)

%   sfnamefem: Nome del file contenente le informazioni sul meshing 
%   sfnameres: Nome del file contenente le informazioni sul campo calcolato

type    =   0;
N       =   0;
if nargin<3
    flag=-90;
end

%read result field file
disp(['+------Reading ',sfnameres,' file']);
pfres=fopen(sfnameres,'r');
str=fscanf(pfres,'%s',2);
if strcmp(str,'Type=')|strcmp(str,'type=')
    type= fscanf(pfres,'%i',1);
else
    disp('*****ERROR***** missing type information');
    return
end
str=fscanf(pfres,'%s',2);
if strcmpi(str,'number=')
    N= fscanf(pfres,'%i',1);
else
    disp('*****ERROR***** missing number information');
    return
end
fields = fscanf(pfres,'%*i %f',[1 inf]);
fclose(pfres);
%read meshing inforation file 
disp(['+------Reading ',sfnamefem,' file']);
pffem=fopen(sfnamefem,'r');
fgets(pffem);
str=fscanf(pffem,'%s',2);
if strcmp(str,'Elements=')|strcmp(str,'elements=')
    NELE= fscanf(pffem,'%i',1);
else
    disp('*****ERROR***** missing Elements number information');
    return
end
str=fscanf(pffem,'%s',2);
if strcmp(str,'Nodes=')|strcmp(str,'nodes=')
    NNODE= fscanf(pffem,'%i',1);
else
    disp('*****ERROR***** missing Node number information');
    return
end
str=fscanf(pffem,'%s',2);
if strcmp(str,'Edges=')|strcmp(str,'edges=')
    NSPIG= fscanf(pffem,'%i',1);
else
    disp('*****ERROR***** missing Edges number information');
    return
end

fgets(pffem);
fgets(pffem);
for i=1:NELE
    fscanf(pffem,'%*i',1);
    ele(1,i)=fscanf(pffem,'%i',1);
    for j=2:ele(1,i)+1
        ele(j,i)=fscanf(pffem,'%i',1);        
    end
    elab(i)=fscanf(pffem,'%i',1);
end
fgets(pffem);
fgets(pffem);
for i=1:NNODE
    fscanf(pffem,'%*i',1);
    node(1,i)=fscanf(pffem,'%f',1);
    node(2,i)=fscanf(pffem,'%f',1);
    nlab(i)=fscanf(pffem,'%i',1);
end
fgets(pffem);
fgets(pffem);
for i=1:NELE
    fscanf(pffem,'%*i',1);
    spig(1,i)=fscanf(pffem,'%i',1);
    for j=2:spig(1,i)+1
        spig(j,i)=fscanf(pffem,'%i',1);        
    end
end
fgets(pffem);
fgets(pffem);
for i=1:NSPIG
    fscanf(pffem,'%*i',1);
    slab(i)=fscanf(pffem,'%i',1);
end
fclose(pffem);

%Nodal field values
pfout=fopen('plot.out','w');
if type==1
    if N<NNODE | N>NNODE
        disp(['***ERROR*** Node number in ',sfnamefem,' and ',sfnameres,' must be equal.'])
        return
    end
    for i=1:N
        fprintf(pfout,'%f %f %f\n',node(1,i),node(2,i),fields(i));
    end
    minx=min(node(1,:));
    maxx=max(node(1,:));
    miny=min(node(2,:));
    maxy=max(node(2,:));
    dx=(maxx-minx)/50;
    dy=(maxy-miny)/50;
    xi=[minx:dx:maxx];
    yi=[miny:dy:maxy];
    [Xi,Yi]=meshgrid(xi,yi);
    Zi=griddata(node(1,:),node(2,:),fields(:),Xi,Yi);
    surf(Xi,Yi,Zi); shading interp
    %az = 0;
    %el = 90;
    %view(az, el);
    [c,h]=contour(Xi,Yi,Zi,100);
    colorbar;
    %clabel(c,h)
    hold on
    r1x=[0 0.25 0.25 0];
    r1y=[-0.5 -0.5 0 0];
    r2x=0.75+[0 0.25 0.25 0];
    r2y=[-0.5 -0.5 0 0];
    surf(r1x,r1y,2*ones(4));
    surf(r2x,r2y,2*ones(4));
    hold off
end
fclose(pfout);
if flag > -90
    pfout=fopen('estratto.txt','w');
    for i=1:N
        y=node(2,i);
        if abs(y-flag)<1e-4
            x=node(1,i);
            f=fields(i);
            fprintf(pfout,'%f\t%f\n',x,f);
        end
    end
    fclose(pfout);
end