create database formativahogwarts;
use formativahogwarts;

CREATE TABLE emprestimos (
  id BIGINT NOT NULL AUTO_INCREMENT,
  id_usuario INT,
  id_funcionario INT,
  data_emprestimo DATETIME,
  data_prevista_devolucao DATETIME,
  data_devolucao DATETIME,
  PRIMARY KEY(id),
  FOREIGN KEY (id) REFERENCES usuarios(id),
  FOREIGN KEY (id) REFERENCES usuarios(ocupacaoFK)
);
CREATE TABLE livros (
  id INT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(255),
  ano_publicacao INT,
  edicao VARCHAR(50),
  id_editora INT,
  PRIMARY KEY(id),
  FOREIGN KEY (id_editora) REFERENCES editoras(id_editora)
);


CREATE TABLE editoras (
  id_editora INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(255),
  unidadeFederativa VARCHAR(50),
  PRIMARY KEY(id_editora)
);


CREATE TABLE autores (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(255),
  PRIMARY KEY(id)
);


CREATE TABLE livros_autores (
  id INT NOT NULL AUTO_INCREMENT,
  id_livro INT,
  id_autor INT,
  PRIMARY KEY(id),
  FOREIGN KEY (id_livro) REFERENCES livros(id),
  FOREIGN KEY (id_autor) REFERENCES autores(id)
);
drop table livros_autores;

INSERT INTO editoras (nome, unidadeFederativa)
VALUES ('Estrela Azul', 'Terra Nova'),
       ('Lua Crescente', 'Montanha Branca'),
       ('Sol Dourado', 'Ilha Esmeralda');

INSERT INTO autores (nome)
VALUES ('Gabriel Monteiro'),
       ('Jack Shan'),
       ('Luisa Mel');

INSERT INTO livros (titulo, ano_publicacao, edicao, id_editora)
VALUES ('O Segredo Dos Animais', 2020, '1ª Edição', 1),
       ('Os Sem Floresta', 2018, '2ª Edição', 2),
       ('A Era Do Gelo', 2019, '1ª Edição', 1);

INSERT INTO livros_autores (id_livro, id_autor)
VALUES (1, 1),
       (1, 2),
       (3, 1),
       (2, 2);

INSERT INTO emprestimos (id_usuario, id_funcionario, data_emprestimo, data_prevista_devolucao, data_devolucao)
VALUES (1, 1, '2023-06-10 10:00:00', '2023-06-17 10:00:00', '2023-06-15 10:00:00'),
       (2, 1, '2023-07-11 14:00:00', '2023-06-18 12:00:00', '2023-07-17 14:00:00');
       
-- esqueci de inserir um livro não devolvido 
INSERT INTO emprestimos (id_usuario, id_funcionario, data_emprestimo, data_prevista_devolucao, data_devolucao)
VALUES (1, 1, '2023-06-10 10:00:00', '2023-08-12 15:00:00', null);

-- 1)       
SELECT livros.titulo, editoras.nome AS editora, GROUP_CONCAT(autores.nome SEPARATOR ', ') AS autores
FROM livros
INNER JOIN editoras ON livros.id_editora = editoras.id_editora
INNER JOIN livros_autores ON livros.id = livros_autores.id_livro
INNER JOIN autores ON livros_autores.id_autor = autores.id
WHERE livros.id = 1
GROUP BY livros.titulo, editoras.nome;

-- 2)
SELECT livros.titulo, editoras.nome AS editora, subquery.autores
FROM livros
INNER JOIN editoras ON livros.id_editora = editoras.id_editora
LEFT JOIN (
  SELECT livros_autores.id_livro, GROUP_CONCAT(autores.nome SEPARATOR ', ') AS autores
  FROM livros_autores
  INNER JOIN autores ON livros_autores.id_autor = autores.id
  GROUP BY livros_autores.id_livro
) AS subquery ON livros.id = subquery.id_livro;

-- 3)
SELECT * FROM emprestimos
WHERE id_usuario IN (
 SELECT id_usuario
 FROM emprestimos
 WHERE data_devolucao > data_prevista_devolucao
);

-- 4)
SELECT autores.nome AS autor, COUNT(livros_autores.id_livro) AS quantidade_livros
FROM autores
JOIN livros_autores ON autores.id = livros_autores.id_autor
GROUP BY autores.id, autores.nome;

-- 5)
SELECT usuarios.nome AS usuario, COUNT(emprestimos.id) AS quantidade_livros_emprestados
FROM usuarios
LEFT JOIN emprestimos ON usuarios.id = emprestimos.id_usuario
WHERE emprestimos.data_devolucao IS NULL
GROUP BY usuarios.id, usuarios.nome;












