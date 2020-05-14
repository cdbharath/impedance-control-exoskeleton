from scipy.io import wavfile
import time
import numpy as np

filename = 'subject_1_base.wav'
fs, data = wavfile.read(filename)
status = False
t = 0
sample = 0

for i in range(len(data)):
    sample = sample + 1
    t = sample/fs
    
    if t%1 == 0:
        print(t)

    if data[i] > 1000:
        print("arm lift")
    time.sleep(1/fs)
    

print("stream complete")    