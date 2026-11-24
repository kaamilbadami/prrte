# Frontier topology for review

[frontier.xml](../test/topologies/frontier.xml) describes one Frontier compute
node's hardware layout. Identifying details were replaced for sharing.
The [capture script](capture_frontier_topology.sbatch) reproduces how it was
collected. It is reconstructed from the recorded commands and job metadata.
The allowed CPU and NUMA masks were expanded to describe the whole node.

Test results on Frontier:

- All 625 offline process-placement cases passed during generation and again
  when checking the saved results (job 5984913).
- All 22 saved placement plans were reviewed.
- All 29 unit-test entries passed after two test-setup fixes (job 5985662).
  One internal check requiring root and another user's files was skipped.

The unit fixes limit a socket buffer to exercise partial writes and clear both
Slurm job-ID variables when testing simulated allocations. They are separate
from this topology contribution. Full logs and patches are available separately.
Successful GPU assignment is not covered by these results.

The capture used hwloc 2.11.2 in job 5984519. Validation used PRRTE
`4c114d1e9ecc971fb20dd0b69176c90892972afb` and OpenPMIx
`40172ea1c63e3e6f5b31efcd9725822f120ba55c`.
This review branch includes two newer upstream commits that have not been
retested on Frontier.

Prepared for team review before opening an upstream PR.
