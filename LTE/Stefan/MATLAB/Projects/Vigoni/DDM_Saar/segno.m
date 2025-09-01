function s = segno(a,b,c,p)

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

% inc = 1e-11 ;
inc = 1e-8 ;

x = p(1) ;
y = p(2) ;
x1 = a(1) ;
y1 = a(2) ;
x2 = b(1) ;
y2 = b(2) ;
x3 = c(1) ;
y3 = c(2) ;

A1 = 0.5 * abs(det([x  y  1 ; x1 y1 1 ; x2 y2 1])) ;
A2 = 0.5 * abs(det([x  y  1 ; x2 y2 1 ; x3 y3 1])) ;
A3 = 0.5 * abs(det([x  y  1 ; x3 y3 1 ; x1 y1 1])) ;
A  = 0.5 * abs(det([x1 y1 1 ; x2 y2 1 ; x3 y3 1])) ;
tmpVal = (A1+A2+A3)/A ;


if (tmpVal < 1+inc)&&(tmpVal > 1-inc)  %abs(c) < 1e-9
% innen
    s = 0;
else
% nicht innen
    s = 1;
end

% % c = p(1)*(a(2)-b(2))-p(2)*(a(1)-b(1))+a(1)*b(2)-a(2)*b(1);
% % if abs(c) < 1e-9
% % %     p è allineato coi punti a e b
% %     s = 0;
% % elseif c > 0
% % %     p si trova in un semipiano
% %     s = 1;
% % else
% % %     p si trova nel semipiano opposto
% %     s = -1;
% % end