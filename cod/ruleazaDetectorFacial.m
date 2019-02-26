function [detectii, scoruriDetectii, imageIdx] = ruleazaDetectorFacial(parametri)
% 'detectii' = matrice Nx4, unde 
%           N este numarul de detectii  
%           detectii(i,:) = [x_min, y_min, x_max, y_max]
% 'scoruriDetectii' = matrice Nx1. scoruriDetectii(i) este scorul detectiei i
% 'imageIdx' = tablou de celule Nx1. imageIdx{i} este imaginea in care apare detectia i
%               (nu punem intregul path, ci doar numele imaginii: 'albert.jpg')

% Aceasta functie returneaza toate detectiile ( = ferestre) pentru toate imaginile din parametri.numeDirectorExempleTest
% Directorul cu numele parametri.numeDirectorExempleTest contine imagini ce
% pot sau nu contine fete. Aceasta functie ar trebui sa detecteze fete atat pe setul de
% date MIT+CMU dar si pentru alte imagini (imaginile realizate cu voi la curs+laborator).
% Functia 'suprimeazaNonMaximele' suprimeaza detectii care se suprapun (protocolul de evaluare considera o detectie duplicata ca fiind falsa)
% Suprimarea non-maximelor se realizeaza pe pentru fiecare imagine.

% Functia voastra ar trebui sa calculeze pentru fiecare imagine
% descriptorul HOG asociat. Apoi glisati o fereastra de dimeniune paremtri.dimensiuneFereastra x  paremtri.dimensiuneFereastra (implicit 36x36)
% si folositi clasificatorul liniar (w,b) invatat poentru a obtine un scor. Daca acest scor este deasupra unui prag (threshold) pastrati detectia
% iar apoi procesati toate detectiile prin suprimarea non maximelor.
% pentru detectarea fetelor de diverse marimi folosit un detector multiscale

imgFiles = dir( fullfile( parametri.numeDirectorExempleTest, '*.jpg' ));
%initializare variabile de returnat
detectii = zeros(0,4);
scoruriDetectii = zeros(0,1);
imageIdx = cell(0,1);

for i = 1:length(imgFiles) 
    tic
    fprintf('Rulam detectorul facial pe imaginea %s\n', imgFiles(i).name)
    img = imread(fullfile( parametri.numeDirectorExempleTest, imgFiles(i).name ));    
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end
    origImg = img;    
    %completati codul functiei in continuare astfel incat sa asignati un scor ferestrelor in imagine la diferite scale
    %puneti toate ferestrele in matricea currentImg_detectii (de dimensiune nrFerestre x 4 coloane - pentru cele 4 coordonate)
    %puneti scorurile fiecarei ferestre in vectorul currentImg_scoruriDetectii (vector coloana)
    
    descriptorHOG_img = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
    nrCeluleX = parametri.dimensiuneFereastra/ parametri.dimensiuneCelulaHOG;
    nrCeluleY = nrCeluleX;
    [nrCeluleY_img,nrCeluleX_img,~] = size(descriptorHOG_img);
    
    currentImg_scoruriDetectii = zeros(1,(nrCeluleY_img - nrCeluleY + 1) * (nrCeluleY_img - nrCeluleY + 1));
    currentImg_detectii = zeros((nrCeluleY_img - nrCeluleY + 1) * (nrCeluleY_img - nrCeluleY + 1),4);
    contor = 0;
    currentImg_imageIdx = cell((nrCeluleY_img - nrCeluleY + 1) * (nrCeluleY_img - nrCeluleY + 1),1);

    for scale = 1: -0.1 :0.2
        img = imresize(origImg,scale);
    
        descriptorHOG_img = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
        nrCeluleX = parametri.dimensiuneFereastra/ parametri.dimensiuneCelulaHOG;
        nrCeluleY = nrCeluleX;
        [nrCeluleY_img,nrCeluleX_img,~] = size(descriptorHOG_img);
        
        for y = 1:nrCeluleY_img - nrCeluleY + 1
            for x = 1:nrCeluleX_img - nrCeluleX + 1
                descHOG_f = descriptorHOG_img(y : y + nrCeluleY - 1, x : x + nrCeluleX - 1,:);
                descHOG_f = descHOG_f(:);
                scor_f = sum(parametri.w .* descHOG_f) + parametri.b;
                contor = contor + 1;
                currentImg_scoruriDetectii(contor) = scor_f;
                ymin = round(((y-1)*parametri.dimensiuneCelulaHOG + 1) / scale);
                xmin = round(((x-1)*parametri.dimensiuneCelulaHOG + 1) / scale);
                ymax = ymin + round((parametri.dimensiuneFereastra - 1) / scale);
                xmax = xmin + round((parametri.dimensiuneFereastra - 1) / scale);
                currentImg_detectii(contor,:) = [xmin,ymin,xmax,ymax];
                currentImg_imageIdx{contor}=imgFiles(i).name;
            end
        end
    end
            
    %aplica nms
    ndx = find(currentImg_scoruriDetectii>parametri.threshold);
    currentImg_detectii = currentImg_detectii(ndx,:);
    currentImg_scoruriDetectii = currentImg_scoruriDetectii(ndx);
    currentImg_imageIdx = currentImg_imageIdx(ndx);
    
    
    %suprimeaza non-maximele  
    if size(currentImg_detectii,1)>0
       [is_maximum] = eliminaNonMaximele(currentImg_detectii, currentImg_scoruriDetectii, size(origImg));
        currentImg_scoruriDetectii = currentImg_scoruriDetectii(is_maximum);
        currentImg_detectii = currentImg_detectii(is_maximum,:);
        currentImg_imageIdx = currentImg_imageIdx(is_maximum);
    
    
    end

    detectii = [detectii; currentImg_detectii];
    scoruriDetectii = [scoruriDetectii currentImg_scoruriDetectii];
    imageIdx = [imageIdx; currentImg_imageIdx];
    toc

end




