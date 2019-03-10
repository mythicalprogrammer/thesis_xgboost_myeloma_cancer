myeloma_data <-
  read.csv(
    "start_data/GDS531_after_anova.csv",
    header = TRUE,
    stringsAsFactors = FALSE
  )

train <- myeloma_data[, !names(myeloma_data) %in% c("state")]
label <- myeloma_data$state

for (i in 1:length(label)) {
  if (label[i] == "WO") {
    label[i] <- 0
  } else {
    label[i] <- 1
  }
}


rand_seed <- 1030
set.seed(rand_seed)

pred <- c()
for (i in 1:nrow(train)) {
  leftout_row <- train[i,]
  kth_fold_train <- train[-i,]
  kth_fold_response <- label[-i]

  kth_train <- data.matrix(kth_fold_train)
  kth_label <- data.matrix(kth_fold_response)
  kth_test <- data.matrix(leftout_row)

  kth_fit <-
    xgboost(
      data = kth_train,
      label = kth_label,
      nround = 100,
      objective = "multi:softmax",
      num_class = 2
    )
  pred[i] <- predict(kth_fit, kth_test)
}

# back up the result since this took awhile to run
file_path  <- 'result_xgboost.csv'
write.csv(pred,
          file = file_path,
          row.names = FALSE)
