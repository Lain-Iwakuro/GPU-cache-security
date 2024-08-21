# GPU cache security

## Prerequisite

- CUDA environment, we use 12.5

## Reverse Engineering

In folder `./reverse-engineering`, run `run.sh`. The set mapping will be in `rev_set.txt`.`

## Proof-of-concept Attack

Make sure you generated eviction set first. In folder `./poc-attack`, run `run.sh`. Probe times will be in `out.txt`.

## Guard Kernel

In folder `./guard-kernel`, run `run.sh` to activate the guard kernel.

## Benchmark

Clone Hetero-Mark:

```bash
git clone https://github.com/NUCAR-DEV/Hetero-Mark.git
```

Compile CUDA version of **Hetero-Mark** as described in [GitHub - NUCAR-DEV/Hetero-Mark: A Benchmark Suite for Heterogeneous System Computation](https://github.com/NUCAR-DEV/Hetero-Mark).
Then run `run-bench.sh` to see the time consumed by different benchmarks in `bench.txt`.