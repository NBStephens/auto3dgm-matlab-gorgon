# auto3dgm-matlab-gorgon
MST-based Generalized Dataset Procrustes Distance by Jesús Puente

### Information

MATLAB code forked from JuliaWinchester/auto3dgm-matlab-gorgon (https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon.git). 

### Changes


Code adjusted to run on Penn State University HPC (aci-ics) torque system. Currently this cannot be run using the clusteRun.m script due to differences in the flag for waiting for previous scripts to finish. 

Write out the transormation matrix and origin into the './aligned' folder. 
	
Set default submission time to 24:00 hrs from 3:00 hrs, to accomodate complex reorientations.
	
Set the submission to use a paid account. 

If you are not submitting from within the RyanLab you will need to change the "-A tmr21_b_g_sc_default" to another account (-A youraccount) or the campuswide open system (-A open).

!!! If you rerun the analysis it will delete your results folder, if you don't want that to happen please change to another folder !!!

### Citing

If you are using this version of the software please cite the zenodo doi along with the original paper and PhD thesis:


[![DOI](https://zenodo.org/badge/222549344.svg)](https://zenodo.org/badge/latestdoi/222549344)


```
@Article{Boyer2015,
  author         = {Boyer, D. M. and Puente, J. and Gladman, J. T. and Glynn, C. and Mukherjee, S. and Yapuncich, G. S. and Daubechies, I.},
  title          = {A new fully automated approach for aligning and comparing shapes},
  journal        = {Anat Rec (Hoboken)},
  year           = {2015},
  volume         = {298},
  number         = {1},
  pages          = {249-76},
  month          = {Jan},
  issn           = {1932-8494 (Electronic)
  shorttitle     = {A new fully automated approach for aligning and comparing shapes},
  url            = {https://www.ncbi.nlm.nih.gov/pubmed/25529243},
}
```
```
@PhdThesis{Puente2013,
  author   = {Puente, Jesus},
  school   = {Princeton, NJ : Princeton University},
  title    = {Distances and algorithms to compare sets of shapes for automated biological morphometrics},
  year     = {2013},
  month    = sep,
  type     = {phdthesis},
  keywords = {Morphometrics, Procrustes, Applied mathematics, Morphology, Computer science},
  url      = {http://arks.princeton.edu/ark:/88435/dsp01sq87bt73n},
}
```

### Usage

As such, you must run with manually in the sequence (described in greater detail below): 

1 ) Edit the jadd_path.m file

2 ) Downsample meshes and begin alignment

```
cd /to/directory/where/matlab/code/is/at
clusterMapLowRes 
```

3) Gather the results from the low resolution alignment
```
clusterReduceLowRes 
```

4) Do the high resolution alignment
```
clusterMapHighRes
```

5) Gather the results from the high resolution alignment
```
clusterReduceHighRes
```

### Troubleshooting

Make certain you have replaced the mosek license file with a current license (free for academics) in the "./auto3dgm-matlab-gorgon/software/mosek" folder.

This has only been tested by myself using MATLAB 2017b, and it is likely that future versions will break the code. 

On Windows installations, Matlab may crash after subsampling due to missing dynamic link libraries (mosek64_7_1.dll). The quickest fix is to copy this file and the corresponding library (mosek64_7_1.lib) from ".\mosek\7\tools\platform\win64x86\bin" to the appropraite folder (".\mosek\7\toolbox\r2013a"). 

### Original text

