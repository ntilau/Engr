

void buildSymmetricCSR_Structure(double* A_values_sym, int* A_ja_sym, int* A_ia_sym, int nnz_sym, int n_col, 
                                 double* A_valuesR, mwIndex* A_ja, mwIndex* A_ia)
{
  size_t i, j, k, kk;
  /* build symmetric CSR structure */  
  k = 0;
  A_ia_sym[0] = 1;
  for (i = 0 ; i < n_col ; i++) {
    kk = 0;
    for (j = A_ia[i] ; j < A_ia[i+1] ; j++) {
    /* upper part */
      if (A_ja[j] >= i) {
        A_ja_sym[k] = (int)(A_ja[j] + 1);
        A_values_sym[k] = A_valuesR[j];
        k +=1;
        kk +=1;
      }
    }
    A_ia_sym[i+1] =  (int)(A_ia_sym[i] + kk);
  }
}


void buildSymmetricCSR_StructureComplex(MKL_Complex16* A_values_sym, int* A_ja_sym, int* A_ia_sym, int nnz_sym, int n_col, 
                                        double* A_valuesR, double* A_valuesI, mwIndex* A_ja, mwIndex* A_ia)
{
  size_t i, j, k, kk;
  /* build symmetric CSR structure */  
  k = 0;
  A_ia_sym[0] = 1;
  for (i = 0 ; i < n_col ; i++) {
    kk = 0;
    for (j = A_ia[i] ; j < A_ia[i+1] ; j++) {
    /* upper part */
      if (A_ja[j] >= i) {
        A_ja_sym[k] = (int)(A_ja[j] + 1);
        A_values_sym[k].real = A_valuesR[j];
        A_values_sym[k].imag = A_valuesI[j];
        k +=1;
        kk +=1;
      }
    }
    A_ia_sym[i+1] =  (int)(A_ia_sym[i] + kk);
  }
}