# Analise-Fazenda-IoT-
Banco de Dados MySQL para monitoramento de estufas inteligentes com foco em IoT e telemetria. Inclui triggers automatizadas para alertas de pressão crítica, auditoria de status de sensores (log de eventos), integridade referencial com chaves estrangeiras e controle de manutenção técnica para alta rastreabilidade operacional. 🚜🌾⚡

*ANÁLISE-FAZENDA-IoT*

Repositório contendo a arquitetura de banco de dados relacional para monitoramento de estufas agrícolas. O projeto foca em automação de processos via triggers e integridade referencial para dispositivos de telemetria.

Especificações Técnicas
Engine: MySQL 8.0

Objetos: Tabelas, Constraints (FK, CHECK), Triggers de Auditoria e Monitoramento.

Modelagem: Estrutura normalizada para suporte a leituras de sensores e registros de manutenção técnica.

Funcionalidades Implementadas
Monitoramento de Telemetria: Gatilho configurado para gerar alertas automáticos em tabelas de incidentes quando a leitura de pressão excede o limite de 15.0 (Podendo ser totalmente moldado para fins expecificos).

Log de Auditoria: Trigger de atualização que registra transições de status de sensores, utilizando comparação entre os estados OLD e NEW para garantir a veracidade do histórico.

Gestão Operacional: Estrutura para controle de ordens de serviço e substituição de componentes vinculados a técnicos especializados.

Instruções de Uso:

- Certifique-se de que o ambiente MySQL esteja configurado com suporte a Delimitadores (//).
- Execute o script principal para criação do Schema e das tabelas.
- Os scripts de inserção para validação das chaves estrangeiras e das triggers estão incluídos no corpo do arquivo SQL.
