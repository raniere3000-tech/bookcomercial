# bookcomercial
Resumo anual dos principais KPIs — Águas do Rio.

## Como usar
1. Abra `index.html` e entre em **DRE Comercial, Receita e Arrecadação** (`DRE_Unificado.html`).
2. Clique em **📁 Conectar pasta** e selecione a pasta com os Excel. No Chrome/Edge a pasta fica lembrada; use **↻ Atualizar** para reler após trocar os arquivos. Em outros navegadores o botão abre o seletor de pasta comum.
3. A leitura roda toda no navegador (nada é enviado a servidor). Funciona offline: as bibliotecas ficam em `lib/`.

## Arquivos reconhecidos na pasta
Identificados pelo nome ou, se o nome não ajudar, pelas colunas do cabeçalho. Datas no nome são ignoradas.

| Arquivo | Reconhecido por | Uso |
|---|---|---|
| `Comercial*.xlsx` (um ou vários) | coluna `DSC_CLASSE` | Realizado: faturamento, economias, volumes, cancelamento, por Sup/cidade/curva/situação |
| `Arrec*.xlsx` (um ou vários) | coluna `Arrecadacao_Acumulada` | Arrecadação, clientes e contas por cidade/mês |
| `RF*T*_painel.xlsx` | nome `RFnTyy` ou coluna `Rubrica` | Orçado por superintendência e mês (ex.: `RF3T25`, `RF01T26` → `RF1T26`) |

## Regras de leitura (editáveis em `CONFIG`, no topo do script de `DRE_Unificado.html`)
- A superintendência vem **só da relação SUP FINAL × cidade** (`CONFIG.supCidades`): 12 cidades em LAGOS e 5 em LESTE; a coluna `Sup` do Comercial é ignorada. Cidades fora da relação ficam em `SEM SUP` e são listadas na aba Dados.
- Nos painéis de orçado, `Sup` = `Interior` é exibido como **LAGOS**.
- Mês vem da coluna `Referência`.
- Descartados: linhas com `IsGrandTotalRowTotal` marcado e `DSC_CLASSE = 0`.
- Direta = `CONTAS DE ÁGUA` / `CONTAS DE ESGOTO`; indireta de água = Corte, Religações, Ligações de Água, Sanções, Outros Água (+ Venda e Análise); indireta de esgoto = Ligações de Esgoto, Outros Esgoto.
- Classes financeiras (arrecadação, impostos, juros, multa, acréscimo judicial, financiamentos, taxa de repasse, receita/despesa financeira, atualização monetária, abatimentos, descontos) são ignoradas; cancelamento vem da coluna `R__Cancelamento_total`.
- Tarifa média = faturamento ÷ volume; volume médio = volume ÷ economias. Economias em totais/acumulados = média mensal.
- **Visão Auditoria** (cabeçalho) filtra por `BASEINATIVACAO.SITUACAO_FINAL` (padrão: Ativa Faturando + Cortada).
- Filtros de **cidade** e **curva de cliente** ficam no DRE Histórico.

A aba **Orçado RF** mostra o orçado de todos os meses da referência (inclusive os próximos), com seletor de indicador, cartões-resumo e gráfico de realizado × orçado.

A aba **Dados** mostra o que foi lido, um resumo por mês dos valores identificados em cada arquivo, o que foi descartado, a soma por `DSC_CLASSE` e conferências (ex.: líquido da coluna vs. bruto + cancelamento) para validar a leitura.

## Versões
O número da versão aparece no topo da página, ao lado de "Book Executivo". Ele sobe a cada alteração (`VERSAO_BOOK` no script de `DRE_Unificado.html`) e também aparece nas mensagens de erro e no log.

| Versão | O que mudou |
|---|---|
| v1 | DRE unificado (Comercial + Faturamento) com leitura de Excel por pasta, leitura em blocos para arquivos grandes, superintendência por cidade (LAGOS/LESTE), Visão Auditoria, Orçado RF, resumo por mês na aba Dados, barra de progresso e detalhes da leitura, mês opcional no Comercial. |
| v2 | Cabeçalho enxuto (título "DRE - Comercial"; detalhes da leitura ocultos após carregar, disponíveis na aba Dados). Nova ordem das abas: DRE, Arrecadação (antiga Caixa), Receita, Drivers comerciais, DRE Mensais (antiga DRE mês a mês), DRE Histórico, Orçado RF, Dados. |
| v3 | DRE Histórico passa para depois do Orçado RF. Ordem das abas: DRE, Arrecadação, Receita, Drivers comerciais, DRE Mensais, Orçado RF, DRE Histórico, Dados. |
| v4 | Varredura da pasta: lê todos os arquivos de cada tipo (Comercial, Arrecadação, RF), combina os meses e mostra na aba Dados o que foi encontrado em cada arquivo e uma matriz mês × arquivo. Mês repetido entre arquivos: prevalece o arquivo mais recente (ou soma, à escolha). Arquivo com problema ou sem coluna de mês não derruba os demais; o mês pode ser informado por arquivo. |
