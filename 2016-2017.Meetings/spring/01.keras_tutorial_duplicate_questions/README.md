# Keras and Deep Learning for NLP: A tutorial

This folder contains the materials for a tutorial on Keras / Keras for NLP,
presented at the Machines Who Learn meeting on April 3, 2017 by
[Nelson Liu](https://github.com/nelson-liu) and
[Jonathan Lee](https://github.com/leejt).

## Getting the Data

To get the raw data, download the Quora Question Pairs training set
[from Kaggle](https://www.kaggle.com/c/quora-question-pairs/data). You're going
to want to download the zipped train data, then extract the csv and put it in
`./data/raw/`. Once its there, you can run notebooks 01 and 02 to get the
pickled processed data. Alternatively, you can read on for instructions for
downloading the processed data directly.

You may have to log in / create an account before you can do so, so I've uploaded
the pickled output from notebooks 01 and 02, which would enable you to train 
a model without getting the raw data / running the processing notebooks.

You can get it (a zipped archive) at: http://nelsonliu.me/files/processed_quora_data.zip

Unzip the contents of `processed_quora_data.zip` to `./data/processed/`, and
things should just work.

## Installing the requirements

These notebooks should be compatible with Python 2 and 3, but they were created
with Python 3.5.3 on Keras 2.0.2 with tensorflow 1.0.1. To install the requirements
for running the data processing notebooks, run:

```
pip install -U -r data_requirements.txt
```


To install the requirements for running the model training notebook, run:

```
pip install -U -r model_requirements.txt
```

If you're lucky to have access to a machine with a GPU, you should consider
using GPU-acceleration to train your models. To do this, just uninstall
`tensorflow` (`pip uninstall tensorflow`) and install `tensorflow-gpu` (`pip
install tensorflow-gpu`)

**If you find that something doesn't work, please raise an
issue on the repo. Thanks!**
