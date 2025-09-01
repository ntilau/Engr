function QAD_viewresults(mesh,results);

[point,ele,spig,nlab,elab,slab,NNODE,NELE,NSPIG]=ReadMesh(mesh);
[res,N,type] = readcres(results);

cmap = colormap;
mav = max (abs(res));
miv = min (abs(res));

for i = 1:NNODE
    rcolor(i,:) = cmap(ceil(64*(abs(res(i))-miv+1)/(mav-miv+1)),:);
end

scatter(point(1,:)',point(2,:)',5,res);
figure

for i = 1:NELE
    cd(1,1,:) = rcolor(ele(2,i),:);
    cd(1,2,:) = rcolor(ele(3,i),:);
    cd(1,3,:) = rcolor(ele(4,i),:);
    patch('XData',[point(1,ele(2,i)),point(1,ele(3,i)),point(1,ele(4,i))]',...
        'YData',[point(2,ele(2,i)),point(2,ele(3,i)),point(2,ele(4,i))]',...
        'CData',cd,'FaceColor','interp','EdgeColor','interp');
end
