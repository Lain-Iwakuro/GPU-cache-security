for i in {1..20}
do
    Hetero-Mark/build/src/fir/cuda/fir_cuda -q -t |& grep 'Run' >> bench.txt
done