#!/bin/bash
#SBATCH --job-name="charliecloud_mpi_CERN_impi_768_opt_intel03_mpi"
#SBATCH --output="output_charliecloud_CERN_impi_768_opt_intel03_mpi.txt"
#SBATCH --error="error_charliecloud_CERN_impi_768_opt_intel03_mpi.txt"
#SBATCH --time=04:30:00
#SBATCH --account=pr28fa
#SBATCH --partition=general
#SBATCH --nodes=768
#SBATCH --ntasks=3072
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=12

#### 4 MPI tasks per node 12 (48/4) tasks per MPI rank

module load slurm_setup
module load mpi.intel/2019
module load devEnv/Intel/2019
module load charliecloud
module load amplifier_xe/2019

export KMP_SETTINGS=1
export KMP_AFFINITY=granularity=fine,compact,1,0
export KMP_BLOCKTIME=0
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export I_MPI_PIN_RESPECT_CPUSET=0
export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0

mpiexec -n $SLURM_NTASKS -ppn $SLURM_NTASKS_PER_NODE ch-run -b /lrz/sys/.:/lrz/sys/ -w /dss/dsshome1/08/di72giz/Docker/02d6e22ec5ec -- python /CERN/3Dgan-svalleco-sc18/keras/EcalEnergyTrain_hvd.py  --model=EcalEnergyGan  --datapath=/CERN/Data/*.h5 --channel_format='channels_first'  --batchsize 16  --learningRate 0.001 --optimizer=Adam  --latentsize 200  --intraop 12 --interop 2  --warmupepochs 0 --nbepochs 2

