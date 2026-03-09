# HPC-Cloud OpenFOAM simulations deployment via StreamFlow

This repository provides a [Common Workflow Language](https://www.commonwl.org/) (CWL) implementation of several standard OpenFOAM computational fluid dynamics (CFD) pipelines. These workflows are ported from the [OpenFOAM HPC Committee's reference benchmarks](https://develop.openfoam.com/committees/hpc/-/tree/master), originally designed to evaluate the performance and scalability of OpenFOAM in high-performance computing environments.

## Requirements

- Singularity or [Docker images OpenFOAM](https://hub.docker.com/u/opencfd)
- [StreamFlow](https://streamflow.di.unito.it/)
- node js
- [wf-viewer](https://github.com/LanderOtto/wf-viewer)

To Install StreamFlow:
```
pip install streamflow==0.2.0.dev14
pip install nodeenv
nodeenv -p
```
To Install wf-viewer
```
git clone https://github.com/alpha-unito/wf-viewer.git
cd wf-viewer
pip install .
```

## Instructions
- To run the simulation on a new cluster architecture, create a new **facility** file in the *facilities folder*. In this file, update the **SIF** environment variable to specify the path to your local OpenFOAM Singularity image.
- To execute a simulation, create a new StreamFlow configuration file or update an existing one by following these [steps](https://streamflow.di.unito.it/documentation/0.2/guide/bind.html). In particular, you need to define which pipeline to execute (cavity3D or Motorbike), configure the facility deployments (including the newly created facility file), and bind the workflow steps to the corresponding deployment.
- If you define parallel deployments with a specific number of cores or GPUs, update the *decomposeParDict* file in the OpenFOAM simulation directory accordingly. (This step will be automated by the workflow manager in future versions.)


## Folder organization

- *cases*       -> simulations that can be executed
- *steps*       -> CWL file OpenFOAM application (steps)
- *facilities*  -> Facilities where to run applications 
- *jobs*        -> CWL file case configurations
- *workflows*   -> CWL file workflows
- *streamflows* -> StreamFlow files configurations
- *experiment-scripts* -> Example of launching scripts

## Example of execution

```
mkdir -p /path/to/tmp
export TMPDIR=/path/to/tmp
streamflow run streamflows/cascadelake/cavity.yml
```
Note: on some architectures `ulimit -n 6535`
## Case descriptions 
The original simulation cases were taken from official [benchmark repository](https://develop.openfoam.com/committees/hpc/-/tree/develop).

### [Cavity3D](https://develop.openfoam.com/committees/hpc/-/tree/develop/incompressible/icoFoam/cavity3D)
The lid-driven cavity flow, where the motion is induced by the upper boundary (lid) of the cavity, is one of the most basic and widely used benchmark test cases in CFD.
An example of workflow executing this simulation can be found in the [streamflow file](streamflows/hybrid/cavity). 
This workflow executes all cavity simulation sizes (1M, 8M, 64M) using both fixedIter and fixedTol configurations. Each simulation size is executed on a different architecture.

### [Motorbike](https://develop.openfoam.com/committees/hpc/-/tree/develop/incompressible/simpleFoam/HPC_motorbike)

The HPC_motorbike case simulates the turbulent airflow around a motorcycle in a wind tunnel using the steady-state incompressible solver simpleFoam, and is commonly used as a benchmark for evaluating OpenFOAM performance and scalability on HPC systems. An example of workflow executing this simulation can be found in the [streamflow file](streamflows/hybrid/motorbike_AllSizes_1node.yaml). This workflow executes all Motorbike simulation sizes (S, M, L). Each simulation size is executed on a different architecture.



