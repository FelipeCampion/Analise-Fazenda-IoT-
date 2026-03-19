-- Cadastrando a Estufa
insert into estufas (nome_estufa) values ('Estufa Alpha - Hidroponia');

-- Cadastrando a Marca
insert into marca_sensor (nome_marca) values ('Tesla IoT');

-- Cadastrando o Técnico
insert into tecnicos (nome_completo, cpf) values ('Felipe Campion', '46290153889');

-- Sensor de Pressão na Estufa 1
insert into sensores (tipo, versao_firmware, id_estufas, id_marca) 
values ('Pressão', 'v1.0.4', 1, 1);

-- TESTE 1: Leitura Normal (12.5) -> Não deve gerar alerta
insert into telemetria (valor_leitura, id_sensor) values (12.50000, 1);

-- TESTE 2: Leitura Crítica (19.8) -> DEVE disparar a Trigger e criar um Alerta Automático
insert into telemetria (valor_leitura, id_sensor) values (19.80000, 1);

-- Verifique se o alerta "brotou" na tabela de alertas:
select * from alertas_iot;

-- Mudando o status de 'Ativo' para 'Manutenção'
update sensores set status = 'Manutenção' where id_sensor = 1;

-- Verifique se o "rastro" foi deixado no histórico:
select * from historico_status_sens;

insert into reg_manutencao (id_sensor, id_tecnico, descricao_problema) 
values (1, 1, 'Troca de válvula de escape após pico de pressão de 19.8');

-- Após o conserto, voltamos o sensor para Ativo
update sensores set status = 'Ativo' where id_sensor = 1;