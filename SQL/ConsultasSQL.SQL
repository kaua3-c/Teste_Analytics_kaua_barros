--A importacao do dataframe ao sql foi feita de maneira manual, atraves do seguinte modo: BD.ProvaQUOD --> Tarefas 
-- --> importar dados --> Selecionar formato FFS (Flat File Source) --> next --> Microsoft OLE DB provider for sql server --> next
--conferindo se o dataframe foi importado corretamente.
use ProvaQuod
select * from data_clean;


--Criacao de uma tabela para receber os dados do dataframe
--drop table T_Vendas
create table T_Vendas(
ID int,
Data date,
Produto varchar(100),
Categoria varchar(100),
Quantidade int,
Preco float
);

select * from T_Vendas

--inserção dos itens do dataframe na tabela vendas, coluna preco total não será incluida, pois foi pedido para realizar o calculo novamente

insert into T_Vendas (ID, Data, Produto, Categoria, Quantidade, Preco)
select
ID,
Data,
Produto,
Categoria,
FLOOR(Quantidade),
Preco
from data_clean;

select * from T_Vendas

-- selecionando produto, categoria e o preço total das vendas, organizado na ordem decrescente
select 
Produto,
Categoria,
sum(Quantidade * Preco) as Faturamento
from T_Vendas
group by Produto, Categoria
order by  Faturamento desc;

--analisando qual categoria que possui mais faturamento ao longo dos 12 meses
select 
Categoria,
sum(Quantidade * Preco) as Faturamento
from T_Vendas
group by  Categoria
order by  Faturamento desc;

--selecionando os produtos menos vendidos no mes de junho, classificados em ordem crescente
select 
Produto, 
sum(Quantidade * Preco) as Faturamento
from T_Vendas
where 
    Data >= '2023-06-01' AND Data <= '2023-06-30'
group by 
    Produto
order by 
    Faturamento asc;

--selecionando os itens para Conferir se valores coincidem com os produtos vendidos em junho
select Produto, preco, quantidade, Data from T_Vendas where
  Data >= '2023-06-01' AND Data <= '2023-06-30'
