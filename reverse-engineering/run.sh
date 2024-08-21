nvcc -O0 -o get_set get_set.cu
./get_set > out.txt
python3 check.py
python3 generate_set.py