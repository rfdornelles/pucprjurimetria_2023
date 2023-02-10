# baixar casos

library(tjsp)

pasta <- "data-raw/exemplo_covid"
pasta_detalhes <- paste0(pasta, "/detalhes")

dir.create("data-raw", showWarnings = FALSE)
dir.create(pasta, showWarnings = FALSE)
dir.create(pasta_detalhes, showWarnings = FALSE)

tjsp_baixar_cjsg(livre = "covid",
                 classe = "307",
                 inicio = "26/02/2020",
                 fim = "31/12/2020",
                 diretorio = pasta)

autenticar()


base_tj <- tjsp_ler_cjsg(diretorio = pasta)

tjsp_baixar_cposg(processos = base_tj$processo, diretorio = pasta_detalhes)
