function t = test(v,p)

% La funzione test determina se il punto p è interno, esterno o sul bordo
% del triangolo individuato dai vertici v.
% IN:
% v = [x1 x2 x3;
%      y1 y2 y3]
% OUT:
% t = 1 interno; -1 esterno; 0 sul bordo


s = segno(v(:, 1), v(:, 2), v(:, 3), p) ;

if s == 0
%     il punto è esterno
    t = 1;
else
%     il punto è interno
    t = 0;
end

% % 
% % s1 = segno(v(:,1),v(:,2),v(:,3))*segno(v(:,1),v(:,2),p);
% % s2 = segno(v(:,2),v(:,3),v(:,1))*segno(v(:,2),v(:,3),p);
% % s3 = segno(v(:,3),v(:,1),v(:,2))*segno(v(:,3),v(:,1),p);
% % if s1 < 0 | s2 < 0 | s3 < 0
% % %     il punto è esterno
% %     t = -1;
% % elseif s1 > 0 & s2 > 0 & s3 > 0
% % %     il punto è interno
% %     t = 1;
% % else
% % %     il punto è sul bordo
% %     t = 0;
% % end