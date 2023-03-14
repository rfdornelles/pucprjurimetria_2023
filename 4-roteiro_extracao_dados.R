###########################################################################
### JURIMETRIA, LEGAL HACKING E INTELIGÊNCIA ARTIFICIAL
### Extração de Dados: Como Obter o Melhor dos Dados
### Prof. José de Jesus Filho (referência)
### Prof. Rodrigo Dornelles (Hertie School)

### Esse roteiro foi elaborado para ajudar a vocês a realizarem suas próprias
# extrações de dados jurimétricos. Utilize como referência.


# Criar projeto -----------------------------------------------------------

# Estamos dentro de um projeto no RStudio? Se não, é hora de estar!
# Criando projeto no RStudio: <https://livro.curso-r.com/2-3-projetos.html>

# Instalação de pacotes ---------------------------------------------------

# Lembrando que a INSTALAÇÃO só precisa ser feita uma vez com os comandos
# install.packages() e afins

# Contudo, o pacote SEMPRE precisará ser carregado quando abrirmos uma nova
# sessão no R com o comando library()
# Aqui vamos fazer isso mais pra fente (enquanto falamos, deixamos rodando)

install.packages("tidyverse") # nos ajuda a trabalhar com os dados
install.packages("writexl")   # permite salvar arquivos de excel
install.packages("remotes")   # permite baixar pacotes adicionais

## instalação de pacotes jurimétricos
remotes::install_github("jjesusfilho/tjsp")
remotes::install_github("jjesusfilho/JurisVis")
remotes::install_github("courtsbr/JurisMiner")
remotes::install_github("jjesusfilho/stf")
remotes::install_github("jjesusfilho/stj")

## outros pacotes úteis para jurimetria
remotes::install_github("abjur/abjData")
remotes::install_github("abjur/abjutils")

# Primeiro passo: definir o objeto ----------------------------------------

# É importante definir:
# -   quais os Tribunais que iremos raspar (abrangência territorial)
# -   qual o espaço de tempo (a partir do ano de 2016, por exemplo)
# -   qual instância iremos olhar (apenas 2º? primeiro também?)
# -   quais as classes processuais
# -   quais os termos de pesquisa
# -   etc...

# | Tribunal:         |
# | Espaço de tempo:  |
# | Instância         |
# | Classe processual |
# | Termo de pesquisa |

# Carregar os pacotes que vamos utilizar -------------------------------------

# após instalar:
library(tidyverse) # nosso "canivete suíço" para análise de dados
library(tjsp) # carrega o pacote propriamente dito
library(writexl) # opcional, permite salvar os resultados em excel

# Usaremos a função `tjsp_baixar_cjsg()`
# (sabendo que "cjsg" significa "Consulta Julgados de Segundo Grau")

# Preenchendo:
# o parâmetro: `livre`com nosso termo de pesquisa e
# o parâmetro `diretorio` com a pasta que vamos usar.

# O pacote tem uma série de outros parâmetros que podem ser usados na pesquisa
# como classe, assunto, orgao_julgador, data de início, data de fim, etc.


# Baixando os dados -------------------------------------------------------

# Expressão de busca

exp <- '165704 OU 165.704'

# Escolher uma pasta para receber os resultados

pasta <- "data-raw/exemplo"

# Criar pastas para receber os arquivos
dir.create("data-raw", showWarnings = FALSE) # cria pasta padrão para dados crus
dir.create(pasta, showWarnings = FALSE)

# Realizar a pesquisa

# Aqui é onde colocamos os parâmetros de pesquisa que definimos anteriormente
# se não quisermos colocar nada, podemos deixar em branco (remover), deixar
# como está ou mesmo comentar a linha para que ela seja "ignorada"

# Preencher, conforme o caso, campo de assunto, orgao_julgador, datas, etc
tjsp_baixar_cjsg(livre = exp,
                 classe = "",
                 assunto = "",
                 orgao_julgador = "",
                 inicio = "",
                 fim = "",
                 inicio_pb = "",
                 fim_pb = "",
                 tipo = "A",
                 #n = 1, # na "vida real" deixaremos NULL ou omitiremos essa linha
                 diretorio = pasta)

# A depender do tamanho da pesquisa, ela pode levar alguns minutos (ou mesmo
# muitas horas).

# ler a tabela
tabela <- tjsp_ler_cjsg(diretorio = pasta)

# olhar os resultados
tabela


# Exportação para Excel ---------------------------------------------------

# Exemplo de exportação para o formato excel:

write_xlsx(tabela, path = "data-raw/tabela_basica_jurisprudencia.xlsx")

# Salvar em RDS:

write_rds(tabela, file = "data-raw/base_original.rds")

