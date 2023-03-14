###########################################################################
### JURIMETRIA, LEGAL HACKING E INTELIGÊNCIA ARTIFICIAL
### Extração de Dados: Como Obter o Melhor dos Dados
### Prof. José de Jesus Filho (referência)
### Prof. Rodrigo Dornelles (Hertie School)

### Live de Estudo de Caso - 14/03/2023


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

# Referências -------------------------------------------------------------

# Instalando R: <https://livro.curso-r.com/1-1-instalacao-do-r.html>
# Instalando RStudio: <https://livro.curso-r.com/1-2-instalacao-do-rstudio.html>
# Pacote tidyverse: <https://operdata.com.br/blog/tidyverse-os-pacotes-mais-usados-no-r/>


# O que é? ----------------------------------------------------------------

# Protótipo simples de uma pesquisa usando ferramentas de jurimetria para que
# possamos realizar análises de dados sobre processos e decisões judiciais.
# Basicamente, a ideia é coletar dados de processos e transformá-los em formatos
# que propiciem análises, inclusive estatísticas, que possam ser úteis para nós.


# Primeiro passo: definir o objeto ----------------------------------------

# É fundamental termos claro o escopo e objetivo da pesquisa. Com isso, devemos
# fazer uma análise de viabilidade a fim de verificar se o dado é possível de
# ser extraído e analisado.

# Se o volume for muito pequeno, corremos o risco de ser pouco relevante ou
# representativo. Se o volume for excessivo, teremos dificuldades para baixar,
# armazenar e processar.

# Devemos também entender muito bem o problema para estabelecer as melhores
# estratégias de extração. Apesar disso, nada impede de fazermos diversos testes
# e análises mais exploratórias a fim de entender o quão "redondo" está nossa
# metodologia.

# É importante definir:
# -   quais os Tribunais que iremos raspar (abrangência territorial)
# -   qual o espaço de tempo (a partir do ano de 2016, por exemplo)
# -   qual instância iremos olhar (apenas 2º? primeiro também?)
# -   quais as classes processuais
# -   quais os termos de pesquisa
# -   etc...

# Aplicação do HC coletivo 165.704 ----------------------------------------

# Para demonstrar como funciona, vamos tomar como exemplo uma pesquisa simples
# sobre a aplicação do HC coletivo 165.704 (sobre mães e pais custodiados
# para verificar como o TJ-SP vem aplicando a decisão.
# Mais infos: https://portal.stf.jus.br/processos/detalhe.asp?incidente=5596542

# Vamos ter em mente o ciclo descrito acima e tentar aplicar para essa situação
# concreta.

# | Tribunal:         | TJ-SP
# | Espaço de tempo:  | Considerando que o HC é recente, de 2018, o foco será a
#                     | partir dele.
# | Instância         | Apenas 2º grau
# | Classe processual | Habeas corpus apenas
# | Termo de pesquisa | Quero todas as decisões que mencionem o HC 165.704

# Tendo isso em mente, vou até a busca de jurisprudência de segundo grau do
# fazer testes de termos de pesquisa que me interesssem.
# É super importante também olhar as orientações do Tribunal sobre o mecanismos
# de pesquisa                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              > Operador **E** : permite consultar os documentos que contenham todas as palavras informadas. Exemplo: furto E assalto E carro.
# TJ-SP: https://esaj.tjsp.jus.br/cjsg/consultaCompleta.do
# Mecanismo de pesquisa: https://esaj.tjsp.jus.br/WebHelp//#id_operadores_logicos.htm


# Transcrição: operadores de busca TJSP -----------------------------------

# > Quando nenhum operador é indicado, o E é utilizado por padrão.

# > Operador OU: consulta os documentos que contenham todas as palavras
#informadas ou apenas uma delas. Exemplo: bicicleta OU carro OU motocicleta.

# > Operador NÃO: a consulta é feita excluindo determinada palavra da busca.
#Por exemplo, se eu digitar NÃO assassinato, o sistema busca textos que não
# contenham a palavra assassinato.

# > Operador ?: permite consulta de palavras no documento que contenham um
#caractere qualquer, substituindo uma letra.
# Exemplo: ca?a para casa, cada, cara.
# Lembre-se que o operador ? não pode ser utilizado no início dos termos de
# pesquisa. Qualquer outra combinação é válida.

# > Operador " ": pesquisa por frases exatas.
# Por exemplo, a pesquisa "área de preservação permanente" somente trará
# ocorrências que contenham essa frase exatamente como ela foi digitada.
# Para resultados precisos, a frase pesquisada deve conter no máximo cinco
# palavras.

