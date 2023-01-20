test_that("multiplication works", {
  url_1 <- "https://seape.df.gov.br/wp-content/uploads/2023/01/pfdf-20.01.pdf"

  pdf_1 <- extrair_dados_pdf(url_1)

  readr::write_csv(pdf_1, "data-raw/dados-pfdf-20.01.csv")

  url_2 <- "https://seape.df.gov.br/wp-content/uploads/2023/01/cdp2-20.01-2.pdf"

  pdf_2 <- extrair_dados_pdf(url_2)

  readr::write_csv(pdf_2, "data-raw/dados-cdp2-20.01-2.csv")


  url_3 <- "https://seape.df.gov.br/wp-content/uploads/2023/01/cime-20.01.pdf"

  pdf_3 <- extrair_dados_pdf(url_3)

  readr::write_csv(pdf_3, "data-raw/dados-cime-20.01.csv")


  dplyr::bind_rows(pdf_1, pdf_2, pdf_3)  |>
    readr::write_csv("data-raw/dados-20.01.csv")



})
