import numpy as np

def mapGenerate(movie):
    spectrumMovie = np.fft.fft(movie, axis=0)
    # generate power movie
    powerMovie = (np.abs(spectrumMovie) * 2.) / np.size(movie, 0)
    powerMap = np.abs(powerMovie[1, :, :])
    # generate phase movie
    phaseMovie = np.angle(spectrumMovie)
    phaseMap = -1 * phaseMovie[1, :, :]
    phaseMap = phaseMap % (2 * np.pi)
    

