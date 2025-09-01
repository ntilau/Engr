% Examination of WCAWE for polynomial matrix equations

% clear all;
% close all;

dim = 10;
order = 7;

% initial problem: (s*A1 + s^2*A2)*x = b
b = randn(dim,1)
A1 = randn(dim)
A2 = randn(dim)

% ordinary AWE
W(:,1) = b;
W(:,2) = A1*W(:,1);
for k=3:order
    W(:,k) = A1*W(:,k-1) + A2*W(:,k-2);
end
W
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
[V U] = qr(V_,0)
for q=3:order
    e1 = zeros(q-2,1);
    e1(q-2,1) = 1;
    PU = PU_Generation(U,2,q,2);
    V_(:,q) = A1*V(:,q-1) + A2*V(:,1:(q-2))*PU*e1;
	[V U] = qr(V_,0);
end
V