# > Além dos operadores apresentados, você também pode utilizar o parêntese para
# pesquisas mais complexas.
# Por exemplo, ao pesquisar "plano de saúde" E angioplastia OU ecocardiograma,
# não está explícito qual operação será desenvolvida primeiro, contudo, se você
# utilizar a seguinte ordem "plano de saúde" E (angioplastia OU ecocardiograma),
# entre parênteses, o resultado da pesquisa exibirá todas as ocorrências que
# contenham a frase "plano de saúde" e a palavra "angioplastia", juntamente com
# todas as ocorrências que contenham a frase "plano de saúde" e a palavra
# "ecocardiograma".



# Prosseguindo... ---------------------------------------------------------


# Tendo tudo isso em mente, o raciocínio foi:

# 1.  Preciso que as expressões "HC" e "165.704" estejam presentes:
# pesquisando por `HC 165704` aparecem apenas 93 decisões, que pode ser pouco.

# 2.  Vou tentar então apenas o número: "`165704`". Aparecem 98 decisões.

# 3.  O problema pode ser que ao se referir a ela, algumas mencionem o "." (ponto)
# e outras não. Eu poderia então usar o operador OU (`165704 OU 165.704`):
# já sobe para 390, bem melhor.

# 4.  Eu também poderia acrescentar a expressão que remeta a "habeas corpus"
# Por exemplo, "HC" ou usar "habeas corpus" por extenso.
# Ou, ainda, usando os operadores de busca, tentar algo como "`hc OU "habeas corpus"`
# Fazendo o teste com`(165704 OU 165.704) E (hc OU "habeas corpus")`
# tenho 384 decisões.

# Nesse caso, vou optar por fazer a pesquisa com a expressão `165704 OU 165.704`
# do item 3, que pareceu mais adequada.

# Bom lembrar que a pesquisa do TJ-SP é bastante poderosa e permite vários outros
# parâmetros. Em casos em que eu tenha muita decisões mas potencialmente poucas
# úteis, vale a pena explorar aqueles filtros.
# O importante é sempre anotar os parâmetros usados para poder passar eles para
# o mecanismo de raspagem.


# Raspando os dados: pacote tjsp do R -------------------------------------

# após instalar:
library(tidyverse) # nosso "canivete suíço" para análise de dados
library(tjsp) # carrega o pacote propriamente dito

#  O primeiro passo, então, é requisitar ao pacote que baixe os dados que
# queremos.
# Vamos então salvar a expressão de busca em uma variável de texto e chamar a
# função que realiza a pesquisa propriamente dita.

# Usaremos a função `tjsp_baixar_cjsg()`
# (sabendo que "cjsg" significa "Consulta Julgados de Segundo Grau")

# Preenchendo:
# o parâmetro: `livre`com nosso termo de pesquisa e
# o parâmetro `diretorio` com a pasta que vamos usar.

# O pacote tem uma série de outros parâmetros que podem ser usados na pesquisa
# como classe, assunto, orgao_julgador, data de início, data de fim, etc.
# Recomendo a leitura da documentação usando o comando `?tjsp_baixar_cjsg()`


# Baixando os dados -------------------------------------------------------

# Vamos criar objetos com os valores que colocaremos na função que irá baixar
# Isso não é obrigatório, mas ajuda a deixar nosso código mais legível e
# versátil


# Expressão de busca que definimos no item 3

exp <- '165704 OU 165.704'

# Escolher uma pasta para receber os resultados

pasta <- "data-raw/exemplo_hc_coletivo"

###############################################################################
# Vou criar essa pasta no meu computador para salvar os resultados:
dir.create("data-raw", showWarnings = FALSE) # cria pasta padrão para dados crus
dir.create(pasta, showWarnings = FALSE)

# Realizar a pesquisa

# Aqui é onde colocamos os parâmetros de pesquisa que definimos anteriormente
# se não quisermos colocar nada, podemos deixar em branco (remover), deixar
# como está ou mesmo comentar a linha para que ela seja "ignorada"
tjsp_baixar_cjsg(livre = exp,
                 classe = "",
                 assunto = "",
                 orgao_julgador = "",
                 inicio = "",
                 fim = "",
                 inicio_pb = "",
                 fim_pb = "",
                 tipo = "A",
                 n = 1, # na "vida real" deixaremos NULL ou omitiremos essa linha
                 diretorio = pasta)

