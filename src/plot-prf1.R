plot_prf1 <- function(prf1_df, title) {
  ggplot2::ggplot(data = prf1_df, ggplot2::aes(x = threshold)) +
      ggplot2::geom_line(ggplot2::aes(y = precision, group = draw, color = "Precision")) +
      ggplot2::geom_line(ggplot2::aes(y = recall, group = draw, color = "Recall")) +
      ggplot2::geom_line(ggplot2::aes(y = f1, group = draw, color = "F1")) +
      ggplot2::geom_line(ggplot2::aes(y = mcc, group = draw, color = "MCC")) +
      ggplot2::ylim(0,1) + 
      ggplot2::ggtitle(title)
}
