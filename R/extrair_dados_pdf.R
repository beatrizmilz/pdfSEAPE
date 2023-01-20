# exemplo de url do arquivo
# url <- "https://seape.df.gov.br/wp-content/uploads/2023/01/pfdf-20.01.pdf"

extrair_dados_pdf <- function(url) {
  # extraindo o texto do PDF
  texto <- pdftools::pdf_text(url)

  # transformando a lista em uma tibble BEM bagunçada
  dados_brutos <- tibble::tibble(texto = unlist(texto)) |>
    dplyr::mutate(texto = stringr::str_split(texto, pattern = "\\n")) |>
    tidyr::unnest(cols = c(texto)) |>
    dplyr::filter(texto != "") |>
    tibble::rowid_to_column()

  # extraindo o nome da penitenciária
  tipo_info <- dados_brutos |>
    dplyr::filter(stringr::str_starts(texto, "Penitenciária|Centro")) |>
    dplyr::pull(texto)

  # descobre a linha de inicio do código
  linha_inicio <- dados_brutos |>
    dplyr::filter(
      stringr::str_detect(texto, "Nome"),
      stringr::str_detect(texto, "Data de Nascimento")
    ) |>
    dplyr::pull(rowid)

  dados_tratados <- dados_brutos |>
    dplyr::slice(linha_inicio + 1:dplyr::n()) |>
    tidyr::separate(
      texto,
      into = c("nome", "texto"),
      sep = "   ",
      extra =  "merge",
      fill = "right"
    ) |>
    dplyr::mutate(nome = stringr::str_trim(nome),
                  texto = stringr::str_trim(texto)) |>
    tidyr::separate(
      texto,
      into = c("data_nascimento", "uf"),
      sep = " ",
      extra =  "merge",
      fill = "right"
    ) |>
    dplyr::select(-rowid) |>
    dplyr::mutate(tipo_informacao = tipo_info,
                  arquivo_extracao = url)

  dados_tratados
}
