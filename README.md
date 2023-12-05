# Monophonic AMT
The goal in this project is to implement automatic music transcription with a machine learning based method and a digital signal processing (DSP) based method. We compare the results and the pros and cons for each method. Our designs assume that the audio is monophonic and is in a 4/4 time signature. The ML model has been trained on piano samples and the DSP algorithm is optimized for instrument with steep attack in the ADSR envelope, e.g., piano.
## ML Method
## DSP Method
The core of the DSP method is the autocorrelation function (ACF) which allows the determination of fundamental frequencies. The ACF is robust to noise and gives much better results than the FFT alone. We use the short-time Fourier transform to segment the audio and compute the ACF from the power spectral density of the spectrum in each block. Onsets are detected by amplitude peaks of the fundamental frequencies.
