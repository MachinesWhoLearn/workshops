# treeEnsembles.r
# MWL, Lecture 2
# Author(s): [Phil Snyder]

"
An ensemble is a predictor that obtains its predictions by taking a weighted average of multiple 
single predictors. We will look at three different types of tree-based ensembles: bagging, 
random forests, and boosting with trees. Both random forests and boosting are methods 
used in industry every day - and can be very powerful predictors.
"

library("ElemStatLearn")
data("spam")

partition <- sample(nrow(spam), floor(0.7 * nrow(spam)))
trainData <- spam[partition,]
testData <- spam[-partition,] 

# Bagging

"
Bagging is a portmanteau of 'bootstrap aggregation'. 'Bootstrap' is a sampling method where you 
sample from a data set *with replacement*. Usually your sample size is equivalent to the size of 
the original data set. 'Aggregation' refers to the fact that we are aggregating or averaging the 
predictors (in the case of classification, by having them take a vote on the class) trained on 
our bootstrap samples. Typically bagging only helps in the case of high variance predictors (such
as decision trees) because it reduces variance while maintaining bias (again, see bias-variance 
trade-off). More info available in [ESL 8.7].
"

#install.packages("ipred")
library("ipred")
bagg <- bagging(spam ~ ., trainData, nbagg=50) # 50 trees
# Of course, normally we would do CV to find the optimal parameters 
# (implicit here are the rpart parameters)
baggPredictions <- predict(bagg, testData)
baggResults <- table(baggPredictions == testData$spam) / length(baggPredictions)
baggResults # (approx.) TRUE: 0.924, FALSE: 0.0760

# Random Forests

"
Random Forests are similar to bagging, except each tree is only trained on a random subset of the 
dimensions of the original dataset. For example, if our data had dimensions V1, ..., V10
we might train the first tree on dimensions V1, V4, V8 and our second tree on V2, V4, V5, etc.
We do this so that our individual trees become less *correlated*. The correlation between trees 
limits how good of a predictor we may obtain by averaging their individual predictions. You 
may also think of the individual trees in a random forest as being 'experts' in a specific domain. 
The more limited the domain of the expert, the deeper and more refined the experts knowledge becomes 
in that domain. For more info see [ESL 15].
"

#install.packages("randomForest")
library("randomForest")
rf <- randomForest(spam ~ ., trainData, ntree=80) # 80 trees trained on random dimensions
# in classification, by default we randomly select m = floor(sqrt(p)) dimensions to train on
# where p is the # of dimensions in our original dataset.
rfPredictions <- predict(rf, testData)
rfResults <- table(rfPredictions == testData$spam) / length(rfPredictions)
rfResults # (approx.) TRUE: 0.945, FALSE: 0.055

"
This is our best predictor yet, though random forests have their limits. If the dimensions 
of our data have very little to do with how the class is determined, then it's likely many of 
the trees will make decisions based on useless information, adding noise to our predictions.
"

# Boosting

"
Here we will do boosting with decision trees, though it is possible to do boosting with different 
predictors. The general idea behind boosting is that each data point in the training set is given 
a weight. At first these weights are all equal. We then fit a tree to the train data. For every data 
point that the tree classifies incorrectly, we increase its weight. We then fit a second tree 
to the data. The second tree gives the data points with greater weight greater importance, and is 
less likely to classify them incorrectly. The process then repeats, iterating sequentially through 
each dimension. This will perhaps become more clear when we talk about loss/objective 
functions. For more info see [ESL 10].
"

#install.packages("adabag")
library("adabag")
boost <- boosting(spam ~ ., trainData, mfinal=100) # 100 boosted trees
boostPredictions <- predict(boost, testData)
boostPredictions$error # proportion incorrect

"
Boosting is a powerful idea, and we will generalize it to other predictors later.

You may have noticed that it took a fair amount of time to fit our models to the data. This is 
where the 'computer science' portion of machine learning comes into play. The most powerful 
predictors (usually ensembles, or various forms of neural nets, or both) can take days to train, 
even with extreme computational optimization. Next lecture we will take a closer look at the 
optimization of our model parameters as well as some more archetypical concepts in machine learning.
"