# E, para carregar:
#tabela <- read_rds("data-raw/base_original.rds")

# Algumas análises simples ------------------------------------------------

# Aqui vamos apenas ILUSTRAR algumas análises simples.
# Quantas decisões temos?

nrow(tabela)

# Quais as comarcas com mais decisões?

tabela %>%
  group_by(comarca) %>% # agrupar por comarcas
  count(sort = TRUE) %>% # contar ocorrências
  head()  # ver os primeiros resultados


### Baixando o restante dos dados

# Verificar a necessidade de autenticação.
autenticar()

# crio uma nova pasta dentro da pasta anterior
pasta_detalhes <- paste0(pasta, "/detalhes")

# criar a pasta:
dir.create(pasta_detalhes, showWarnings = FALSE)

# baixar os detalhes em si
tjsp_baixar_cposg(processos = tabela$processo, diretorio = pasta_detalhes)

# Ler os arquivos baixados ------------------------------------------------

### Ler as partes e andamentos

# ler as partes
partes <- tjsp_ler_partes(diretorio = pasta_detalhes)

# ver o resultado
partes

# ler os andamentos
andamentos <- ler_movimentacao_cposg(diretorio = pasta_detalhes)

# ver o resultado
andamentos


### Ler dispositivo da decisão
# Isso permite saber o resultado dos julgamentos sem necessariamente ter que ler
# os arquivos .pdf.

# ler o dispositivo das decisões
dispositivo <- tjsp_ler_decisoes_cposg(diretorio = pasta_detalhes)

# ver o resultado
dispositivo

### Baixar os acórdãos:
# A função é `tjsp_baixar_acordaos_cposg()`e vamos usar os mesmos parâmetros da
# anterior

# dou um nome para uma nova pasta, para que tudo fique organizado
pasta_acordaos <- paste0(pasta, "/acordaos")

# criar a pasata:
dir.create(pasta_acordaos, showWarnings = FALSE)

# rodar a função que baixa
# LEMBRANDO QUE ELA PODE LEVAR TEMPO CONSIDERÁVEL PARA RODAR
tjsp_baixar_acordaos_cposg(
  processos = tabela$processo,
  diretorio = pasta_acordaos)


# Exemplos de gráficos ----------------------------------------------------

# Esses são EXEMPLOS e servem para ilustrar para vocês o potencial do R.
# Caso vejam valor nisso, sugiro seguir o material extra de "R para Ciência de
# Dados" e comecem a explorar os inúmeros recursos que o R tem para visualizações
# Isso é um grande e vasto universo de possibilidades

# Por favor, não se "assustem" com o código abaixo. A ideia foi só demonstrar
# rapidamente o poder do R. Se acharem essa parte interessante, podemos trabalhar
# mais na próxima live ou com material extra

# Gráfico 1 ---------------------------------------------------------------

dispositivo %>%
  filter(!is.na(dispositivo)) %>% # tirar os vazios
  mutate(
    # avaliar qual foi o resultado da decisão
    resultado = tjsp_classificar_writ(dispositivo)
  ) %>%
  # conta os resultados
  count(resultado) %>%
  # cria um gráfico
  ggplot(aes(x = forcats::fct_reorder(resultado, n, .desc = T), y = n)) +
  geom_col() +
  theme_classic() +
  labs(x = "Decisão", y = "Quantidade",
       title = "Aplicação do TJ-SP do HC Coletivo 165.704",
       subtitle = "Decisões proferidas em habeas corpus")


# Gráfico 2 ---------------------------------------------------------------


tabela %>%
  left_join(dispositivo %>%
              mutate(
                data_julgamento = dmy(data_julgamento),
                processo = stringr::str_replace_all(processo, "[^0-9]", "")),
            by = "processo") %>%
  filter(classe == "Habeas Corpus Criminal", !is.na(dispositivo)) %>%
  mutate(
    # avaliar qual foi o resultado da decisão
    resultado = tjsp_classificar_writ(dispositivo),
    orgao_julgador = stringr::str_remove(orgao_julgador, " Câmara de Direito"),
  ) %>%
  group_by(orgao_julgador) %>%
  count(resultado) %>%
  ggplot(aes(x = forcats::fct_reorder(orgao_julgador, n, .desc = T),
             y = n,
             fill = resultado)) +
  geom_col() +
  theme_classic() +
  scale_fill_brewer(palette = "Dark2") +
  labs(x = "Câmara", y = "Quant. decisões",
       title = "Decisões do TJ-SP sobre aplicação do HC Coletivo",
       subtitle = "Distribuição por Câmara de Direito Criminal") +
  theme(axis.text.x = element_text(angle = 90))
