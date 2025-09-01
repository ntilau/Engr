function s = segno(a,b,p)

% La funzione segno determina 
% in quale dei due semipiani 
% individuati dalla retta passante 
% per p1 e p2 si trova il punto p3 
% 
% IN: 
% a = [xa;ya]
% b = [xb;yb]
% p = [xp;yp]
% 
% OUT:
% s  

c = p(1)*(a(2)-b(2))-p(2)*(a(1)-b(1))+a(1)*b(2)-a(2)*b(1);
if abs(c) < 1e-6
%     p è allineato coi punti a e b
    s = 0;
elseif c > 0
%     p si trova in un semipiano
    s = 1;
else
%     p si trova nel semipiano opposto
    s = -1;
end