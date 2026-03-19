-- Inserindo Autores
insert into autores (nome_autor, nacionalidade) values 
('Machado de Assis', 'Brasileira'),
('J.K. Rowling', 'Britânica'),
('George R.R. Martin', 'Americana');

-- Inserindo Livros (Note a quantidade disponível)
insert into livros (titulo, isbn, ano_publicacao, quant_disponivel) values 
('Dom Casmurro', '9788508042814', 1899, 2),
('Harry Potter e a Pedra Filosofal', '9788532530783', 1997, 1),
('A Guerra dos Tronos', '9788580442625', 1996, 0); -- Este livro nasce sem estoque para testar o erro

-- Relacionando Livros e Autores
insert into livro_autor (id_livro, id_autor) values (1, 1), (2, 2), (3, 3);

-- Inserindo Usuários
insert into usuarios (nome, email) values 
('Carlos Silva', 'carlos@email.com'),
('Ana Oliveira', 'ana.oliver@email.com'),
('Bruno Costa', 'bruno.c@email.com');

-- ERRO (Trigger trg_monitorar_estoque_vazio)
insert into emprestimos (id_livro, id_usuario, data_devolucao_prevista) 
values (3, 1, '2026-04-01');

-- Empréstimo Normal (Dentro do prazo)
insert into emprestimos (id_livro, id_usuario, data_devolucao_prevista) 
values (1, 1, '2026-03-30');

-- Conferindo o estoque (Deve estar 1)
select titulo, quant_disponivel from livros where id_livro = 1;

-- Inserindo um empréstimo que venceu há 2 dias
insert into emprestimos (id_livro, id_usuario, data_emprestimo, data_devolucao_prevista) 
values (2, 2, '2026-03-10', subdate(curdate(), 2));

-- AGORA O TESTE DE FOGO: Deletar para simular a devolução
delete from emprestimos where id_usuario = 2 and id_livro = 2;
delete from emprestimos where id_usuario = 1 and id_livro = 1;

-- Verifique se a multa foi gerada (Deve ter valor de 4.00 para 2 dias)
select * from multas;

-- Verifique se o histórico gravou como 'Atrasado'
select * from historico_emprestimos;

-- Isso deve retornar ERRO (Trigger trg_validar_avaliacao)
-- Pois o usuário 3 nunca pegou o livro 1
insert into avaliacoes (id_livro, id_usuario, nota, comentario) 
values (1, 3, 5, 'Nunca li, mas parece bom!');

-- Isso deve FUNCIONAR
-- Pois o usuário 1 já devolveu o livro 1 (no teste anterior)
insert into avaliacoes (id_livro, id_usuario, nota, comentario) 
values (1, 1, 5, 'Um clássico indispensável!');
