% Examination of WCAWE for polynomial matrix equations

clear all;
close all;

dim = 10;
order = 6;

% initial problem: (s*A1 + s^2*A2 + s^3*A3)*x = b
b = randn(dim,1);
A1 = randn(dim);
A2 = randn(dim);
A3 = randn(dim);
%load WCAWE_TestDat
%A3 = zeros(dim);

% ordinary AWE
W(:,1) = b;
W(:,2) = A1*W(:,1);
W(:,3) = A1*W(:,2) + A2*W(:,1);
for k = 4:order
    W(:,k) = A1*W(:,k-1) + A2*W(:,k-2) + A3*W(:,k-3);
end
% display(W);
[Q, R] = qr(W,0);


% % modified AWE
% W_(:,1) = b;
% W_(:,2) = A1*W(:,1);
% W_(:,3) = A1*W_(:,2) + A2*W_(:,1);
% %W_(:,4) = A1*W_(:,3) + A2*W_(:,2);
% for k=4:order
%     % remove projection on space W_(:,k-3)
%     oSpace = W_(:,1:k-3);
%     % attention: no orthogonal space
%     vec1 = W_(:,k-1)-oSpace*inv(oSpace'*oSpace)*oSpace'*W_(:,k-1);
%     vec2 = W_(:,k-2)-oSpace*inv(oSpace'*oSpace)*oSpace'*W_(:,k-2);
%     W_(:,k) = A1*vec1 + A2*vec2;
% %     subtr = oSpace*inv(oSpace'*oSpace)*oSpace'*W_(:,k-1);
% %     W_(:,k) = A1*(W_(:,k-1)-subtr) + A2*(W_(:,k-2)-subtr);
% end
% [Q_, R_] = qr(W_);
% Q
% Q_




% WCAWE
V_(:,1) = b;
V(:,1) = V_(:,1)/norm(V_(:,1));
U(1,1) = 1/norm(V_(:,1));
V_(:,2) = A1*V(:,1);
% [V U] = qr(V_,0);
  
% modified Gram Schmidt
q = 2;
for k = 1:(q - 1)
  proj = V(:,k)' * V_(:,q);
  V_(:,q) = V_(:,q) - proj * V(:,k);
  U(k, q) = proj;
end
normQ = norm(V_(:,q));
V(:,q) = V_(:,q) / normQ;
U(q, q) = normQ;
  
V_(:,3) = A1*V(:,2) + U(2,2)^(-1) * A2 * V(:,1);
% [V U] = qr(V_,0);

% modified Gram Schmidt
q = 3;
for k = 1:(q - 1)
  proj = V(:,k)' * V_(:,q);
  V_(:,q) = V_(:,q) - proj * V(:,k);
  U(k, q) = proj;
end
normQ = norm(V_(:,q));
V(:,q) = V_(:,q) / normQ;
U(q, q) = normQ;

for q=4:order
  e1 = zeros(q-2,1);
  e1(q-2,1) = 1;
  e2 = zeros(q-3,1);
  e2(q-3,1) = 1;
  PU1 = PU_Generation(U,2,q,2);
  PU2 = PU_Generation(U,2,q,3);
  V_(:,q) = A1*V(:,q-1) + A2*V(:,1:(q-2))*PU1*e1 ...
    + A3*V(:,1:(q-3))*PU2*e2;
  % modified Gram Schmidt
  for k = 1:(q - 1)
    proj = V(:,k)' * V_(:,q);
    V_(:,q) = V_(:,q) - proj * V(:,k);
    U(k, q) = proj;
  end
  normQ = norm(V_(:,q));
  V(:,q) = V_(:,q) / normQ;
  U(q, q) = normQ;    
%   [V U] = qr(V_,0);
end


C = inv(V'*W);
D = V' * W;
R = inv(D)*U;
display(C);
display(R);



% d_new = vectorReader('V:\Ortwin\Alwin_moreDoF\WaveguideB\D_new');
% d_old = vectorReader('V:\Ortwin\Alwin_moreDoF\WaveguideB\D_old');
% d_new_new_wrMa = vectorReader('V:\Ortwin\Alwin_moreDoF\WaveguideB\D_new_new_wrMa');
% d_new_new_wrUnMa = vectorReader('V:\Ortwin\Alwin_moreDoF\WaveguideB\D_new_new_wrUnMa');
% length(find(d_new == 0))
% length(find(d_old == 0))
% length(find(d_new_new_wrMa == 0))
% length(find(d_new_new_wrUnMa == 0))

t = 0.288;
a = 2.288;
w = a - t;
H = 1.7;
Da = 1;
Ls = 5;
x2 = t + (w - H) / 2;
x1 = t + (w - 0.1) / 2;
z1 = 0.5 + Da + 0.5;
z2 = 0.5 + Da + 0.5 + Ls;
R = 0.3;
c1 = (x2 - x1) / (exp(R * z2) - exp(R * z1));
display(c1);
c2 = (x1 * exp(R * z2) - x2 * exp(R * z1)) / (exp(R * z2) - exp(R * z1));
display(c2);

z = z1:0.01:z2;
x = c1 * exp(R * z) + c2;
plot(x, z);



