--CONSULTA BASEADA NO VÍDEO Projeto em SQL - Como analisar vendas de notebooks usando SQL
--LINK: https://www.youtube.com/watch?v=ci3ldv3zd_I&t=623s
--CANAL: DATA MARKETING
-- Databricks notebook source
-- MAGIC %md
-- MAGIC >**Quais fatores afetam os preços dos computadores portáteis?**
-- MAGIC 
-- MAGIC * Vários fatores diferentes podem afetar os preços dos laptops. Esses fatores incluem a marca do computador e o número de opções e complementos incluídos no pacote do computador. Além disso, a quantidade de memória e a velocidade do processador também podem afetar o preço. Embora menos comum, alguns consumidores gastam dinheiro adicional para comprar um computador com base na “aparência” geral e no design do sistema.
-- MAGIC 
-- MAGIC * Em muitos casos, os computadores de marca são mais caros do que as versões genéricas. Esse aumento de preço geralmente tem mais a ver com o reconhecimento do nome do que com qualquer superioridade real do produto. Uma grande diferença entre os sistemas de marca e genéricos é que, na maioria dos casos, os computadores de marca oferecem melhores garantias do que as versões genéricas. Ter a opção de devolver um computador com defeito costuma ser um incentivo suficiente para encorajar muitos consumidores a gastar mais dinheiro.
-- MAGIC 
-- MAGIC * A funcionalidade é um fator importante na determinação dos preços dos laptops. Um computador com mais memória geralmente funciona melhor por mais tempo do que um computador com menos memória. Além disso, o espaço no disco rígido também é crucial, e o tamanho do disco rígido geralmente afeta os preços. Muitos consumidores também podem procurar drivers de vídeo digital e outros tipos de dispositivos de gravação que possam afetar os preços dos laptops.
-- MAGIC 
-- MAGIC * A maioria dos computadores vem com algum software pré-instalado. Na maioria dos casos, quanto mais software for instalado em um computador, mais caro ele será. Isso é especialmente verdadeiro se os programas instalados forem de editores de software bem estabelecidos e reconhecíveis. Aqueles que estão pensando em comprar um novo laptop devem estar cientes de que muitos dos programas pré-instalados podem ser apenas versões de teste e expirarão dentro de um determinado período de tempo. Para manter os programas, será necessário adquirir um código e, em seguida, fazer o download de uma versão permanente do software.
-- MAGIC 
-- MAGIC -Muitos consumidores que estão comprando um novo computador estão comprando um pacote completo. Além do próprio computador, esses sistemas normalmente incluem um monitor, teclado e mouse. Alguns pacotes podem até incluir uma impressora ou câmera digital. O número de extras incluídos em um pacote de computador geralmente afeta os preços dos laptops.
-- MAGIC 
-- MAGIC * Alguns líderes da indústria de fabricação de computadores tornam um ponto de venda oferecer computadores em estilo elegante e em uma variedade de cores. Eles também podem oferecer um design de sistema incomum ou contemporâneo. Embora isso seja menos importante para muitos consumidores, para aqueles que valorizam a “aparência”, esse tipo de sistema pode valer o custo extra.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC >**De onde eu consegui esses dados?**
-- MAGIC 
-- MAGIC * Extraiu esses dados de flipkart.com
-- MAGIC * Usou uma ferramenta automatizada de extensão da Web do Chrome chamada Instant Data Scrapper
-- MAGIC           * Recomendo que você use esta bela ferramenta para obter os dados de qualquer lugar na web. é muito fácil de usar, nenhum conhecimento de codificação é necessário.
-- MAGIC           
-- MAGIC >**O que você pode fazer?**
-- MAGIC 
-- MAGIC * Visualize esses dados e prepare gráficos de alta qualidade o máximo que puder.
-- MAGIC * Construir um modelo para prever o preço
-- MAGIC * Descrição das colunas: consulte a seção de colunas de dados.
-- MAGIC 
-- MAGIC Análise descritiva, prescritiva, diagnóstica e preditiva

-- COMMAND ----------

-- MAGIC %md #Análise Descritiva (SQL)

-- COMMAND ----------

-- MAGIC %md ##Exploração/Desenvolvimento

-- COMMAND ----------


ALTER VIEW vw_vendas_notebooks 
AS
SELECT *,
(preco_atual * 0.063) AS preco_atual_real,
(preco_anterior * 0.063) AS preco_anterior_real,
(disconto/100) AS desconto
FROM vendas_notebooks

-- COMMAND ----------

SELECT * FROM vw_vendas_notebooks

-- COMMAND ----------

-- MAGIC %md Média de preço das marcas

-- COMMAND ----------

SELECT
CASE WHEN marca ='lenovo' THEN 'Lenovo' 
     ELSE marca 
END AS marca_ajustada,
AVG(preco_atual_real) AS media_preco_atual
FROM vw_vendas_notebooks
GROUP BY 
CASE WHEN marca ='lenovo' THEN 'Lenovo' 
     ELSE marca 
END
ORDER BY 2 DESC

-- COMMAND ----------

-- MAGIC %md Participação das memórias (DDR3, DDR4 e DDR5)

-- COMMAND ----------

SELECT
CASE WHEN tipo_memoria='LPDDR3' THEN 'DDR3'
     WHEN tipo_memoria IN ('LPDDR4','LPDDR4X') THEN 'DDR4'
     ELSE tipo_memoria
END AS tipo_de_memoria_ajustado,
SUM(preco_atual_real) AS soma_preco_atual
FROM vw_vendas_notebooks
GROUP BY 
CASE WHEN tipo_memoria='LPDDR3' THEN 'DDR3'
     WHEN tipo_memoria IN ('LPDDR4','LPDDR4X') THEN 'DDR4'
     ELSE tipo_memoria
END
ORDER BY 2 DESC
