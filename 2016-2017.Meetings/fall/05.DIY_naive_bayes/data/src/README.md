# Generating Data 

### Downloading raw tweets 

To download the raw tweets, you need a twitter API developer account. You can
create an account and generate a new application
[here](https://apps.twitter.com/). Once you have an account, create a new
"Twitter App" and generate a new "Access Token" under the "Keys and Access
Tokens" tab. Then, edit `get_raw_tweets.py` to fill in your own account details.

To download the raw tweets of a user, say `HillaryClinton`, simply run:

```
python get_raw_tweets.py HillaryClinton
```

In this example, we have downloaded the raw tweets from `HillaryClinton` and
`realDonaldTrump`.


### Generating Train and Test Data

To generate the train and test data from two csv files with raw tweets generated
as shown above, simply run:

```
python generate_train_test_data.py <path_to_csv1> <path_to_csv2>
```

In our example, under this directory structure, we ran:

```
python generate_train_test_data.py ../raw_tweets/HillaryClinton_tweets.csv ../raw_tweets/realDonaldTrump_tweets.csv
```
