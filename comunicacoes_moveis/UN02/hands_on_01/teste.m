constellation = [-3-3i, -3-1i, -3+3i, -3+1i;
                -1-3i, -1-1i, -1+3i, -1+1i;
                 3-3i,  3-1i,  3+3i,  3+1i;
                 1-3i,  1-1i,  1+3i,  1+1i];
input_symbols = [1, 2, 3, 4, 5, 6];  % Exemplo de vetor de símbolos
N = length(input_symbols);
num_cols = ceil(N/4);  % Número de colunas da matriz
symbol_indices = reshape(input_symbols, 4, num_cols);  % Transforma em matriz 4xN
indices = 2*real(symbol_indices) + real(symbol_indices > 0) + 1i*(2*imag(symbol_indices) + imag(symbol_indices > 0));  % Obtém os índices na constelação 
modulated_signal = ifft(indices);