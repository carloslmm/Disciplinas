import numpy as np
import matplotlib.pyplot as plt
from numpy.fft import fft, ifft
from scipy import special as sp
import commpy
import cmath

def qfunc(x):
    return 0.5-0.5*sp.erf(x/np.sqrt(2))

EbN0dB = np.arange(0,14) ### Vetor EbN0dB

n_bits = 1000
M = 16
bits_transmitidos = np.random.randint(0,2,size=n_bits)

BER_QAM = []
BER_QAM_TEO = []
BER_BPSK = []
BER_BPSK_TEO = []
qam = commpy.QAMModem(M)
bpsk = commpy.PSKModem(2)
sinalqam = qam.modulate(bits_transmitidos)
sinalbpsk = bpsk.modulate(bits_transmitidos)
sinalqam = sinalqam[:,None]
sinalbpsk = sinalbpsk[:,None]
sinalofdmqam = ifft(sinalqam)
sinalofdmbpsk = ifft(sinalbpsk)

for i in EbN0dB:
    BER_QAM_MC = []
    BER_BPSK_MC = []
    Eb = np.mean(np.abs(sinalofdmqam)**2)
    N0qam = Eb*10**(-i/10)
    Eb = 1
    N0bpsk = Eb*10**(-i/10)
    for k in range(0,10):
        noiseqam = np.sqrt(N0qam/2)*np.random.randn(np.shape(sinalofdmqam)[0],1)+1j*np.sqrt(N0qam/2)*np.random.randn(np.shape(sinalofdmqam)[0],1)
        noisebpsk = np.sqrt(N0bpsk/2)*np.random.randn(np.shape(sinalofdmbpsk)[0],1)+1j*np.sqrt(N0bpsk/2)*np.random.randn(np.shape(sinalofdmbpsk)[0],1)
        signoiseqam = sinalofdmqam + noiseqam
        signoisebpsk = sinalofdmbpsk + noisebpsk
        
        sinalrxqam = fft(signoiseqam)
        sinalrxbpsk = fft(signoisebpsk)
        indexlistqam = np.abs(sinalrxqam[:,:] - qam.constellation).argmin(axis=1)
        indexlistbpsk = np.abs(sinalrxbpsk[:,:] - bpsk.constellation).argmin(axis=1)
        demodsignalqam = []
        demodsignalbpsk = []
        for symbolq in indexlistqam:
            demodsignalqam.extend(commpy.utilities.decimal2bitarray(symbolq,qam.num_bits_symbol))
        for symbolb in indexlistbpsk:
            demodsignalbpsk.extend(commpy.utilities.decimal2bitarray(symbolb,bpsk.num_bits_symbol))
        nErrorsqam = sum(bits_transmitidos ^ demodsignalqam)
        nErrorsbpsk = sum(bits_transmitidos ^demodsignalbpsk)
        BER_QAM_MC = np.append(BER_QAM_MC, nErrorsqam/(n_bits))
        BER_BPSK_MC = np.append(BER_BPSK_MC, nErrorsbpsk/(n_bits))
    BER_QAM = np.append(BER_QAM, np.mean(BER_QAM_MC))
    BER_BPSK = np.append(BER_BPSK, np.mean(BER_BPSK_MC))


## Calculando o valor da BER teórico

for i in EbN0dB:
    EbN0 = 10**(i/10) # Transformando para linear 
    BER_QAM_TEO = np.append(BER_QAM_TEO, (4/np.log2(M))*(1-1/np.sqrt(M))*np.asanyarray(qfunc(np.sqrt(3*(4/np.log2(M))*EbN0/(M-1)))))
    BER_BPSK_TEO = np.append(BER_BPSK_TEO, qfunc(np.sqrt(2*10**(i/10))))


plt.figure()
plt.semilogy(EbN0dB, BER_QAM, "bs-.", label="BER Simulada - "+ str(M)+"-QAM")
plt.semilogy(EbN0dB, BER_QAM_TEO, "rs-.", label="BER Teórica - "+str(M)+"-QAM")
plt.semilogy(EbN0dB, BER_BPSK, "ko--", label="BER Simulada - BPSK")
plt.semilogy(EbN0dB, BER_BPSK_TEO, "go--", label="BER Teórica - BPSK")
plt.title("BER de modulações digitais vs Eb/N0")
plt.ylabel("Taxa de erro de bit")
plt.xlabel("Eb/N0")
plt.xticks(EbN0dB)
plt.tight_layout()
plt.legend()
plt.grid()
plt.show()