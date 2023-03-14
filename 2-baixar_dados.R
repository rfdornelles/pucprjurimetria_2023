###########################################################################
### JURIMETRIA, LEGAL HACKING E INTELIGÊNCIA ARTIFICIAL
### Extração de Dados: Como Obter o Melhor dos Dados
### Prof. José de Jesus Filho (referência)
### Prof. Rodrigo Dornelles (Hertie School)


# Carregar pacotes --------------------------------------------------------

# Sempre o primeiro passo! Lembrando que já instalamos os pacotes na aula
# anterior e, por isso, não faremos novamente.

library(tidyverse) # conjunto de pacotes para ciência de dados
library(tjsp)      # pacote jurimétrico do TJ-SP

# Baixando os dados da aula anterior --------------------------------------

### ****NÃO**** faremos esse passo em aula por tomar muito tempo!

# Definir a expressão de busca
exp <- '165704 OU 165.704'

# Definir pasta em um objeto
pasta <- "data-raw/exemplo_hc_coletivo"

# Criar as pastas
dir.create("data-raw", showWarnings = FALSE) # cria pasta padrão para dados crus
dir.create(pasta, showWarnings = FALSE)

# Comando para baixar os dados gerais da consulta

tjsp_baixar_cjsg(livre = exp,
                 #classe = "307",
                 assunto = "",
                 orgao_julgador = "",
                 inicio = "", # dd/mm/aaaa
                 fim = "", # dd/mm/aaaa
                 inicio_pb = "", # dd/mm/aaaa
                 fim_pb = "", # dd/mm/aaaa
                 tipo = "A",
                ### n = 1, # na "vida real" deixaremos NULL ou omitiremos essa linha
                 diretorio = pasta)


# Ler a tabela:
tabela <- tjsp_ler_cjsg(diretorio = pasta)

# Baixar informações adicionais -------------------------------------------

# Daqui pra frente é necessário autenticação:
autenticar()

# crio uma nova pasta dentro da pasta anterior
# definir o nome:
pasta_detalhes <- paste0(pasta, "/detalhes")

# criar a pasta:
dir.create(pasta_detalhes, showWarnings = FALSE)

# baixar os detalhes em si
tjsp_baixar_cposg(processos = tabela$processo, diretorio = pasta_detalhes)

# Ler as informações adicionais -------------------------------------------

# ler as partes
partes <- tjsp_ler_partes(diretorio = pasta_detalhes)

# ler os andamentos
andamentos <- ler_movimentacao_cposg(diretorio = pasta_detalhes)

# ler o dispositivo das decisões
dispositivo <- tjsp_ler_decisoes_cposg(diretorio = pasta_detalhes)


# Exportar ----------------------------------------------------------------

# exportar a tabela de cjsg
write_rds(tabela, paste0(pasta, "/tabela.rds"))

# andamentos
write_rds(andamentos, paste0(pasta, "/andamentos.rds"))

# partes
write_rds(partes, paste0(pasta, "/partes.rds"))

# dispositivo
write_rds(dispositivo, paste0(pasta, "/dispositivo.rds"))

