plot_prf1 <- function(prf1_df) {
  ggplot2::ggplot(data = prf1_df, ggplot2::aes(x = threshold)) +
      ggplot2::geom_line(ggplot2::aes(y = precision, group = draw, color = "Precision"), alpha = 0.2) +
      ggplot2::geom_line(ggplot2::aes(y = recall, group = draw, color = "Recall"), alpha = 0.2) +
      ggplot2::geom_line(ggplot2::aes(y = f1, group = draw, color = "F1"), alpha = 0.2) +
      ggplot2::ylim(0,1)
}
