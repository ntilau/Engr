% calculates absolute value from dB
function abs_val = invdb(db_val)

abs_val = 10^(db_val/20);
