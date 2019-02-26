function descriptoriExempleNegative = obtineDescriptoriExempleNegative(parametri)
% descriptoriExempleNegative = matrice MxD, unde:
%   M = numarul de exemple negative de antrenare (NU sunt fete de oameni),
%   M = parametri.numarExempleNegative
%   D = numarul de dimensiuni al descriptorului
%   in mod implicit D = (parametri.dimensiuneFereastra/parametri.dimensiuneCelula)^2*parametri.dimensiuneDescriptorCelula

imgFiles = dir( fullfile( parametri.numeDirectorExempleNegative , '*.jpg' ));
numarImagini = length(imgFiles);

numarExempleNegative_pe_imagine = ceil(parametri.numarExempleNegative/numarImagini);
descriptoriExempleNegative = zeros(parametri.numarExempleNegative,(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG)^2*parametri.dimensiuneDescriptorCelula);
disp(['Exista un numar de imagini = ' num2str(numarImagini) ' ce contine numai exemple negative']);
contor = 0;
for idx = 1:numarImagini
    disp(['Procesam imaginea numarul ' num2str(idx)]);
    img = imread([parametri.numeDirectorExempleNegative '/' imgFiles(idx).name]);
    if size(img,3) == 3
        img = rgb2gray(img);
    end 
    
    for j = 1:numarExempleNegative_pe_imagine
        x = randi(size(img,2) - parametri.dimensiuneFereastra + 1);
        y = randi(size(img,1) - parametri.dimensiuneFereastra + 1);
        
        fereastra = img(y:y + parametri.dimensiuneFereastra - 1, x:x + parametri.dimensiuneFereastra - 1);
        descriptorHOG_fereastra = vl_hog(single(fereastra), parametri.dimensiuneCelulaHOG);
        contor = contor + 1;
        descriptoriExempleNegative(contor,:) = descriptorHOG_fereastra(:);
    end
    
end