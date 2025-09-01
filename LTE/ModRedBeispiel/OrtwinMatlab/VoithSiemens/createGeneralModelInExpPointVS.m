function modelInExpPnt = createGeneralModelInExpPointVS(model, expPnt)


modelInExpPnt.sysMat = createCellArrayInExpPoint(model.sysMat, model.coeffSequence, expPnt);
modelInExpPnt.rhs = createCellArrayInExpPoint(model.rhs, model.coeffSequence, expPnt);
modelInExpPnt.outputFunctional = createCellArrayInExpPoint(model.outputFunctional, model.coeffSequence, expPnt);
modelInExpPnt.coeffSequence = model.coeffSequence;


function cellArrayInExpPnt = createCellArrayInExpPoint(cellArray, coeffSequence, expPnt)

numParams = size(coeffSequence, 2);
cellArrayInExpPnt = cell(size(cellArray));

for coeffCnt = 1 : size(coeffSequence, 1)
  if coeffCnt <= length(cellArray)
    if nnz(cellArray{coeffCnt})
      polynomial = cell(1, numParams);
      for paramCnt = 1 : numParams
        % compute (univariate) polynomial = (expPnt(paramCnt) + deltaParam(paramCnt)) ^ coeffSequence(coeffCnt, paramCnt)
        polynomial{paramCnt} = binomialTheorem(expPnt(paramCnt), coeffSequence(coeffCnt, paramCnt));
      end
      for coeffCntProduct = 1 : coeffCnt
        scale = 1;
        for paramCntProduct = 1 : numParams
          if length(polynomial{paramCntProduct}) >= coeffSequence(coeffCntProduct, paramCntProduct) + 1
            scale = scale * polynomial{paramCntProduct}(coeffSequence(coeffCntProduct, paramCntProduct) + 1);
          else
            scale = 0;
          end
        end
        if isempty(cellArrayInExpPnt{coeffCntProduct})
          cellArrayInExpPnt{coeffCntProduct} = scale * cellArray{coeffCnt};
        else
          cellArrayInExpPnt{coeffCntProduct} = cellArrayInExpPnt{coeffCntProduct} + scale * cellArray{coeffCnt};
        end
      end
    end
  end
end
