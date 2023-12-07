import os
import librosa
from spectrogramGenerator import generate_mel_spectrogram
from tqdm import tqdm

def generate_spectrograms_for_directory(input_directory, output_directory):
    # Check if the input directory exists
    if not os.path.isdir(input_directory):
        print(f"The directory {input_directory} does not exist.")
        return

    # Ensure the output directory exists
    os.makedirs(output_directory, exist_ok=True)

    # Get all .wav files in the directory
    wav_files = [file for file in os.listdir(input_directory) if file.endswith('.wav')]

    # Iterate over files in the input directory with a progress bar
    for file in tqdm(wav_files, desc="Generating Spectrograms"):
        input_file = os.path.join(input_directory, file)
        output_file = os.path.join(output_directory, os.path.splitext(file)[0] + '.png')

        # Call generate_mel_spectrogram to generate the spectrogram
        generate_mel_spectrogram(input_file, output_directory)

def label_simplified_spectrograms(directory):
    """
    Label the generated spectrograms based on their unique piano triad, ignoring volume and example number.
    
    Args:
    directory (str): Path to the directory containing the spectrogram images.

    Returns:
    dict: A dictionary with filenames as keys and simplified labels as values.
    """
    labels = {}
    # Get all .png files in the directory
    png_files = [file for file in os.listdir(directory) if file.endswith('.png')]

    # Iterate over files with a progress bar
    for filename in tqdm(png_files, desc="Labeling Spectrograms"):
        if filename.endswith('.png'):
            # Simplified label extraction logic here
            # Example: 'piano_3_Af_d_m_45.png' -> 'piano_3_Af_d'
            parts = filename.split('_')
            label = '_'.join(parts[:4])
            labels[filename] = label
    return labels

def get_triad_notes(label):
    """
    Given a label, return the three notes that compose the triad.

    Args:
    label (str): A label describing the triad.

    Returns:
    list: A list of three notes that compose the triad.
    """

    # Mapping of notes to their semitone distances from C
    note_semitones = {
        'Cn': 0, 'Df': 1, 'Dn': 2, 'Ef': 3, 'En': 4,
        'Fn': 5, 'Gf': 6, 'Gn': 7, 'Af': 8, 'An': 9,
        'Bf': 10, 'Bn': 11
    }

    # Interval semitone distances for different triad types
    triad_intervals = {
        'j': [0, 4, 7],  # Major: root, major third, perfect fifth
        'n': [0, 3, 7],  # Minor: root, minor third, perfect fifth
        'd': [0, 3, 6],  # Diminished: root, minor third, diminished fifth
        'a': [0, 4, 8]   # Augmented: root, major third, augmented fifth
    }

    # Parsing the label
    parts = label.split(', ')
    base_note = parts[2].split(': ')[1]
    triad_type = parts[3].split(': ')[1]

    # Calculate the notes of the triad
    root_semitone = note_semitones[base_note]
    triad_notes = []
    for interval in triad_intervals[triad_type]:
        # Calculate the semitone of each note in the triad
        note_semitone = (root_semitone + interval) % 12
        # Find the note name corresponding to this semitone
        note_name = next(key for key, value in note_semitones.items() if value == note_semitone)
        triad_notes.append(note_name)

    return triad_notes

# Example usage
label = "Instrument: piano, Octave: 3, Base note: Af, Triad type: d"
triad_notes = get_triad_notes(label)



# Example usage (not executable here as it requires a directory of images):
# directory_path = 'path/to/spectrogram/directory'
# simplified_spectrogram_labels = label_simplified_spectrograms(directory_path)
# print(simplified_spectrogram_labels)

