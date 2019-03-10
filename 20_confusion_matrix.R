pred_xgboost <- c()
for (i in 1:length(pred)) {
  if (pred[i] == 0) {
    pred_xgboost[i] <- "WO"
  } else {
    pred_xgboost[i] <- "W"
  }
}
levels(pred_xgboost) <- c("WO", "W")
pred_xgboost <- as.factor(pred_xgboost)
levels(pred_xgboost) == levels(as.factor(myeloma_data$state))
cm <- confusionMatrix(pred_xgboost, as.factor(myeloma_data$state))
cm$overall["Accuracy"]
cm

"
Accuracy
0.8265896 for 100 boosting rounds
"
