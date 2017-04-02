# Classification Competition

You have 50 minutes to build a classifier to detect email spam. The training
data is pickled in `spam_train.pkl`. You can use `sklearn.externals.joblib` to
load it, as shown
[here](http://scikit-learn.org/stable/modules/model_persistence.html). It is
stored in the same kind of object as returned by `load_digits` - i.e., an object
with attributes `data`, which contains the input data, `target`, which
contains the labels, and `feature_names`, in case you are curious what the column names of the input are. There is a starter template in the form of a jupyter
notebook at the aptly named `starter_template.ipynb`.

Once you are happy with your classifier, you can "dump" it into a pickled file
using `joblib.dump()`. Please name your pickled model `[team-name].pkl` and send it
as an attachment to <mwluw@uw.edu>. You can pick your team name :smile: Good
luck!

Our train and test data are derived from the dataset [here](https://archive.ics.uci.edu/ml/datasets/Spambase).
