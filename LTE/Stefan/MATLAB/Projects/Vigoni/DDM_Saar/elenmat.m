function  [Se,Te] =   elenmat(point,ele,ie,lds,ldt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CONSTRUCTS THE MATRICES FOR NODAL ELEMENTS   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------Element point definition
%mapping the global element nodes on the local ones
Eo  =   ele(1,ie);
for i=2:(Eo+1)
    epoint((i-1),1) =   point(1,ele(i,ie)); %valore di x
    epoint((i-1),2) =   point(2,ele(i,ie)); %valore di y
end

if(Eo==3)
    %----------First order triangular element
    [Se,Te]=elent1(epoint,lds,ldt);
elseif(Eo==6)
    %----------Second order triangular element
    [Se,Te]=elent2(epoint,lds,ldt);
elseif(Eo==4)
    %----------First order Quarilateral element
    [Se,Te]=elenq1(epoint,lds,ldt);
elseif(Eo==8)
    %----------Second order Quadrilateral element
    [Se,Te]=elenq2(epoint,lds,ldt);
end
%--------------------------END-OF-MAIN-CODE---------------------------% 


%---------------------------------------------------------------------%
%--------------------------Auxiliary Functions------------------------%
%---------------------------------------------------------------------%
function [Se,Te]=elent1(epoint,lds,ldt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CONSTRUCTS THE LOCAL MATRICES Se AND Te FOR  % 
%   A FIRST ORDER TRIANGULAR ELEMENTS            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------Output squared mixed 
Se=zeros(lds);
Te=zeros(ldt);

if(lds<3 | ldt<3)
    disp('**ERROR IN CALLING SUBROUTINE ELENT1**');
    return
end

area = ((epoint(2,1)-epoint(1,1))*(epoint(3,2)-epoint(1,2))-(epoint(3,1)-epoint(1,1))*(epoint(2,2)-epoint(1,2)))/2;

%-------------------------Template variables
dx(1) =   epoint(3,1)-epoint(2,1);
dx(2) =   epoint(1,1)-epoint(3,1);
dx(3) =   epoint(2,1)-epoint(1,1);
dy(1) =   epoint(2,2)-epoint(3,2);
dy(2) =   epoint(3,2)-epoint(1,2);
dy(3) =   epoint(1,2)-epoint(2,2);

%-------------------------Compute the matrices entries
for i=1:3
    for j=1:i
        Se(i,j) =   (dy(i)*dy(j)+dx(i)*dx(j))/4/area;
        Se(j,i) =   Se(i,j);
        Te(i,j) =   area/12;
        Te(j,i) =   Te(i,j);
    end
    Te(i,i) =   2*Te(i,i);
end
%-------------------------End of elent1-----------------------------------%

%-------------------------Begin elent2------------------------------------%
function [Se,Te]=elent2(ep,lds,ldt)
TD=[6   0   0   -1  -4  -1
    0   32  16  0   16  -4
    0   16  32  -4  16  0   
    -1  0   -4  6   0   -1
    -4  16  16  0   32  0
    -1  -4  0   -1  0   6];

SD=[0   0   0   0   0   0
    0   8   -8  0   0   0   
    0   -8  8   0   0   0
    0   0   0   3   -4  1
    0   0   0   -4  8   -4
    0   0   0   1   -4  3]

if lds<6 &ldt<6
    disp('ERROR in calling elent2 function !');
end

A=((ep(4,1)-ep(1,1))*(ep(6,2)-ep(1,2))-(ep(6,1)-ep(1,1))*(ep(4,2)-ep(1,2)))/2;

Co(1)=((ep(4,1)-ep(1,1))*(ep(6,1)-ep(1,1))+(ep(4,2)-ep(1,2))*(ep(6,2)-ep(1,2)))/2/A;
Co(2)=((ep(6,1)-ep(4,1))*(ep(1,1)-ep(4,1))+(ep(6,2)-ep(4,2))*(ep(1,2)-ep(4,2)))/2/A;
Co(3)=((ep(1,1)-ep(6,1))*(ep(4,1)-ep(6,1))+(ep(1,2)-ep(6,2))*(ep(4,2)-ep(6,2)))/2/A;

Te=A*TD/180;
for i=1:6
    for j=1:i
        Se(i,j)=(Co(1)*SD(ir6(i,0),ir6(j,0))+Co(2)*SD(ir6(i,1),ir6(j,1))+Co(3)*SD(ir6(i,2),ir6(j,2)))/6;
        Se(j,i)=Se(i,j);    
    end
end

%----------------------------------------------------------------------------------------------
function it =   ir6(i,n)

itwist=[6,3,5,1,2,4];
it=1;
for j=1:n
    it=itwist(it);
end
%-------------------------End elent2--------------------------------------%


%-------------------------Begin elenq1------------------------------------%
function [Se,Te]=elenq1(epoint,lds,ldt)
wq=[0.2369269,0.4786287,0.5688889,0.4786287,0.2369269];
sq=[-0.9061799,-0.5384693,0.0000000,0.5384693,0.9061799];
if(lds<4 | ldt<4)
    disp('**ERROR IN CALLING SUBROUTINE ELENQ1**');
    return
end

Se=zeros(4,4);
Te=zeros(4,4);

for m=[1,2,3,4,5]
    for n=[1,2,3,4,5]
        u=sq(m);
        v=sq(n);
        [shape,shapedu,shapedv,Tjti,detj]=iso4(epoint,lds,u,v);
        for i=[1,2,3,4]
            for j=1:i
                Te(i,j)=Te(i,j)+wq(m)*wq(n)*shape(i)*shape(j)*detj;
                sum=shapedu(i)*shapedu(j)*Tjti(1,1)+...
                    shapedu(i)*shapedv(j)*Tjti(1,2)+...
                    shapedv(i)*shapedu(j)*Tjti(2,1)+...
                    shapedv(i)*shapedv(j)*Tjti(2,2);
                Se(i,j)=Se(i,j)+wq(m)*wq(n)*sum*detj;
            end
        end
    end
end
for i=[1,2,3,4]
    for j=1:i
        Te(j,i)=Te(i,j);
        Se(j,i)=Se(i,j);
    end
end
return

%-------------------------End elenq1--------------------------------------%

function [shape,shapedu,shapedv,Tjti,detj]=iso4(epoint,lde,u,v)

%interpolation functions for 8-noded element
shape   =   0.25*[(u-1)*(v-1),...
                 -(u+1)*(v-1),...
                  (u+1)*(v+1),...
                 -(u-1)*(v+1)];
%function derivatives with respect to u
shapedu =   0.25*[(v-1),-(v-1),(v+1),-(v+1)];
%function derivatives with respect to v
shapedv =   0.25*[(u-1),-(u+1),(u+1),-(u-1)];
%compute the jacobian
Tj(1,1) = shapedu(1,:)*epoint(:,1);
Tj(1,2) = shapedu(1,:)*epoint(:,2);
Tj(2,1) = shapedv(1,:)*epoint(:,1);
Tj(2,2) = shapedv(1,:)*epoint(:,2);
detj    = Tj(1,1)*Tj(2,2)-Tj(1,2)*Tj(2,1);
Tji(1,1)=   Tj(2,2)/detj;
Tji(1,2)=  -Tj(1,2)/detj;
Tji(2,1)=  -Tj(2,1)/detj;
Tji(2,2)=   Tj(1,1)/detj;
Tjti    =   Tji'*Tji;
return