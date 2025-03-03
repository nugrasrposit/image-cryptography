% Kelompok 4
% Nama Anggota : 
% Tegar Dwi Nugraha (02231017)
% Via Eklesiana Sinaga (02231018)
% Wulan Dian Lestari (02231020)
% Wulandari Aryannisa (02231021)

% KRIPTOGRAFI CITRA %

image = imread('itk-view.jpeg');

if ndims(image) == 3
    R = image(:, :, 1);
    G = image(:, :, 2);
    B = image(:, :, 3);
    gray_image = rgb2gray(image);
else
    gray_image = image;
    R = gray_image;
    G = gray_image;
    B = gray_image;
end

matrix = double(gray_image);

key = 76;
shift_value = 3;

substituted_matrix = mod(matrix + shift_value, 256);
encrypted_substituted_matrix = bitxor(substituted_matrix, key);

[row, col] = size(encrypted_substituted_matrix);
perm_row = randperm(row);
perm_col = randperm(col);
transposed_encrypted_matrix = encrypted_substituted_matrix(perm_row, perm_col);

inverse_perm_row = zeros(1, row);
inverse_perm_col = zeros(1, col);
inverse_perm_row(perm_row) = 1:row;
inverse_perm_col(perm_col) = 1:col;

decrypted_transposed_matrix = transposed_encrypted_matrix(inverse_perm_row, inverse_perm_col);

decrypted_substituted_matrix = bitxor(decrypted_transposed_matrix, key);
decrypted_matrix = mod(decrypted_substituted_matrix - shift_value, 256);

decrypted_grayscale = uint8(decrypted_matrix);

decrypted_image = cat(3, ...
    uint8(double(decrypted_grayscale) .* (double(R) ./ double(gray_image))), ...
    uint8(double(decrypted_grayscale) .* (double(G) ./ double(gray_image))), ...
    uint8(double(decrypted_grayscale) .* (double(B) ./ double(gray_image))));

decrypted_image(isnan(decrypted_image)) = 0;
decrypted_image(isinf(decrypted_image)) = 0;

if isequal(uint8(image), decrypted_image)
    disp('Dekripsi berhasil! Gambar asli dan hasil dekripsi identik.');
else
    disp('Dekripsi gagal! Matriks asli dan hasil dekripsi berbeda.');
end

close all;
figure;

subplot(2, 3, 1);
imshow(image);
title('Gambar Asli');
imwrite(image, 'Gambar_Asli.jpeg');

subplot(2, 3, 2);
imshow(gray_image);
title('Gambar Grayscale');
imwrite(gray_image, 'Gambar_Grayscale.jpeg');

subplot(2, 3, 3);
imshow(uint8(substituted_matrix));
title('Hasil Substitusi');
imwrite(uint8(substituted_matrix), 'Hasil_Substitusi.jpeg');

subplot(2, 3, 4);
imshow(uint8(transposed_encrypted_matrix));
title('Hasil Transposisi');
imwrite(uint8(transposed_encrypted_matrix), 'Hasil_Transposisi.jpeg');

subplot(2, 3, 5);
imshow(decrypted_grayscale);
title({'Hasil Dekripsi'; '(Grayscale)'});
imwrite(decrypted_grayscale, 'Hasil_Dekripsi_Grayscale.jpeg');

subplot(2, 3, 6);
imshow(decrypted_image);
title({'Hasil Dekripsi'; '(RGB)'});
imwrite(decrypted_image, 'Hasil_Dekripsi_RGB.jpeg');

