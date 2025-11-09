#!/bin/bash
#SBATCH -J slim_phase1_burnin
#SBATCH --ntasks-per-node=1
#SBATCH -N 1
#SBATCH -t 12:00:00
#SBATCH --mem=24G
#SBATCH -p standard
#SBATCH --account=berglandlab
#SBATCH --output=/scratch/cqh6wn/AOD_slim/logs/phase1.%A_%a.out
#SBATCH --error=/scratch/cqh6wn/AOD_slim/logs/phase1.%A_%a.err

module purge
module load slim

slim phase1_burnin.slim


