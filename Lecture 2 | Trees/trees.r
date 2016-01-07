# trees.r
# MWL, Lecture 2
# Author(s): [Phil Snyder]

#install.packages("mlbench") # we can download new libraries right from the R terminal!
library(mlbench)
#help(package="mlbench")
data(BreastCancer)
#help(topic="BreastCancer", package="mlbench")
BreastCancer$Id <- NULL # Just get rid of this column. We won't need it.

# Let's fit a tree to our data
library(rpart) # rpart stands for "recursive partitioning"
basicTree <- rpart(Class ~ ., BreastCancer, method='class')
basicTree 
plot(basicTree) 
text(basicTree, cex=0.7) # cex controls text size
# Try leaving the "type='class'" parameter out of the next line.
# What do you think happens? Is this maybe a good thing to do in this application?
basicTreePredictions <- predict(basicTree, BreastCancer, type='class')
basicTreeResults <- table(basicTreePredictions == BreastCancer$Class) / length(basicTreePredictions)
basicTreeResults # TRUE: 0.9642, FALSE: 0.0357

# Why don't we try growing our tree so far down that every node contains only one class?
godTree <- rpart(Class ~ ., BreastCancer, method='class', 
                 control=c(cp=-1, minsplit=2, minbucket=1))
plot(godTree)
text(godTree, cex=0.6) 
godTreePredictions <- predict(godTree, BreastCancer, type='class')
godTreeResults <- table(godTreePredictions == BreastCancer$Class) / length(godTreePredictions)
godTreeResults # TRUE: 1, FALSE: 0

"
Amazing! We have a perfect predictor. All other machine learning algorithms cower in 
sight of the glorious predictive power of godTree.

Of course, I'm kidding. What happens when a new data point comes along and, due to 
uncertainty, randomness, etc., doesn't conform perfectly to the model we have constructed?
We are interested in how well our predictor performs on *unseen*, future data, so we must 
'holdout' some data when we fit our model, then see how well the model performs on our
holdout data. This will give us a good estimate of how well our model *actually* performs
on unseen data.

In general, we partition our data into a 'train' set, which we fit our model to, 
and a 'test' set, which we evaluate our model on. This is the most basic form of 
cross-validation.
"

partition <- sample(nrow(BreastCancer), floor(0.7 * nrow(BreastCancer)))
trainData <- BreastCancer[partition,]
testData <- BreastCancer[-partition,] # can you guess what the '-' operator is doing here?

godTree <- rpart(Class ~ ., trainData, method='class', 
                 control=c(cp=-1, minsplit=2, minbucket=1))
godTreeTrainPredictions <- predict(godTree, trainData, type='class')
godTreeTestPredictions <- predict(godTree, testData, type='class')

godTreeTrainResults <- table(godTreeTrainPredictions 
                             == trainData$Class) / length(godTreeTrainPredictions)
godTreeTrainResults # Accuracy on train set TRUE: 1, FALSE: 0
godTreeTestResults <- table(godTreeTestPredictions 
                               == testData$Class) / length(godTreeTestPredictions)
godTreeTestResults # Accuracy on test set (approx.) TRUE: 0.9523, FALSE: 0.0476

# Still pretty good, but this is a relatively easy classification problem.
# When we have significantly higher accuracy on the training data as opposed to the 
# test data, this is called 'overfitting'. We fit our model to the train data *too* well.

"
We now have a model, and a way to accurately test the predictive power of our model by
partitioning our data into a training set and a test set. The question remains, what 
parameters should our model have, and what values should they take on? 
In the case of linear regression, our parameters are 
the slope and intercept of the regression line. In the case of decision trees, our 
parameters should control how far down we grow our tree. There are a few ways to do this,
but in the rpart function we may control the growth of our tree by varying the 
complexity parameter (cp), the minimum # of data points in a node needed to consider a 
split (minsplit), the minimum amount of data points that are allowed to sit in a 
leaf (minbucket), or the maxdepth of the tree (maxdepth). 
You may look up what exactly a 'complexity parameter' is, but all 
you really need to know is that the lower your cp, the more your tree will grow (subject
to the minsplit, minbucket, maxdepth constraints). Setting cp = -1 (like in the 
godTree example) will tell rpart to keep splitting until it cannot split anymore 
(again, subject to the minsplit, minbucket, maxdepth constraints).

In general, finding optimal parameters is an optimization problem. Usually a numerical
optimization problem (i.e., there is no closed form optimal solution). More on this 
in later lectures.

We will use an algorithm called 'grid search' to find an optimal parameter set. 
Grid search is just a fancy name for trying-every-reasonable-combination-of-parameters. Since
cp, minsplit, minbucket, and maxdepth are each different ways of measuring the same thing,
we can effectively tell rpart to ignore the minsplit, minbucket, and maxdepth constraints and only 
consider the cp for a 'good enough' optimization of our parameters.
"

