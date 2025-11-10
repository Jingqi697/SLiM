#!/bin/bash
#SBATCH -J slim_phase2_inversion
#SBATCH --ntasks-per-node=1
#SBATCH -N 1
#SBATCH -t 12:00:00
#SBATCH --mem=24G
#SBATCH -p standard
#SBATCH --account=berglandlab
#SBATCH --output=/scratch/cqh6wn/AOD_slim/logs/phase2.%A_%a.out
#SBATCH --error=/scratch/cqh6wn/AOD_slim/logs/phase2.%A_%a.err
#SBATCH --array=1-1000

module purge
module load slim

slim -d jobID=$SLURM_ARRAY_TASK_ID phase2_inversion.slim
