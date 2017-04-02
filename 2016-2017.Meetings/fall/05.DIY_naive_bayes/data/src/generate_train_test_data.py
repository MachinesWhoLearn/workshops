#!/usr/bin/env python
# encoding: utf-8

import csv
import re
import logging
from sklearn.model_selection import train_test_split

log_fmt = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
logging.basicConfig(level=logging.INFO, format=log_fmt)
logger = logging.getLogger(__name__)

def generate_train_test_data(file0, file1):
    tweets, labels = read_and_clean_csv(file0, file1)
    X_train, X_test, y_train, y_test = train_test_split(tweets, labels,
                                                        test_size=0.25, random_state=0)
    logger.info("Writing train set tweets")
    with open("../tweets_train.txt", "w") as train_data_file:
        for train_tweet in X_train:
            train_data_file.write("{}\n".format(train_tweet))

    logger.info("Writing test set tweets")
    with open("../tweets_test.txt", "w") as test_data_file:
        for test_tweet in X_test:
            test_data_file.write("{}\n".format(test_tweet))

    logger.info("Writing train set labels")
    with open("../labels_train.txt", "w") as train_labels_file:
        for train_label in y_train:
            train_labels_file.write("{}\n".format(train_label))

    logger.info("Writing test set labels")
    with open("../labels_test.txt", "w") as test_labels_file:
        for test_label in y_test:
            test_labels_file.write("{}\n".format(test_label))

def read_and_clean_csv(file0, file1):
    # label 0 is file0, label 1 is file1
    tweets = []
    labels = []
    for filename, label in [(file0, 0), (file1, 1)]:
        with open(filename) as f0:
            reader = csv.reader(f0)
            next(reader, None)  # skip the headers
            for raw_tweet in reader:
                tweet_text = raw_tweet[2]
                sanitized_tweet_text = sanitize_text(tweet_text)
                if sanitized_tweet_text:
                    tweets.append(sanitized_tweet_text)
                    labels.append(label)
    return tweets, labels

def sanitize_text(tweet_str):
    # remove @mentions
    tweet_str = re.sub(r"@\S+", "", tweet_str)

    #remove hashtags
    tweet_str = re.sub(r"#\S+", "", tweet_str)

    # remove links
    tweet_str = re.sub(r"http\S+", "", tweet_str)
    # normalize whitespace again
    tweet_str = " ".join(tweet_str.split())
    return tweet_str

if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise ValueError("Usage: python generate_train_test_data.py "
                         "<file0_path> <file1_path>. "
                         "Wrong number of arguments received.")
    generate_train_test_data(sys.argv[1], sys.argv[2])
