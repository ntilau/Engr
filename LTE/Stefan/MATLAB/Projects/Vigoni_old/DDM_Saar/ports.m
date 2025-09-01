function [PO]=ports(nlab,point,Np,NNODE,dim,Lp)
%
%builds the vector of the nodes on each port
%
%initialization
PO_0=zeros(1,Np);
%finds nodes on ports ip
for i=1:NNODE
    for ip=1:Np
        if(nlab(i)==Lp(ip))
            %the node is on the ip port
            PO_0(ip)            =   PO_0(ip)+1;
            PO(PO_0(ip),ip)     =   i;
        end
    end
end
%Sort PO so that nodes are adiacent
for ip=1:Np
    if(abs(point(1,PO(1,ip))-point(1,PO(2,ip)))> dim(ip)*10^-3)
        for i=1:PO_0(ip)
            for j=i+1:PO_0(ip)
                if(point(1,PO(i,ip))>point(1,PO(j,ip)))
                    iaux=PO(i,ip);
                    PO(i,ip)=PO(j,ip);
                    PO(j,ip)=iaux;
                end
            end
        end
    else
        for i=1:PO_0(ip)
            for j=i+1:PO_0(ip)
                if(point(2,PO(i,ip))>point(2,PO(j,ip)))
                    iaux=PO(i,ip);
                    PO(i,ip)=PO(j,ip);
                    PO(j,ip)=iaux;
                end
            end
        end
    end
end
PO=[PO;PO_0];

