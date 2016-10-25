# helloMachine.r
# MWL, Lecture 1
# Author(s): [Phil Snyder]
#
# TO RUN ALL THE CODE IN THIS FILE AT ONCE, 
# CALL source("helloMachine.r") FROM THE R TERMINAL.

data(iris) # load data (dataset "iris" comes with your R installation).

# R doesn't support multi-line comments, but we can get away with benignly passing it 
# a string instead. Try out these commands!
"
iris
help(topic='iris', package='datasets')
names(iris)
class(iris)
str(iris) # str := structure
levels(iris$Species)
?levels
nrow(iris)
ncol(iris)
iris[1:3,] # pay attention to where the comma is!
iris[,1:3]
iris$Sepal.Length
iris[,'Sepal.Length']
"

# first we will do regression
setosa <- iris[iris$Species == "setosa",] # get rows from iris where Species == "setosa"
linearModel <- lm(formula = Sepal.Length ~ Sepal.Width, data = setosa) # ~ := "as explained by"
"
linearModel
names(linearModel)
linearModel$call
"
plot(formula = Sepal.Length ~ Sepal.Width, data = setosa)
abline(linearModel) # run this line of code while your plot is still showing

# sapply is like a map function
squaredResiduals <- sapply(linearModel$residuals, function(x) return(x^2)) 

meanSquaredError <- sum(squaredResiduals) / length(squaredResiduals)
meanSquaredError # 0.0546

setosaMinusOutlier <- setosa[-42,] # remove potential outlier, repeat steps to compare errors
fixedLinearModel <- lm(Sepal.Length ~ Sepal.Width, setosaMinusOutlier)
fixedSquaredResiduals <- sapply(fixedLinearModel$residuals, function(x) return(x^2)) 
fixedSquaredError <- sum(fixedSquaredResiduals) / length(fixedSquaredResiduals)
fixedSquaredError # 0.0538, not much improvement in this case

"
When is removing outliers justified? What if we had seen a significant decrease in the 
squared error? Is Sepal.Length ~ Sepal.Width a smart thing to model, or are there 
hidden variables? (i.e., mean amount of daily sunshine, precipitation levels, 
exposure to wind, ...).
"

# now for some classification
flowers <- subset(iris, Species == "setosa" | Species == "virginica")
# equivalently flowers <- iris[iris$Species == "setosa" | iris$Species == "virginica",]
# R has different "OR" operators depending on whether we are doing operations 
# on matrix like objects or atomic objects. Be sure to use a single bar | here.

# Here our data has two classes. This is referred to as binary classification.
plot(flowers, pch=sapply(flowers$Species, substr, 1, 1))
flowers$Species <- as.factor(flowers$Species)
"
In this case, this is unnecessary because class(flowers$Species) == factor already, 
but in general we need to make our categorical response variables factors for classification.
"
flowers <- droplevels(flowers) # need to drop "versicolor" from Species levels since it's empty
dotchart(flowers$Petal.Length, pch=sapply(flowers$Species, substr, 1, 1))
# notice how the data is linearly separable. (In dot charts the y-axis is meaningless).

# 1-d case
library(MASS)
oneLinearClass <- lda(Species ~ Petal.Length, flowers)
# lda stands for Linear Discriminant Analysis. How it works is not important for now.
# Just know that it attempts to draw a straight line separating our two classes.
onePredictions <- predict(oneLinearClass, flowers)
onePredictionResults <- table(onePredictions$class == flowers$Species) / length(flowers$Species)
onePredictionResults # TRUE: 1, FALSE: 0
# Wow! 0 error! Who would've thunk.

# 2-d case
plot(Sepal.Length ~ Sepal.Width, flowers, pch=sapply(flowers$Species, substr, 1, 1))
twoLinearClass <- lda(Species ~ Sepal.Length + Sepal.Width, flowers)
twoPredictions <- predict(twoLinearClass, flowers)
twoPredictionResults <- table(twoPredictions$class == flowers$Species) / length(flowers$Species)
twoPredictionResults # TRUE: 0.99, FALSE: 0.01
# Here LDA is not perfect, although our data is (barely) linearly separable.
# This is because we abused the LDA assumption that the two classes have the 
# same covariance matrix. (More on this in later lectures).

# Now let's try the entire iris dataset, including Species == "versicolor"
# in n-dimensions. n = 4 here, since we have 4 features (we don't include our "Species" label).
labelMapper <- function(s) { # this is just to help us plot the data in the next line
    if (s == "setosa") return(1)
    if (s == "versicolor") return(2)
    if (s == "virginica") return(3)
}
plot(iris[,1:4], pch=sapply(iris$Species, labelMapper))
nLinearClass <- lda(Species ~ ., iris) # Species ~ . := Species as explained by "everything"
nPredictions <- predict(nLinearClass, iris)
nPredictionResults <- table(nPredictions$class == iris$Species) / length(iris$Species)
nPredictionResults # TRUE: 0.98, FALSE: 0.02
"
This is actually pretty good, especially since all we're doing is drawing 
a hyperplane through our 4 dimensional data!

BUT, as we'll see next lecture, we have done something egregious that has given us a 
false sense of confidence about the accuracy of our predictor...
"
