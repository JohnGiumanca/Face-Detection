# Face-Detection
A face detection program that uses [HOG](https://en.wikipedia.org/wiki/Histogram_of_oriented_gradients) descriptors.

## Description
This scope of this project is to implement and test an algorithm for face detection using the sliding window method and histogram of oriented gradients.

The program trains a classifier model to detect images that contain faces. After that, we will test the accuracy, how many faces he can detect in an image.

## Running the project
The project unfortunately is written in roumanian but it is pretty easy to run and understand, I will walk you through it.

In the 'cod' folder you will find the matlab scripts. The one that you neet to configure and run is “ruleazaProiect.m".

### Configuration 
* on lines 18-21 are directory paths for dataset folder, positive examples subfolder, negative examples subfolder and test examples subfolder
```Matlab
numeDirectorSetDate = '../data/'; 
parametri.numeDirectorExemplePozitive = fullfile(numeDirectorSetDate, 'exemplePozitive');                                   
parametri.numeDirectorExempleNegative = fullfile(numeDirectorSetDate, 'exempleNegative');                                   
parametri.numeDirectorExempleTest = fullfile(numeDirectorSetDate,'exempleTest/CMU+MIT'); 
```

* on 23 and 24 set annotations for testing examples file path and 1 if the file exists
```Matlab
parametri.numeDirectorAdnotariTest = fullfile(numeDirectorSetDate,'exempleTest/CMU+MIT_adnotari/ground_truth_bboxes.txt');  
parametri.existaAdnotari = 0;
```

* on 25 and 26 we set a saving folder path so we do not need to train the model at every run
```Matlab
parametri.numeDirectorSalveazaFisiere = fullfile(numeDirectorSetDate,'salveazaFisiere/');
mkdir(parametri.numeDirectorSalveazaFisiere);
```

* from 28 to 37 we have the parameters, you can play with them to get a better accuracy. They are as following:
  * size of sliding window
  * size of HOG cell
  * size of the descriptor of a cell
  * overlap of 2 detection so the one with higher score can eliminate the one with smaller one
  * set 1 for training with strong negative examples(this is optional)
  * number of positive examples
  * number of negative examples
  * threshold for detection score
  * set 1 for visualisation of HOG template
```Matlab
parametri.dimensiuneFereastra = 36;              
parametri.dimensiuneCelulaHOG = 4;               
parametri.dimensiuneDescriptorCelula = 31;       
parametri.overlap = 0.3;                        
parametri.antrenareCuExemplePuternicNegative = 0;
parametri.numarExemplePozitive = 6713;           
parametri.numarExempleNegative = 10000;          
parametri.threshold = 0.3;                         
parametri.vizualizareTemplateHOG = 1;           
```

The next lines will do the following:
* Step 1 - loading dataset
* Step 2 - training
* Step 3 - training with negative exmples (optional)
* Step 4 - testing and visualisation

## Presentation

<p align="center">
<img src="https://i.imgur.com/bVhxFRC.png" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/HswOmzQ.png" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/liKno00.png" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/d3Vvt4C.png" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/VvEVNJn.png" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/jgX75VB.png" width="400" height="280" style="float: right;">
</p>
