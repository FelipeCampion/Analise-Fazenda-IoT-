# Analise-Fazenda-IoT 🚜🌱📡

![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen?style=for-the-badge)

**Sistema de Monitoramento Preditivo e Telemetria para Agronegócio com Automação de Manutenção.**

Este projeto apresenta uma infraestrutura de banco de dados para gestão de sensores em estufas inteligentes. O diferencial aqui é a **camada de inteligência de hardware**, onde o banco de dados monitora a saúde dos sensores e toma decisões automáticas de manutenção baseadas em telemetria.

## Arquitetura e Tecnologia
* **Engine:** MySQL 8.0+
* **Conceitos Aplicados:** IoT Data Logging, Trilha de Auditoria (Audit Trail), Subqueries em Procedures e Agendamento de Manutenção.
* **Foco:** Estufas automatizadas e monitoramento de pressão/umidade.

## Inteligência e Automações Implementadas

### Telemetria e Alertas Automáticos (Triggers)
* **Monitoramento Crítico:** Através da trigger `monitorar_pressao_alta`, o sistema avalia cada inserção de dado. Valores acima do limite (ex: 15.0) geram alertas instantâneos na tabela `alertas_iot`.
* **Log de Status:** A trigger `trg_log_stts_sensor` garante a rastreabilidade total, gravando cada mudança de status (Ativo -> Manutenção) com timestamp e valores antigo/novo.

### Diagnóstico de Saúde via IA (Stored Procedure)
A grande estrela do projeto é a procedure `sp_diagnostico_saude_sensor`. Ela simula um comportamento de inteligência artificial:
* **Análise de Contexto:** Calcula a média (`AVG`) apenas das últimas 10 leituras para evitar falsos positivos.
* **Filtro Temporal:** Analisa a gravidade dos alertas ocorridos estritamente nas últimas 24 horas (`INTERVAL 1 DAY`).
* **Autocura:** Caso detecte mais de 3 alertas graves, a procedure altera o status do sensor para **'Manutenção'** automaticamente, bloqueando o uso de dados não confiáveis até que um técnico resolva o problema.

### Gestão de Manutenção
* Registro detalhado de intervenções técnicas, vinculando o problema detectado pela telemetria ao serviço realizado pelo especialista.

## Como Reproduzir os Testes
1. Execute o script de estrutura (**DDL**) para criar as estufas, sensores e regras.
2. Utilize o script de **DML de Teste** fornecido para simular os picos de pressão.
3. Valide a automação executando:
   ```sql
   CALL sp_diagnostico_saude_sensor(1);
