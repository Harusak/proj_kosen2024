## Usage
## save_plot(plot,170,"save file name", extensions = "PDF,PNG,SVG")
##   - figSize は必要に応じて変更．
##   - extantions は[PDF, PNG, SVG, EPS]から必要なもののみ

save_plot <- function(p, figSize, outputFileName, extensions="eps") {
  # system('taskkill /f /im Acrobat.exe')
  folder <- here("Analysis/plots/")

  extensions = unlist(strsplit(extensions,","))

  if(sum(extensions %in% c("PDF","pdf")) >= 1){
    ggsave(
      plot = p, width = figSize, height = figSize, dpi = 300, units = "mm",
      # device = cairo_pdf,
      filename = paste(folder,outputFileName, ".pdf", sep = "")
    )
  }

  if(sum(extensions %in% c("EPS","eps")) >= 1){
    ggsave(
      plot = p, width = figSize, height = figSize, dpi = 300, units = "mm",
      filename = paste(folder,outputFileName, ".eps", sep = "")
    )
  }

  if(sum(extensions %in% c("PNG","png")) >= 1){
    ggsave(
      plot = p, width = figSize, height = figSize, dpi = 300, units = "mm",
      filename = paste(folder,outputFileName, ".png", sep = "")
    )
  }

  if(sum(extensions %in% c("SVG","svg")) >= 1){
    ggsave(
      plot = p, width = figSize, height = figSize, dpi = 300, units = "mm",
      filename = paste(folder,outputFileName, ".svg", sep = "")
    )
  }

}