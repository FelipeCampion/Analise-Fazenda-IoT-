use Analise_Fazenda;

-- Cadastros Iniciais (Estufa, Marca e Técnico)
insert into estufas (nome_estufa) values ('Estufa Alpha - Hidroponia');
insert into marca_sensor (nome_marca) values ('Tesla IoT');
insert into tecnicos (nome_completo, cpf) values ('Alex Ribeiro', '01234567891');

-- Cadastro do Sensor de Pressão (ID 1)
insert into sensores (tipo, versao_firmware, id_estufas, id_marca) 
values ('Pressão', 'v1.0.4', 1, 1);

-- Simulação telemetrias para gerar a média recente (AVG)
insert into telemetria (valor_leitura, id_sensor) values 
(12.5), (13.2), (12.8), (14.1), (13.5);

-- Teste gerando 3 Alertas Graves via Trigger
-- Lembrete a trigger esta progamada para disparar a partir de 15.00
insert into telemetria (valor_leitura, id_sensor) values (19.8), (20.5), (18.9);

-- Validando a veracidade da procedure
-- Call do diagnóstico. Houveram 3 alertas graves recentes, 
-- A procedure deve mudar o status para 'Manutenção'
call sp_diagnostico_saude_sensor(1);

-- Confirmação dos resultados obtidos
-- Verificação se o Diagnóstico de IA foi "CRÍTICO"
-- Verificação se o status do sensor mudou para 'Manutenção'
select * from sensores where id_sensor = 1;

-- Verifica se a Trigger de Log gravou a mudança automática no histórico
select * from historico_status_sens;

-- Registro de manutenção fazendo o tecnico entrar em ação
insert into reg_manutencao (id_sensor, id_tecnico, descricao_problema) 
values (1, 1, 'Troca de válvula e recalibração após 3 picos de pressão detectados pela IA');

-- Sensor volta a operar normalmente
update sensores set status = 'Ativo' where id_sensor = 1;
