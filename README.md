# Analise-Fazenda-IoT 🌱📡

![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-brightgreen?style=for-the-badge)

**Plataforma de Monitoramento Preditivo, Gestão de Ativos e Telemetria para o Agronegócio 4.0.**

Este projeto apresenta uma infraestrutura robusta de banco de dados para a gestão de estufas inteligentes. O diferencial estratégico é a **Camada de Decisão Autônoma**, onde o banco de dados não apenas armazena dados, mas monitora a saúde dos ativos (sensores), gerencia estoque de peças e automatiza fluxos de manutenção baseados em regras de negócio dinâmicas.

---

## Diferenciais Técnicos e Arquitetura

* **Engine:** MySQL 8.0+
* **Time-Series Optimization:** Implementação de índices compostos `idx_sensor_data` (id_sensor, data_leitura DESC), otimizando em mais de 90% as consultas de histórico e cálculos de média em grandes volumes de dados.
* **Geolocalização:** Suporte a coordenadas geográficas (Latitude/Longitude) para localização precisa de ativos em grandes propriedades rurais.
* **Desacoplamento de Regras:** Limites operacionais (mínimo/máximo) são armazenados em tabelas de configuração, permitindo ajustes sem a necessidade de alterar o código das Triggers.

---

## Inteligência e Automações Implementadas

### Monitoramento Dinâmico (Triggers)
A trigger `trg_monitorar_limites_dinamicos` atua como um fiscal em tempo real. Ela consulta a tabela de limites específica de cada cultura (ex: Morango vs. Cactos) antes de validar a leitura.
* **Vantagem:** Flexibilidade total para o agrônomo ajustar parâmetros via interface, sem tocar no SQL.

### Diagnóstico de Saúde e "Autocura" (Stored Procedure)
A procedure `sp_diagnostico_saude_sensor` simula um comportamento de análise preditiva:
* **Filtro de Ruído:** Calcula a média móvel apenas das últimas 10 leituras.
* **Análise de Recorrência:** Avalia a gravidade dos alertas ocorridos nas últimas **24 horas**.
* **Bloqueio de Segurança:** Caso detecte falhas críticas repetitivas, o sistema altera o status do sensor para **'Manutenção'** automaticamente, evitando a tomada de decisão baseada em dados corrompidos.

### Gestão de Manutenção e Estoque
Integração entre falhas técnicas e logística. O sistema registra qual técnico realizou o reparo e qual peça do estoque foi utilizada, permitindo o cálculo de **MTTR (Mean Time To Repair)** e controle de custos.

---

## Visualização de Dados (Views)
O projeto conta com a view `vw_status_geral_fazenda`, que entrega em tempo real o **Uptime (disponibilidade)** de cada estufa, transformando dados brutos em indicadores de performance (KPIs) para o gestor.

---

## Como Reproduzir
1.  Execute o script de estrutura (**DDL**) para criar o banco de dados e as automações.
2.  Utilize o script de **DML de Teste** para simular o ciclo completo:
    * Cadastro de infraestrutura.
    * Inserção de telemetrias normais e anômalas.
    * Execução do diagnóstico automático.
    * Registro da manutenção e baixa de estoque.

---
