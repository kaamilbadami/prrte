#!/usr/bin/env bash
# Reproduces the capture method used in job 5984519; reconstructed from
# the recorded command sequence and job metadata, not its original stdin.
#SBATCH --job-name=frontier-topology
#SBATCH --account=gen243
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --threads-per-core=2
#SBATCH --core-spec=0
#SBATCH --gpus-per-node=8
#SBATCH --exclusive
#SBATCH --time=00:05:00
#SBATCH --output=frontier-topology-%j.log
set -euo pipefail
umask 077
out="$PWD/frontier-topology-$SLURM_JOB_ID"
mkdir "$out"
module -t list > "$out/modules.txt" 2>&1 || true
scontrol show job "$SLURM_JOB_ID" > "$out/slurm-job.txt"
tool=$(command -v lstopo-no-graphics || command -v lstopo || command -v hwloc-ls)
"$tool" --version > "$out/hwloc-version.txt"
"$tool" --help > "$out/lstopo-help.txt" 2>&1
flag=--whole-system
if grep -Fq -- '--disallowed' "$out/lstopo-help.txt"; then flag=--disallowed; fi
unset HWLOC_XMLFILE HWLOC_SYNTHETIC HWLOC_FSROOT HWLOC_COMPONENTS
unset HWLOC_THISSYSTEM HWLOC_THISSYSTEM_ALLOWED_RESOURCES
"$tool" "$flag" --whole-io --of xml "$out/frontier-full.xml"
"$tool" --whole-io --of xml "$out/frontier-visible.xml"
tar -czf "$out.tar.gz" -C "$(dirname "$out")" "$(basename "$out")"
echo "Capture saved: $out.tar.gz"
