# Monophonic AMT
The goal in this project is to implement automatic music transcription with a machine learning based method and a digital signal processing (DSP) based method. We compare the results and the pros and cons for each method. Our designs assume that the audio is monophonic and is in a 4/4 time signature. The ML model has been trained on piano samples and the DSP algorithm is optimized for instrument with steep attack in the ADSR envelope, e.g., piano.
## ML Method
The ML Method initially focuses on implementing the AMT by using a deep learning model for note identification. Initially, the model used was a CNN model trained on a database of piano notes that was artificially augumented from the base 88 grand piano notes to 5610 notes using methods such as random cropping, addition of noise, note compression and others. Each of the piano notes was then turned into a mel spectrogram, and the CNN model would take these labeled Mel Spectrograms for training.
## DSP Method
The core of the DSP method is the autocorrelation function (ACF) which allows the determination of fundamental frequencies. The ACF is robust to noise and gives much better results than the FFT alone. We use the short-time Fourier transform to segment the audio and compute the ACF from the power spectral density of the spectrum in each block. Onsets are detected by amplitude peaks of the fundamental frequencies.


#### LilyPond Installation
1. Download LilyPond for your operating system from [LilyPond's official website](http://lilypond.org/download.html).
2. Follow the installation instructions provided on the website.
3. After installation, verify by running `lilypond --version` in your command line or terminal to ensure it's correctly installed.
