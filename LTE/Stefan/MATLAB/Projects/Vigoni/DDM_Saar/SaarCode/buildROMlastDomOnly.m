function ROM = buildROMlastDomOnly(unredModel, solVecs)

numParams = length(size(solVecs));
numModes = size(solVecs{1, 1}, 2);

Q = zeros(length(solVecs{1, 1, 1}), size(solVecs, 1) * size(solVecs, 2) * size(solVecs, 3) * numModes);

% orthogonalize solution vectors using modified Gram-Schmidt
currentCol = 1;
for p1Cnt = 1 : size(solVecs, 1)
    for p2Cnt = 1 : size(solVecs, 2)
        for p3Cnt = 1 : size(solVecs, 3)
            for modeCnt = 1 : numModes
                if currentCol == 1
                    Q(:, 1) = solVecs{1, 1, 1}(:, 1) / norm(solVecs{1, 1, 1}(:, 1));
                    currentCol = 2;
                else
                    % Q(:, currentCol) = modifiedGramSchmidt(Q(:, (1 : (currentCol - 1))), solVecs{p1Cnt, p2Cnt}(:, modeCnt));
                    Q(:, currentCol) = solVecs{p1Cnt, p2Cnt, p3Cnt}(:, modeCnt);
                    currentCol = currentCol + 1;
                end
            end
        end
    end
end

[U R] = qr(Q, 0);

ROM.A0 = U' * unredModel.A0 * U;
ROM.Aeps = U' * unredModel.Aeps * U;
ROM.Anu = U' * unredModel.Anu * U;

ROM.rhsVec = U' * unredModel.rhsVec;
ROM.leftVec = U' * unredModel.leftVec;

% only for field visualization
ROM.U = U;
