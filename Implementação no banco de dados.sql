use aula;
set SQL_SAFE_UPDATES = 0;

-- Tabelas que são usadas nos exemplos
create table estado (
    id int,
    nome varchar(50),
    sigla char(02),
    primary key(id)
);

create table cidade (
    id int,
    nome varchar(100),
    estadoId int,
    primary key(id)
);

create table cliente (
    id int auto_increment,
    nome varchar(100),
    genero char(01),
    nascimento date,
    salario decimal(10,2),
    email varchar(120) unique, 
    cidadeId int not null,
    constraint pkCliente primary key (id),
    constraint fkClienteCidade foreign key (cidadeId) references cidade(id)
    on delete no action on update no action
);

create table funcionario (
    matricula int not null,
    nome varchar(100),
    genero char(01),
    nascimento date,
    salario decimal(10,2),
    departamento int,
    cargo int,
    gerente int,
    email varchar(120),
    cidadeId int,
    constraint pkFuncionario primary key (matricula)
);

create table pergunta (
    id int,
    pergunta varchar(100),
    primary key(id)
);

insert into estado values (1, 'Paraná', 'PR');
insert into estado values (2, 'São Paulo', 'SP');
insert into estado values (3, 'Pernambuco', 'PE');
insert into estado values (4, 'Pará', 'PA');
insert into estado values (5, 'Rio Grande do Sul', 'RS');

insert into cidade values (1, 'Bagé', 5);
insert into cidade values (2, 'Curitiba', 1);
insert into cidade values (3, 'Recife', 3);
insert into cidade values (4, 'São Paulo', null);
insert into cidade values (5, 'Porto Alegre', null);
insert into cidade values (6, 'Olinda', 3);

insert into pergunta values (1, 'Qual a sua função?');
insert into pergunta values (2, 'Avalie a sua gerência.');

insert into cliente values (1, 'Helena Magalhães', 'F', '2000-01-01', 12500.99, 'helena@email.com', 2),
                           (2, 'Nicolas', 'M', '2002-12-10', 8500, 'nicolas@email.com', 3),
                           (3, 'Ana Rosa Silva', 'F', '1996-12-31', 8500, 'ana.rosa@email.com', 1),
                           (4, 'Tales Heitor Souza', 'M', '2000-10-01', 7689, 'tales.heitor@email.com', 1),
                           (5, 'Bia Meireles', 'F', '2002-03-14', 9450, 'bia.meireles@email.com', 2),
                           (6, 'Pedro Filho', 'M', '1998-05-22', 6800, 'pedro.filho@email.com', 5),
                           (7, 'Helena Magalhães', 'F', '1994-08-10', 8600, 'helena.magalhaes@email.com', 4);

insert into funcionario values (1, 'Ana Rosa', 'F', '1996-12-31', 8500, 1, 1, null,'ana.rosa@email.com', 1),
                               (2, 'Tales Heitor', 'M', '2000-10-01', 7689, 1, 2, 1, 'tales.heitor@email.com', null),
                               (3, 'Bia Meireles', 'F', '2002-03-14', 9450, 1, 2, 1, 'bia.meireles@email.com', 2),
                               (4, 'Pedro Filho', 'M', '1998-05-22', 6800, 3, 3, 2, 'pedro.filho@email.com', 4),
                               (5, 'Helena Magalhães', 'F', '2000-01-01', 12500.99, 4, 5, 2, 'helena@email.com', 6),
                               (6, 'Nicolas Pinto', 'M', '2002-12-10', 8500, 6, 3, null, 'nicolas.pinto@email.com', 5);

update funcionario
    set cidadeId = (select id from cidade where nome = 'Imperatriz')
    where matricula = 2;

delete from cliente where id = 5;

delete from cliente where nome = 'Helena Magalhães';

delete from funcionario where departamento = 1 and genero = 'M';

delete from cidade where id = 6;
    
delete from cliente where cidadeId in 
    (select id from cidade where nome = 'Curitiba');

delete from cliente;

truncate table cliente;