# A depender do tamanho da pesquisa, ela pode levar alguns minutos (ou mesmo
# muitas horas).

# Com isso, eu já tenho condições preliminares de colocar em uma mesma tabela
# todas as informações básicas da pesquisa. Vou poder saber quantidade, assunto
# de cada uma delas, qual foi a data de julgamento, relator(a), ementa, etc.

# A função para essa leitura preliminar é `tjsp_ler_cjsg()` na qual eu vou colocar
# como parâmetro a pasta que utilizei para salvar a busca.

# Posso criar uma tabela com isso e até mesmo exportar para excel ou outros
# formatos:

# ler a tabela
tabela <- tjsp_ler_cjsg(diretorio = pasta)

# olhar os resultados
tabela

# Podem acontecer alguns erros de leitura, mas em geral não vai ser um problema.

# Exportação para Excel ---------------------------------------------------

# Nossas(os) colegas, sócios(as), chefes, clientes, etc muitas vezes não terão
# qualquer domínio do R. Por isso, pode ser útil exportar nossa base ou nossas
# análises para outro formato. Isso é MUITO fácil de fazer no R e podemos
# fazê-lo a qualquer momento (tanto agora, com dados "crus", quanto mais
# próximos de concluir nossa análise)

# Exemplo de exportação para o formato excel:

library(writexl) # lembrar de carregar os pacotes que vamos usar!
write_xlsx(tabela, path = "data-raw/tabela_basica_jurisprudencia.xlsx")

# Salvar em RDS:
# O R possui um formato nativo de arquivo, chamado .rds. Pode ser conveniente
# salvar bases intermediárias ou mesmo finais nesse formato para economizar
# tempo de trabalho e dispensar baixar novamente os dados dos Tribunais.
# Isso pode ser feito:

write_rds(tabela, file = "data-raw/base_original.rds")

# E, para carregar:
#tabela <- read_rds("data-raw/base_original.rds")

# Lembrando que, para poder usar na memória devemos salvar em um objeto:
# base <- read_rds("data/base_original.rds")

# Algumas análises simples ------------------------------------------------

# Aqui vamos apenas ILUSTRAR algumas análises simples.
# Quantas decisões temos?

nrow(tabela)

# Quais as comarcas com mais decisões?

tabela %>%
  group_by(comarca) %>% # agrupar por comarcas
  count(sort = TRUE) %>% # contar ocorrências
  head()  # ver os primeiros resultados


# Além dessas análises simples, essa tabela inicial é importante para permitir
# que sejam baixados os andamentos, as partes, resultado do julgamento e o texto
# do acórdão em si.

### Baixando o restante dos dados

# Embora o que se possa obter até aqui já seja provavelmente suficiente para uma
# análise preliminar de viabilidade do tema, normalmente vamos querer extrair
# mais informações do Tribunal.

# No caso do TJ-SP, para as etapas a seguir é fundamental que possua um login
# no sistema e-saj e que utilize aqui uma função de autenticação.
# Não sei informar se é preciso possuir login de advogado(a) ou se qualquer um
# basta. Essas políticas são do próprio Tribunal.
# Em todo caso, recomendo se habilitar no sistema:
# <https://esaj.tjsp.jus.br/sajcas/login?service=https%3A%2F%2Fesaj.tjsp.jus.br%2Fesaj%2Fj_spring_cas_security_check#>

# Feito o cadastro, para poder acessar os dados o pacote possui uma função que
# realiza para nós a autenticação: # asssim, ela irá abrir uma janela pedindo login e senha
autenticar()

# posso também colocar diretamente esses dados nos parâmetros da função
# contudo....
# MUITO cuidado se isso for se tornar público uma vez que o login é o
# próprio CPF e a senha tampouco queremos que seja usada por terceiros:

# autenticar(login = <seu login>, password = <sua senha>)

# Feita a autenticação, podemos prosseguir baixando mais dados:

### Baixar detalhes:

# Para isso vamos usar a função `tjsp_baixar_cposg()` colocando como parâmetros
# a coluna da tabela onde estão os números do processo e a pasta onde queremos
# que tudo seja salvo.

# crio uma nova pasta dentro da pasta anterior
# definir o nome:
pasta_detalhes <- paste0(pasta, "/detalhes")

# criar a pasta:
dir.create(pasta_detalhes, showWarnings = FALSE)

# baixar os detalhes em si
tjsp_baixar_cposg(processos = tabela$processo, diretorio = pasta_detalhes)

# Ler os arquivos baixados ------------------------------------------------

