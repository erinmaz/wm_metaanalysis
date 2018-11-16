from neurosynth import Dataset
from neurosynth import meta, decode, network 

dataset = Dataset('./database.txt')
dataset.add_features('./features.txt')
dataset.save('dataset.pkl')
dataset = Dataset.load('dataset.pkl')

ids = dataset.get_studies(mask='jhu-Splenium.nii', return_type='ids')
wids = dataset.get_studies(mask='jhu-Splenium.nii', return_type='weights')
pids = dataset.get_studies(mask='jhu-Splenium.nii', return_type='images')


print ids