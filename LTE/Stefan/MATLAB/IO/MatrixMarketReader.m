function Mat = MatrixMarketReader(filename)

Mat = mmread(filename);     % is faster than old code
