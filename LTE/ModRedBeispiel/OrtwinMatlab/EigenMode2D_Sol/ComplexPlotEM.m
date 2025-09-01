function zz=ComplexPlotEM(f, Value, FormString)


z_real = [];
f_real = [];
z_imag = [];
f_imag = [];

for n=1:length(Value),
  if real(Value(n))~=0,
    z_real = [z_real, -abs(real(Value(n)))];
    f_real = [f_real, f(n)];
  end
  if imag(Value(n))~=0,
    z_imag = [z_imag, abs(imag(Value(n)))];
    f_imag = [f_imag, f(n)];
  end
end

plot(f_imag,z_imag, FormString);
plot(f_real,z_real, FormString);