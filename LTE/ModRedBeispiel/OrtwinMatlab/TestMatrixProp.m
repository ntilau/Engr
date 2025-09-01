% Test of matrix properties

dim=5;

C=zeros(dim)
for k=1:dim
  C(k,k)=k-3;
end


A=zeros(dim,dim)
B=zeros(dim,dim)
for k=1:dim
  for l=1:k
    A(k,l)=rand(1)+j*rand(1);
    A(l,k)=conj(A(k,l));
    B(k,l)=rand(1)+j*rand(1);
    B(l,k)=B(k,l);
  end
end
A
[X D]=eig(A);
X'*X
X.'*X
B
[V,D] = eig(A,B)
V.'*A*V
V'*A*V