-- Filtro
select * from cliente where genero = 'F';

-- And / or
select * from funcionario where salario >= 5000 and salario <= 8000;

-- Null / not null
select * from cidade where uf is not null;

-- Like
select * from cliente where nome like '%Silva%';

-- In
select * from cliente where cidadeId in (1, 2, 4);
select * from funcionario where cidadeId = 1 or cidadeId = 2 or cidadeId = 4;

-- Between
select * from funcionario where cidadeId between 1 and 4;
-- ou 
select * from funcionario where cidadeId >= 1 and cidadeId <= 4;
select * from funcionario order by nome desc, salario asc; 
select * from funcionario order by 3 asc;

-- Limit
select * from funcionario LIMIT 3;
select * from funcionario LIMIT 3, 2;

-- Comando case
select nome,
    case
        when genero = 'M' then 'Masculino'
        when genero = 'F' then 'Feminino'
        else 'Outros'
    end as 'Gênero'
from funcionario;

select nome, nascimento from cliente
union 
select nome, nascimento from funcionario;

select nome, nascimento, 'cliente' from cliente
union all
select nome, nascimento, 'funcionario' from funcionario
order by 1;

-- Distinct
select nome from cliente order by nome;
select distinct nome from cliente order by nome;

-- Distinct com mais colunas
select nome, email from cliente order by nome;
select distinct nome, email from cliente order by nome;

-- Inner join - equi-non
select nome, nome, sigla from cidade 
    inner join estado
    on cidade.estadoId = estado.id;

-- Usando where
select nome, nome, sigla from cidade, estado
    where cidade.estadoId = estado.id;

-- Left join inclusive
select nome, nome, sigla from cidade 
    left join estado
    on cidade.estadoId = estado.id;

-- Left join exclusive
select nome, nome, sigla from cidade 
    left join estado
    on cidade.estadoId = estado.id
    where estado.id is null;

-- Right join inclusive
select nome, nome, sigla from cidade 
    right join estado
    on cidade.estadoId = estado.id;

-- Right join exclusive
select nome, nome, sigla from cidade 
    right join estado
    on cidade.estadoId = estado.id
    where cidade.estadoId is null;

-- Full join (o MySQL não suporta o full join)
select nome, nome, sigla from cidade 
    full join estado
    on cidade.estadoId = estado.id;

-- Gerando o full join
select nome, nome, sigla from cidade 
    left join estado
    on cidade.estadoId = estado.id
    union
    select nome, nome, sigla from cidade 
        right join estado
        on cidade.estadoId = estado.id
    where cidade.estadoId is null;

-- Cross join
select nome, pergunta from pergunta
    cross join funcionario;

-- Self join com inner join
select funcionario.nome, gerente.nome as 'gerente' from funcionario 
    inner join funcionario as gerente
    on funcionario.gerente = gerente.matricula
    order by funcionario.nome;

-- Self join com left join
select funcionario.nome, gerente.nome from funcionario 
    left join funcionario as gerente
    on funcionario.gerente = gerente.matricula
    order by funcionario.nome;

-- Join com várias tabelas
select nome, nome, nome from funcionario
    inner join cidade 
    on funcionario.cidadeId = cidade.id
    inner join estado
    on cidade.estadoId = estado.id
    order by nome;

select nome, nome, sigla from cidade 
    full join estado
    on cidade.estadoId = estado.id
    where cidade.estadoId is null
    or estado.id is null;

select nome, salario, salario * 1.10 from funcionario;

select nome as 'Nome do funcionário', 
    salario as 'Salário atual',
    salario * 1.10 as 'Novo salário'
    from funcionario;

select nome as 'Nome do funcionário', nome as 'Nome da cidade' from funcionario f
    inner join cidade c
    on f.cidadeId = c.id;
    select * from cliente

SELECT * FROM cliente 
WHERE nome = 'Ana Rosa Silva' OR genero = 'Ana Rosa Silva' OR email = 'Ana Rosa Silva' OR cidade = 'Ana Rosa Silva';