# R is a functional language, so it can be frustratingly difficult to do something as 
# simple as add an element to the end of an array (vector). We use the foreach library
# to streamline the process. We will also be using a new dataset from a new library
# ElemStatLearn, 'Spam', which is more difficult to classify and illustrates 
# the concept better.
#install.packages(c("foreach", "ElemStatLearn"))
library(foreach)
library(ElemStatLearn)
data(spam)
#help(topic="spam", package="ElemStatLearn")

partition <- sample(nrow(spam), floor(0.7 * nrow(spam)))
trainData <- spam[partition,]
testData <- spam[-partition,] 

cpValues <- c(0.5, 0.1, 0.05, 0.01, 0.005, 0.001, 0.0005, 0.0001)
treesLoss <- foreach(val = cpValues, .combine='c') %do% {
    ctrl <- rpart.control(cp=val, minsplit=2, minbucket=1) # maxdepth defaults to 30
    tree <- rpart(spam ~ ., trainData, method='class', control=ctrl)
    treePredictions <- predict(tree, testData, type='class')
    # proportion incorrect
    loss <- table(treePredictions == testData$spam)["FALSE"][[1]] / length(treePredictions)
    return(loss)
}
results <- data.frame(cp = cpValues, loss = treesLoss)
# x log scale and reversed
plot(results, log='x', xlim=c(max(results$cp), min(results$cp)), type='o') 

"
Great. Around 1e-3 seems optimal. BUT, we have made yet another naive mistake. 
Decision trees are *high variance* predictors. This means that the decision trees
we generate are highly dependent on the specific data points in our training dataset. 
If we had sampled a different training set, it's possible we may have had a different 
optimal value. To counterbalance this variability, we use k-fold cross-validation.
Wikipedia has a nice paragraph on k-fold CV:
https://en.wikipedia.org/wiki/Cross-validation_(statistics)#k-fold_cross-validation

In the above article 'validation set' is similar to a test set. We will discuss 
validation sets and why we need them later. K-fold CV reduces variability (in 
the traditional statistical sense of the word) by averaging our results.

This issue alludes to something you will need to know about (eventually), but probably 
won't be covered this lecture. That is the Bias-Variance Tradeoff 
https://en.wikipedia.org/wiki/Bias%E2%80%93variance_tradeoff
"

# do 10-fold CV
trainData <- trainData[sample(nrow(spam)),] # randomly permute the rows in our data frame
partitionSize <- floor(nrow(trainData) / 10)
treesLoss <- foreach(val = cpValues, .combine='c') %do% {
    ctrl <- rpart.control(cp=val, minsplit=2, minbucket=1) 
    summedResults <- 0
    for (i in seq(1, nrow(trainData) - partitionSize, partitionSize)) {
        validationSetIndices <- i:(i + partitionSize - 1) # seq from i to (partitionSize-1)
        validationData <- trainData[validationSetIndices,]
        nonValidationData <- trainData[-validationSetIndices,]
        tree <- rpart(spam ~ ., nonValidationData, method='class', control=ctrl)
        treePredictions <- predict(tree, validationData, type='class')
        loss <- table(treePredictions == validationData$spam)["FALSE"][[1]] / length(treePredictions)
        summedResults <- summedResults + loss
    }
    averagedResults <- summedResults / 10
    return(averagedResults)
}
cvResults <- data.frame(cp = cpValues, loss = treesLoss)
plot(cvResults, log='x', xlim=c(max(results$cp), min(results$cp)))

# Now we have a nice, smooth curve, and the optimal cp value will either be 1e-3 or 5e-4 depending 
# on how easy to classify your test set happens to be (Sometimes we repeat the k-fold CV process
# itself multiple times to eliminate this 'lucky draw' element). If you're bored you can modify 
# the code and plot the standard error bars on top of each data point. Another way of choosing the 
# optimal parameter is to choose the value that gives the loosest fit to the training data yet is 
# still within one standard error of the "best" value.

# So how good is a decision tree with an optimal parameter value?
bestTree <- rpart(spam ~ ., trainData, method='class', control=c(cp=1e-3, minsplit=2, minbucket=1))
bestTreePredictions <- predict(bestTree, testData, type='class')
bestTreeResults <- table(bestTreePredictions == testData$spam) / length(bestTreePredictions)
bestTreeResults # (approx.) TRUE: 0.9225, FALSE: 0.07748

"
Now that we've made it this far, I can tell you a secret: Decision Trees are relatively crude 
predictors. Yet we are still able to correctly identify 92% of emails as either spam or 
not spam using a singe decision tree and the 'bag-of-words' model (this is how the variables 
in our spam data were generated, see [ESL 9.2.5]). To create even more powerful tree-based 
predictors, we must learn about ensembles... (see treeEnsembles.r)
"
