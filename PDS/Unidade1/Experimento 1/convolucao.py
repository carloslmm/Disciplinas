import soundfile as sf
import numpy as np
import matplotlib.pyplot as plt


#Lendo o sinal e a o frequência de amostragem
signal, samplerate = sf.read('Church Schellingwoude.wav')
#Vetor tempo de duração do sinal do tiro
time = np.arange(0, len(signal) * 1/samplerate, 1/samplerate)
#Vetor do sinal da igreja
church_signal = []

#Retirando o sinal do primeiro canal do sinal da igreja
for i in signal:
	church_signal.append(i[0])

#Lendo o sinal e a frequência de amostragem
minha_voz, freq_amostr = sf.read('minha_voz.wav')
#Vetor tempo de duração do sinal da voz
tempo = np.arange(0,len(minha_voz)*1/freq_amostr,1/freq_amostr)

#Vetor do primeiro canal
conv = np.convolve(minha_voz, church_signal)
#Vetor tempo da convolução
t_conv = np.arange(0, len(conv)*1/44100 , 1/44100)

#Multiplicando pela variância do sinal para diminuir a magnitude do sinal
conv = conv*np.var(minha_voz)
#Escrevendo o arquivo da convolução em .wav
sf.write('conv_signal.wav',conv, 44100)
