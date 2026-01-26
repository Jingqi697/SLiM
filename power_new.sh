#!/bin/bash
#SBATCH -J slim_power
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH -t 24:00:00
#SBATCH --mem=8G
#SBATCH -p standard
#SBATCH --account=berglandlab
#SBATCH --array=1-100
#SBATCH --output=/scratch/cqh6wn/AOD_slim/Distribution/Inversions/1/TO/Power/logs/power.%A_%a.out
#SBATCH --error=/scratch/cqh6wn/AOD_slim/Distribution/Inversions/1/TO/Power/logs/power.%A_%a.err

module purge
module load slim

TASK_ID=${SLURM_ARRAY_TASK_ID}
RUNS_PER_TASK=50

START_REP=$(( (TASK_ID - 1) * RUNS_PER_TASK + 1 ))
END_REP=$(( TASK_ID * RUNS_PER_TASK ))

OUTFILE="power_chunk_${TASK_ID}.csv"
rm -f $OUTFILE

MODELS=("AOD" "AOD_TO")
K_LIST=(300 500 1000)
G_LIST=(10 15 20)
S_LIST=(50 100 200)
FOUNDERS_LIST=(10 20 40)

echo "TASK $TASK_ID running replicates $START_REP to $END_REP"

for MODEL in "${MODELS[@]}"; do
  for K in "${K_LIST[@]}"; do
    for G in "${G_LIST[@]}"; do
      for S in "${S_LIST[@]}"; do
        for F in "${FOUNDERS_LIST[@]}"; do

          for REP in $(seq $START_REP $END_REP); do

            slim \
              -d MODEL_TYPE=\"$MODEL\" \
              -d K_CAGE=$K \
              -d NUM_GEN=$G \
              -d N_SAMPLE=$S \
              -d N_FOUNDERS_HIGH=$F \
              -d REP_ID=$REP \
              -d OUTFILE=\"$OUTFILE\" \
              phase3_power.slim

          done
        done
      done
    done
  done
done

echo "TASK $TASK_ID finished"
