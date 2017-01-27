# auto3dgm-matlab-gorgon
MST-based Generalized Dataset Procrustes Distance by Jesús Puente

MATLAB Code originally written by Jesús Puente (jparrubarrena@gmail.com); forks of this code include [PuenteAlignment](https://github.com/trgao10/PuenteAlignment), maintained by Tingran Gao (trgao10@math.duke.edu), and [auto3dgm-matlab-gorgon](https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon), maintained by Julie Winchester (julia.m.winchester@gmail.com). This code has also been ported to R by Christopher Glynn (glynn@stat.duke.edu) under the name [*auto3dgm*](https://stat.duke.edu/~sayan/auto3dgm/).

auto3dgm-matlab-gorgon is a fork of auto3dgm with a focus on providing improved user experience and additional functionality both upstream and downstream frmo the core workflow. The latest commits can be found in the [dev](https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon/tree/dev) branch, but users are encouraged to clone the [master](https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon) branch as it contains stable milestone releases. PuenteAlignment and auto3dgm-matlab-gorgon both have the same core MST-based alignment functionality. Auto3dgm-matlab-gorgon does not currently include the two spectral relaxation alignment algorithms included in the current PuenteAlignment version. Auto3dgm-matlab-gorgon does implement two new features currently: user control over how overall mesh alignment is handled after all sample meshes are aligned to each other, and principal components analysis of partial procrustes tangent shape coordinates. These new features are described below. This branch also has a number of smaller user experience improvements, such as support for OSX local analyses or more flexible directory formatting in jadd_path.m.

#### Overall mesh alignment

Users can control the overall alignment of surface meshes (after meshes are aligned to each other) by setting the 'align_to' field in jadd_path.m. If this value is set to the name of a surface mesh file in the current analysis, then all meshes will be aligned to that mesh's orientation in 3D coordinate space. If 'align_to' is set to 'auto' or blank (''), auto3dgm will attempt to derive a semi-standardized overall alignment for all meshes. Principal axes of shape variation are derived for all sample vertex point clouds concatenated, and each mesh is rotated so that first, second, and third principal axes of shape variation correspond to Y, X, and Z coordinate axes respectively.

#### PCA of partial procrustes tangent shape coordinates

If the 'do_tangent_pca' field in jadd_path.m is set to 1, then auto3dgm carries out a principal components analysis of partial procrustes tangent shape coordinates.  The method used for the tangent space projection is that of Dryden and Mardia's (1993, 1998, 2016) paper and textbook for unit-scaled shape data, but using the calculations from Rohlf's (1999) description of 'Kendall tangent space coordinates'. Several files are saved with PCA results, including a basic scatter plot of PC1 and PC2, PC scores per individual, eigenvalues and percent variance explained per PC, and eigenvectors per PC.

-----------

## Using auto3dgm-matlab-gorgon


#### Sequential Execution
The entry point is the script `code/main.m`; see comments at the top of that script for a quick introduction. 

#### Parallel Execution
The current version of auto3dgm-matlab-gorgon supports parallel computations on a cluster managed by Sun Grid Engine (SGE). To enable parallel execution, follow the steps 1 to 6 below.

1. Get the current version of PuenteAlignment. Simply `cd` into your desired path, then type

        git clone https://github.com/JuliaWinchester/auto3dgm-matlab-gorgon.git
        
2. Find script `jadd_path.m` in the folder *auto3dgm-matlab-gorgon/code/*, and set paths and parameters there. If you assign an email address to the variable `email_notification`, a notification will be sent automatically to that email address whenever a cluster job completes or aborts.
3. Launch `MATLAB`, `cd` into the folder *auto3dgm-matlab-gorgon/code/*, type in `clusterMapLowRes` and press `ENTER`. All jobs should then be submitted to the cluster. Use `qstat` to monitor job status.
4. After all jobs are completed, type in `clusterReduceLowRes` and press `ENTER`. This generates low-resolution alignment results in the `output` folder you specified in `jadd_path.m`.
5. Type in `clusterMapHighRes` and press `ENTER` to submit high-resolution alignment jobs to the cluster. Use `qstat` to monitor job status.
6. After all jobs are completed, type in `clusterReduceHighRes` and press `ENTER`. This generates high-resolution alignment results in the `output` folder you specified in ```jadd_path.m```.

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
