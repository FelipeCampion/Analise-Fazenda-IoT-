create database Analise_Fazenda
character set utf8mb4
collate utf8mb4_0900_ai_ci;

use Analise_Fazenda;

-- Criando as tabelas e suas respectivas colunas

-- Criação das estufas
create table estufas(
id_estufas int auto_increment primary key,
nome_estufa varchar(50) not null
);

-- Criação da identificação de marcas
create table marca_sensor (
id_marca int auto_increment primary key,
nome_marca varchar(30) not null
);

-- Criação da tabela de sensores (Cérebro do sistema)
create table sensores (
id_sensor int auto_increment primary key,
tipo varchar(50) not null default 'Desconhecido',
versao_firmware varchar(15) not null,
id_estufas int,
id_marca int,
data_instalacao timestamp default current_timestamp not null,
status enum('Ativo', 'Inativo', 'Manutenção', 'Sem sinal') not null default 'Ativo'
);

-- Criação da tabela de registro de telemetrias
create table telemetria (
id_leitura bigint auto_increment primary key,
valor_leitura decimal (12,5) not null,
id_sensor int
);

-- Criação dos registros de possíveis alerts no sistema
create table alertas_iot (
id_alerta int auto_increment primary key,
id_sensor int not null,
valor_leitura decimal (12,5) null,
mensagem varchar(255) not null,
nvl_grav  enum('Leve', 'Médio', 'Grave', 'Gravíssimo'),
data_alert timestamp default current_timestamp
);

-- Criação dos tecnicos desta fazenda
create table tecnicos (
id_tecnico int auto_increment primary key,
nome_completo varchar(100) not null,
cpf varchar (11) not null unique
);


-- Criação do registro de manutenção dos sensores
create table reg_manutencao (
id_manutencao int auto_increment primary key,
id_sensor int not null,
id_tecnico int not null,
descricao_problema varchar(255) not null,
id_sensor_substituido int,
data_servico timestamp default current_timestamp
);

-- Criação do histórico de status de cada sensor para melhor organização
create table historico_status_sens(
id_historico bigint auto_increment primary key,
id_sensor int not null,
status_anterior varchar(20) not null,
status_novo varchar(20) not null,
data_mudanca timestamp default current_timestamp
);

-- PONTES --

alter table sensores
add constraint fk_sens_est foreign key (id_estufas) references estufas (id_estufas) on delete cascade,
add constraint fk_sens_marc foreign key (id_marca) references marca_sensor (id_marca);

alter table reg_manutencao
add constraint fk_manu_sens foreign key (id_sensor) references sensores (id_sensor),
add constraint fk_manu_tec foreign key (id_tecnico) references tecnicos (id_tecnico),
add constraint fk_manu_sens_sub foreign key (id_sensor_substituido) references sensores (id_sensor);

alter table telemetria
add constraint fk_tel_sens foreign key (id_sensor) references sensores (id_sensor),
add constraint chk_leitura_positiva check (valor_leitura >= 0);

alter table alertas_iot
add constraint fk_alert_sens foreign key (id_sensor) references sensores (id_sensor);

alter table historico_status_sens
add constraint fk_hist_sens foreign key (id_sensor) references sensores (id_sensor);

-- Criação dos gatilhos de automação

-- Monitoramento de leitura de pressão e alert automático
delimiter //

create trigger monitorar_pressao_alta
after insert on telemetria
for each row

begin
    if new.valor_leitura > 15.00 then
        insert into alertas_iot (id_sensor, mensagem, valor_leitura, nvl_grav)
        values (new.id_sensor, 'Alerta automático: Pressão a cima do limite!!', new.valor_leitura, 'Grave');
    end if;
end//

delimiter ;

-- Registro de status antigos de sensores e armazenamento de historico
delimiter //

create trigger trg_log_stts_sensor
after update on sensores
for each row 

begin
    if old.status <> new.status then
    insert into historico_status_sens (id_sensor, status_anterior, status_novo)
    values (old.id_sensor, old.status, new.status);
end if;
end//

delimiter ;

delimiter //

create procedure sp_diagnostico_saude_sensor(
in p_id_sensor int
)

begin 
declare v_media_leitura decimal(12,5);
declare v_total_alertas_graves int;
declare v_status_atual varchar(20);
declare v_diagnostico varchar(255);

select avg(valor_leitura) into v_media_leitura
from(
select valor_leitura from telemetria
where id_sensor = p_id_sensor
order by id_leitura desc limit 10
) as ultimas_leituras;

select count(*) into v_total_alertas_graves
from alertas_iot
    where id_sensor = p_id_sensor
    and nvl_grav in ('Grave', 'Gravíssimo')
    and data_alert >= now() - interval 1 day;

if v_total_alertas_graves >=3 then
set v_diagnostico = 'CRÍTICO: Sensor encaminhado para manutenção automática.';
update sensores set status = 'Manutenção' where id_sensor = p_id_sensor;

elseif v_total_alertas_graves between 1 and 2 then
    set v_diagnostico = 'ATENÇÃO: Sensor apresentando instabilidade!!';
else
    set v_diagnostico = 'ESTÁVEL: Sensor operando de forma estável!!';
end if;

select p_id_sensor as 'ID do sensor',
    ifnull(v_media_leitura, 0) as 'Média recente',
    v_total_alertas_graves as 'Alertas graves (24h)',
    v_diagnostico as 'Diagnóstico de IA';

end //
    
delimiter ; 

