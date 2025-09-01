function seeDD(eleDD,xy,MESH,NDD)

    color = ['r','m','b','g','c'];
    % Plotting della mesh
    figure;
    hold on;
    for id = 1:NDD
        elem = eleDD(2:4,id);
        for ie = 1:size(MESH{id}.ele,2)
             elem = MESH{id}.ele(2:4,ie);
             X = xy(1,elem);
             Y = xy(2,elem);
             if id == NDD
                 patch(X,Y,'y');
             else
                 patch(X,Y,color(mod(id,4)+1));
             end
        end
        axis equal;
    end
    hold off;
