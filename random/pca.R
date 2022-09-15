## Link: https://www.datacamp.com/tutorial/pca-analysis-r

## Also refer to https://stackoverflow.com/questions/54864912/prcomp-retx-true-do-i-get-the-new-data-to-train-over

## Omit categorical variables

mtcars.pca <- prcomp(mtcars[,c(1:7,10,11)], center = TRUE,scale. = TRUE)

summary(mtcars.pca)

View(mtcars.pca)

objects(mtcars.pca)

head(mtcars.pca$rotation)

head(mtcars)
dim(mtcars)

## Now train mtcars.pca$x, which has 32 rows as mtcars but we can take only 
## 3 columns. 

