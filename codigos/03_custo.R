library(reticulate)
library(purrr)
library(TheOpenAIR)

paginas_em_r <- py$paginas

# metadatos da primeira pagina
paginas_em_r[[1]]$metadata 

# quantidade de caracteres da centésima pagina
nchar(paginas_em_r[[100]]$page_content) 

partes_pdf <- py$partes_pdf
length(partes_pdf)

(total_tokens <- purrr::map_int(partes_pdf, 
                                ~ TheOpenAIR::count_tokens(.x$page_content)) |> 
    sum())

# custo em USD
total_tokens / 1e6 * 0.10