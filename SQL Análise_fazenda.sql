create database Análise_Fazenda
character set utf8mb4
collate utf8mb4_0900_ai_ci;

use Análise_Fazenda;

create table estufas(
id_estufas int auto_increment primary key,
nome_estufa varchar(50) not null
);

create table marca_sensor (
id_marca int auto_increment primary key,
nome_marca varchar(30) not null
);

create table sensores (
id_sensor int auto_increment primary key,
tipo varchar(50) not null default 'Desconhecido',
versao_firmware varchar(15) not null,
id_estufas int,
id_marca int,
data_instalacao timestamp default current_timestamp not null,
status enum('Ativo', 'Inativo', 'Manutenção', 'Sem sinal') not null default 'Ativo'
);

create table telemetria (
id_leitura bigint auto_increment primary key,
valor_leitura decimal (12,5) not null,
id_sensor int
);

create table alertas_iot (
id_alerta int auto_increment primary key,
id_sensor int not null,
valor_leitura decimal (12,5) null,
mensagem varchar(255) not null,
nvl_grav  enum('Leve', 'Médio', 'Grave', 'Gravíssimo'),
data_alert timestamp default current_timestamp
);

create table tecnicos (
id_tecnico int auto_increment primary key,
nome_completo varchar(100) not null,
cpf varchar (11) not null unique
);

create table reg_manutencao (
id_manutencao int auto_increment primary key,
id_sensor int not null,
id_tecnico int not null,
descricao_problema varchar(255) not null,
id_sensor_substituido int,
data_servico timestamp default current_timestamp
);

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