# Agora que baixamos os dados podemos usar outas funções do pacote para extrair
# mais informações de nosso interesse. Lembrando que a etapa de baixar não
# precisa ser repetida no futuro, uma vez que os arquivos estarão salvos no seu
# disco.

# Apenas iremos repetir a etapa de baixar do Tribunal caso queiramos dados mais
# atualizados ou novas decisões não abrangidas pela busca inicial.
# Nesse caso, pode ser uma boa usar na nova busca os parâmetros que permitem
# definir as datas de início e fim, para abranger apenas as decisões que já não
# foram baixadas.

### Ler as partes e andamentos

# Pra isso vamos criar duas variáveis que vão receber o resultado das funções
# que buscam, respectivamente, as partes e os andamentos. O parâmetro usado nas
# duas é o mesmo: o diretorio, que será a a pasta que criamos e salvamos como
# pasta_detalhes.

# ler as partes
partes <- tjsp_ler_partes(diretorio = pasta_detalhes)

# ver o resultado
partes

# ler os andamentos
andamentos <- ler_movimentacao_cposg(diretorio = pasta_detalhes)

# ver o resultado
andamentos


### Ler dispositivo da decisão

# Embora tenhamos baixado o inteiro teor dos acórdãos, é razoavelmente complexo
# manusear esses arquivos. Temos uma vantagem no TJ-SP que é o fato de a tira de
# julgamento, isto é, o resultado do que foi decidido pelo Tribunal fica num
# campo explicitamente separado.

# Isso permite saber o resultado dos julgamentos sem necessariamente ter que ler
# os arquivos .pdf.

# ler o dispositivo das decisões
dispositivo <- tjsp_ler_decisoes_cposg(diretorio = pasta_detalhes)

# ver o resultado
dispositivo

### Baixar os acórdãos:

# ATENÇÃO: você provavelmente NÃO precisa baixar os acórdãos nesse momento.
# É um nível de análise mais complexo e trabalhoso, leva tempo e pode ser
# frustrante no começo: a conexão pode cair, os arquivos são um pouco chatos
# de manusear, etc. Mas não poderíamos deixar de mostrar isso pra vocês:

# O pacote também permite baixar o inteiro teor dos acórdãos (em .pdf) para
# depois poder analisar o texto com o R.
# Isso pode levar minutos, horas ou mesmo dias caso o volume seja grande.

# A função é `tjsp_baixar_acordaos_cposg()`e vamos usar os mesmos parâmetros da
# anterior

# dou um nome para uma nova pasta, para que tudo fique organizado
pasta_acordaos <- paste0(pasta, "/acordaos")

# criar a pasata:
dir.create(pasta_acordaos, showWarnings = FALSE)

# rodar a função que baixa
tjsp_baixar_acordaos_cposg(
  processos = tabela$processo,
  diretorio = pasta_acordaos)


# Alguns exemplos de análises ---------------------------------------------

# Temos então baixados os dados de todas as decisões que atenderam ao nosso
# termo de pesquisa definido acima.

# Agora, podemos fazer análises mais aprofundadas. Sugere-se começar com
# perguntas mais amplas e, depois, ir aprofundando nos cruzamentos.
# Também, com apoio de metodologias de pesquisa e de estatísticas é possível
# aplicar técnicas mais robustas de análise, inclusive machine learning,
# análise de linguagem natural e outras ferramentas. O céu é o limite!

# Naturalmente, antes de obter dados confiáveis, é preciso conhecer bem os dados
# e verificar inconsistências, realizar filtragens e adaptações.

# Alguns exemplos de perguntas que podem ser interessantes:

# 1.  Quantas decisões concedem o HC e quantas negam?
# 2.  Quais as câmaras que mais negam? E quais mais deferem?
# 3.  Distribuição das ações ao longo do tempo. Há algum padrão? Há alguma
# sazonalidade? Há algum pico?
# 4.  Quanto tempo essas decisões tramitam?
# 5.  Há liminar? Em quais? A liminar tende a ser confirmada?
# 6.  A audiência pública ocorrida em 14/06/21 mudou as decisões que vieram
# depois?
# 7.  É possível agrupar comarcas em razão do peril das decisões proferidas?
# 8.  etc

# Claro que nem sempre todas as perguntas poderão ser respondidas com os dados
# que possuímos. Como nosso objetivo aqui é meramente exemplificar, vamos apenas
# demonstrar um gráfico simples mostrando como foram julgadas as causas.


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
  left_join(dispositivo) %>%
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

### FIM?
