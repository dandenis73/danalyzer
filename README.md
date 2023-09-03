# danalyzer

danalyzer is a MATLAB toolbox for the analysis of sleep electrophysiology data. The toolbox contains a GUI (graphical user interface) for visualising sleep EEG time series data with the primary function of sleep scoring an visual artifact rejection. Also included are a series of functions for performing standard analyses of sleep EEG data (power spectral density, sleep spindle and slow oscillation detection, and slow-oscillation spindle coupling analysis). 

danalyzer comes with absolutely no guarentee or warrenty of any kind. The functions are made public in the hope that they will be of use to others.

If you use danalyzer in your work, please consider citing the following paper:

Denis, D., Mylonas, D., Poskanzer, C., Bursal, V., Payne, J.D., and Stickgold, R. (2021). Sleep spindles preferentially consolidate weakly encoded memories. The Journal of Neuroscience, 41 (18), 4088-4099. DOI: 10.1523/JNEUROSCI.0818-20.2021

A protocol paper detailing an analysis pipeline from start to finish using danalyzer is in preparation.
 
## Installation 
 
To install the toolbox, simply add the danalyzer and subfolders to the MATLAB path:

`addpath(genpath('/Path to danalyzer folder'))`

The GUI relies on EEGLAB functions for importing data. Slow oscillation-spindle coupling analysis relies on the circStats toolbox for working with coupling phase (i.e., circular) values. They can be found here:

EEGLAB: [https://sccn.ucsd.edu/eeglab/download.php]()	
circStats: [https://uk.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics]()

Make sure both are added to the MATLAB path before you start.

To open the GUI, simply type `sleepDanalyzer` in the Command Window. 

## Example scripts and data

Example data, and a series of template scripts can be downloaded from here:

[https://osf.io/hqbgt/]()

## "One-shot" installation

If you are a new user, and want to downloaded danalyzer, the dependency toolboxes, and the example data and code all at once, you can simply download the script 'danalyzer_full_install.m' from here:

[https://osf.io/hqbgt/]()

Open the script in MATLAB, and change the file directory in Line 9 to the destination where you want everything to be installed. Click Run to perform the install. The script will attempt to download everything from the OSF repository, and extract the contents into the directory you indicated in Line 9 of the script. It will also take care of setting up the MATLAB path correctly.

This is a nice approach to users who are not familiar with MATLAB. Although this script will install the most recent version of danalyzer, an archived version of the other toolboxes will be installed. This means these toolboxes are not neccessarily up to date.

Note you **must** have administrator privilages to be able to run this script. Has only been tested with MacOS.