MATLAB Code originally written by Jesús Puente (jparrubarrena@gmail.com); forks of this code include [PuenteAlignment](https://github.com/trgao10/PuenteAlignment), maintained by Tingran Gao (trgao10@math.duke.edu), and [auto3dgm-matlab-gorgon](https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon), maintained by Julie Winchester (julia.m.winchester@gmail.com). This code has also been ported to R by Christopher Glynn (glynn@stat.duke.edu) under the name [*auto3dgm*](https://stat.duke.edu/~sayan/auto3dgm/).

auto3dgm-matlab-gorgon is a fork of auto3dgm with a focus on providing improved user experience and additional functionality both upstream and downstream from the core workflow. The latest commits can be found in the [dev](https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon/tree/dev) branch, but users are encouraged to clone the [master](https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon) branch as it contains stable milestone releases. PuenteAlignment and auto3dgm-matlab-gorgon both have the same core MST-based alignment functionality. Auto3dgm-matlab-gorgon does not currently include the two spectral relaxation alignment algorithms included in the current PuenteAlignment version. Auto3dgm-matlab-gorgon does implement two new features currently: user control over how overall mesh alignment is handled after all sample meshes are aligned to each other, and principal components analysis of partial procrustes tangent shape coordinates. These new features are described below. This branch also has a number of smaller user experience improvements, such as support for OSX local analyses or more flexible directory formatting in jadd_path.m.

#### Overall mesh alignment

Users can control the overall alignment of surface meshes (after meshes are aligned to each other) by setting the 'align_to' field in jadd_path.m. If this value is set to the name of a surface mesh file in the current analysis, then all meshes will be aligned to that mesh's orientation in 3D coordinate space. If 'align_to' is set to 'auto' or blank (''), auto3dgm will attempt to derive a semi-standardized overall alignment for all meshes. Principal axes of shape variation are derived for all sample vertex point clouds concatenated, and each mesh is rotated so that first, second, and third principal axes of shape variation correspond to Y, X, and Z coordinate axes respectively.

#### PCA of partial procrustes tangent shape coordinates

If the 'do_tangent_pca' field in jadd_path.m is set to 1, then auto3dgm carries out a principal components analysis of partial procrustes tangent shape coordinates.  The method used for the tangent space projection is that of Dryden and Mardia's (1993, 1998, 2016) paper and textbook for unit-scaled shape data, but using the calculations from Rohlf's (1999) description of 'Kendall tangent space coordinates'. Several files are saved with PCA results, including a basic scatter plot of PC1 and PC2, PC scores per individual, eigenvalues and percent variance explained per PC, and eigenvectors per PC.

-----------
## Using auto3dgm-matlab-gorgon

The current version of auto3dgm-matlab-gorgon supports standard sequential execution on any matlab installation or parallel computation on a cluster managed by Sun Grid Engine (SGE). Follow the instructions below for installation and usage of this software.

1. Get the current version of auto3dgm-matlab-gorgon. Either download the repository files directly to the desired path, or if `git` is installed simply `cd` into your desired path, then type

        git clone https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon.git
        
2. Find the script `jadd_path.m` in the folder *auto3dgm-matlab-gorgon/code/*, and set paths and parameters there. If you are using parallel computation and assign an email address to the variable `email_notification`, a notification will be sent automatically to that email address whenever a cluster job completes or aborts.

3. Launch `MATLAB` and `cd` into the folder *auto3dgm-matlab-gorgon/code/*. If sequential non-cluster analysis is desired, type `main` to run the script `main.m`. If parallel cluster analysis is desired, type `clusterMain` to run the script `clusterMain.m`. Jobs should be submitted to the cluster subsequently. Use `qstat` to monitor job status. Analysis is complete when job `clusterRun` is finished. 

The script `clusterRun.m` automates the four major steps of auto3dgm parallel computation. It is also possible to run these four steps manually following these instructions.

1. Launch `MATLAB`, `cd` into the folder *auto3dgm-matlab-gorgon/code/*, and type `clusterMapLowRes`. Low-resolution alignment jobs should then be submitted to the cluster. Use `qstat` to monitor job status.

2. After all jobs are completed, type `clusterReduceLowRes`. This generates low-resolution alignment results in the `output` folder specified in `jadd_path.m`.

3. Type `clusterMapHighRes` to submit high-resolution alignment jobs to the cluster. 

4. After all jobs are completed, type in `clusterReduceHighRes`. This generates high-resolution alignment results in the `output` folder specified in `jadd_path.m`.

-----------
#### WebGL-based Alignment Visualization
After the alignment process is completed, the result can be visualized using a javascript-based viewer located under the folder *viewer/*. See [here](http://www.math.duke.edu/~trgao10/research/auto3dgm.html) for an online demo.

1. Move all output files ending with "_aligned.obj" from the subfolder *aligned/* (under your output folder) to the subfolder *viewer/aligned_meshes/*.
2. Set up an HTTP server under the folder *viewer/*. (If you already placed the folder *viewer/* somewhere with HTTP services, feel free to skip this step.) For instance, you can `cd viewer/` and type into the terminal

        python -m SimpleHTTPServer 8000

3. Launch your browser and direct it to `http://localhost:8000/auto3dgm.html`.

-----------
#### Please Cite:

Boyer, Doug M., et al. *A New Fully Automated Approach for Aligning and Comparing Shapes.* The Anatomical Record 298.1 (2015): 249-276.

Puente, Jesús. *Distances and Algorithms to Compare Sets of Shapes for Automated Biological Morphometrics.* PhD Thesis, Princeton University, 2013.
