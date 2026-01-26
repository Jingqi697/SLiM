#!/bin/bash
#SBATCH -J slim_power_AOD
#SBATCH --ntasks-per-node=1
#SBATCH -N 1
#SBATCH -t 24:00:00
#SBATCH --mem=24G
#SBATCH -p standard
#SBATCH --account=berglandlab
#SBATCH --output=/scratch/cqh6wn/AOD_slim/Distribution/Inversions/1/TO/Power/logs/power.%A.out
#SBATCH --error=/scratch/cqh6wn/AOD_slim/Distribution/Inversions/1/TO/Power/logs/power.%A.err

module purge
module load slim

cd /scratch/cqh6wn/AOD_slim || exit 1

echo "Starting power scan at $(date)"

# Remove old output
rm -f power_raw_counts.csv

## Parameters

MODELS=("AOD" "AOD_TO")

K_LIST=(300 500 1000)          # cage sizes
G_LIST=(10 15 20)             # generations
S_LIST=(50 100 200)            # genotyped flies
FOUNDERS_LIST=(10 20 40)       # MF founders

NREP_TOTAL=100                 # total replicates



for MODEL in "${MODELS[@]}"; do
  for K in "${K_LIST[@]}"; do
    for G in "${G_LIST[@]}"; do
      for S in "${S_LIST[@]}"; do
        for F in "${FOUNDERS_LIST[@]}"; do
          for REP in $(seq 1 $NREP_TOTAL); do

            echo "RUN: $MODEL K=$K G=$G S=$S Founders=$F REP=$REP"

            slim \
              -d MODEL_TYPE=\"$MODEL\" \
              -d K_CAGE=$K \
              -d NUM_GEN=$G \
              -d N_SAMPLE=$S \
              -d N_FOUNDERS_HIGH=$F \
              -d REP_ID=$REP \
              phase3_power_export.slim

          done
        done
      done
    done
  done
done

echo "Finished power scan at $(date)"
