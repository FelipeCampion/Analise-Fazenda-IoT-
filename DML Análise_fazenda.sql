use Analise_Fazenda;

-- Cadastros inicias
-- Registrando a localização física (Estufa)
insert into estufas (nome_estufa) values ('Estufa Alpha - Hidroponia');

-- Cadastrando o fabricante do dispositivo
insert into marca_sensor (nome_marca) values ('Tesla IoT');

-- Cadastrando o técnico responsável pela manutenção
insert into tecnicos (nome_completo, cpf) values ('Alex Ribeiro', '01234567891');

-- Abastecendo o inventário com peças para reparos futuros
insert into estoque_pecas (nome_peca, quantidade_atual, preco_unitario) 
values ('Válvula de Pressão v4', 15, 89.90);

-- Instalação e configuração de sensores
-- Instalando o sensor com coordenadas geográficas (Latitude e Longitude)
insert into sensores (tipo, versao_firmware, id_estufas, id_marca, latitude, longitude) 
values ('Pressão', 'v1.0.4', 1, 1, -23.123456, -46.654321);

-- Definindo os limites operacionais dinâmicos para este sensor específico
-- O sistema irá monitorar se a leitura permanece entre 5.00 e 15.00
insert into limites_sensor (id_sensor, valor_minimo, valor_maximo) 
values (1, 5.00, 15.00);

-- Simulação e teste da operação de leitura
-- Inserindo leituras dentro da normalidade para compor a média recente (AVG)
insert into telemetria (valor_leitura, id_sensor) values 
(12.5), (13.2), (12.8), (14.1), (13.5);

-- Inserindo leituras anômalas para disparar a Trigger de Alerta
-- Como o limite máximo configurado é 15.00, estes valores gerarão alertas automáticos
insert into telemetria (valor_leitura, id_sensor) values (19.8), (20.5), (18.9);

-- Diagnóstico e automação clínica do dispositivo
-- Executando a Procedure de diagnóstico. 
-- O sistema deve detectar os 3 alertas graves e alterar o status para 'Manutenção'.
call sp_diagnostico_saude_sensor(1);

-- Audutoria e verificação de resultados
-- Verificando se o status do sensor foi alterado automaticamente pela Procedure
select id_sensor, tipo, status from sensores where id_sensor = 1;

-- Consultando a trilha de auditoría para confirmar o registro da mudança de status
select * from historico_status_sens;

-- Visualizando o Painel de Disponibilidade (Uptime) da Fazenda através da View
select * from vw_status_geral_fazenda;

-- Fluxo de encerramento e manutenção
-- Registro da ordem de serviço vinculando o técnico e a peça utilizada do estoque
insert into reg_manutencao (id_sensor, id_tecnico, id_peca_utilizada, descricao_problema) 
values (1, 1, 1, 'Troca de válvula e recalibração após detecção de picos de pressão pela IA.');

-- Atualizando o inventário (Removendo a peça utilizada)
update estoque_pecas set quantidade_atual = quantidade_atual - 1 where id_peca = 1;

-- Restaurando o sensor para operação normal
update sensores set status = 'Ativo' where id_sensor = 1;
