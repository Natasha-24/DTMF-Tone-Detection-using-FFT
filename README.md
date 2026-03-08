# DTMF-Tone-Detection-using-FFT
# DTMF Tone Detection using FFT (MATLAB)

This project implements a Dual Tone Multi Frequency (DTMF) signal detection system using Fast Fourier Transform (FFT) in MATLAB.

## Overview
DTMF signaling is used in telephone keypads where each digit is represented by a combination of two frequencies. This project generates DTMF tones and detects the pressed digit by analyzing its frequency components using FFT.

## Key Concepts
- Signal generation using sinusoidal waves
- Sampling of continuous signals
- Frequency domain analysis using FFT
- Peak detection of dominant frequencies
- Mapping frequencies to keypad digits

## Methodology
1. Generate DTMF signal corresponding to input digit.
2. Add small Gaussian noise to simulate real conditions.
3. Apply Hamming window to reduce spectral leakage.
4. Compute FFT to obtain frequency spectrum.
5. Detect row and column frequencies.
6. Map detected frequencies to the corresponding keypad digit.

## Tools Used
- MATLAB
- FFT (Fast Fourier Transform)
- Signal Processing concepts

## Output
The system successfully detects digits (0–9) by identifying two dominant frequency peaks in the spectrum.

## Learning Outcomes
This project demonstrates practical applications of:
- Fourier Transform
- Frequency domain analysis
- Digital signal processing
- Telecommunications signaling systems
