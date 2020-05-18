import wave
import numpy as np
import matplotlib.pyplot as plt

signal_wave = wave.open('test.wav', 'r')
sample_rate = signal_wave.getframerate()
frames = signal_wave.getnframes()

sig = np.frombuffer(signal_wave.readframes(frames), dtype=np.int16)

for i in range(frames-sample_rate*5):
    
    sig = sig[0+i:sample_rate*5+i]

    #sig = sig[25000:32000]

    #left, right = data[0::2], data[1::2]
    plt.close()
    plt.figure(1)

    plot_a = plt.subplot(211)
    plot_a.plot(sig)
    plot_a.set_xlabel('sample rate * time')
    plot_a.set_ylabel('energy')

    plot_b = plt.subplot(212)
    plot_b.specgram(sig, NFFT=1024, Fs=sample_rate, noverlap=900)
    plot_b.set_xlabel('Time')
    plot_b.set_ylabel('Frequency')
    
    plt.show()