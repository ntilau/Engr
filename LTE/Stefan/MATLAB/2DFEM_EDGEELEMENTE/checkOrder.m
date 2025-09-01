function num = checkOrder(order)

if order == 1
    num = 3 ;
elseif order == 2
    num = 8 ;
elseif order == 3
    num = 15 ;
% elseif order == 4
%     num = 24 ;
else
    error( 'order must be between 1..4' );
end