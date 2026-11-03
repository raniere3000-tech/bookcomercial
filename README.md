# bookcomercial
Resumo anual dos principais KPIs — Águas do Rio.

## Como usar
1. Abra `index.html` e entre em **DRE Comercial, Receita e Arrecadação** (`DRE_Unificado.html`).
2. Clique em **📁 Conectar pasta** e selecione a pasta com os Excel. No Chrome/Edge a pasta fica lembrada; use **↻ Atualizar** para reler após trocar os arquivos. Em outros navegadores o botão abre o seletor de pasta comum.
3. A leitura roda toda no navegador (nada é enviado a servidor). Funciona offline: as bibliotecas ficam em `lib/`.

## Arquivos reconhecidos na pasta
Todos os `.xlsx` da pasta (e de subpastas) são validados **aba por aba** e identificados pelo **cabeçalho da tabela** (procurado nas primeiras 30 linhas, então títulos acima da tabela não atrapalham). Cada aba reconhecida entra como uma fonte (ex.: `Arquivo.xlsx › LAGOS`). O nome do arquivo só é usado se o cabeçalho não for reconhecido. Datas no nome são ignoradas.

Vários arquivos do mesmo tipo são **combinados por cidade e mês**: arquivos com cidades diferentes (ex.: um da LESTE e outro do INTERIOR) sempre se somam. Se a mesma cidade aparecer no mesmo mês em mais de um arquivo, vale o arquivo mais recente (ou a soma, conforme a opção na aba Dados › Varredura) — as cidades repetidas são listadas no log. No orçado (RF), arquivos do mesmo RF são juntados por superintendência.

| Arquivo | Reconhecido por | Uso |
|---|---|---|
| Comercial (um ou vários) | coluna `DSC_CLASSE` | Realizado: faturamento, economias, volumes, cancelamento, por Sup/cidade/curva/situação |
| Arrecadação (um ou vários) | coluna `Arrecadacao_Acumulada` | Arrecadação, clientes e contas por cidade/mês |
| Orçado `RF*T*_painel.xlsx` (um ou vários) | coluna `Rubrica` ou colunas de mês; RF pelo nome `RFnTyy` | Orçado por superintendência e mês (ex.: `RF3T25`, `RF01T26` → `RF1T26`) |

## Regras de leitura (editáveis em `CONFIG`, no topo do script de `DRE_Unificado.html`)
- A superintendência vem **só da relação SUP FINAL × cidade** (`CONFIG.supCidades`): 11 cidades em LAGOS (Interior, incluindo Rio Bonito) e 9 em LESTE; a coluna `Sup` do Comercial é ignorada. Cidades fora da relação ficam em `SEM SUP` e são listadas na aba Dados.
- Nos painéis de orçado, `Sup` = `Interior` é exibido como **LAGOS**.
- Mês vem da coluna `Referência`.
- Descartados: linhas com `IsGrandTotalRowTotal` marcado e `DSC_CLASSE = 0`.
- Faturamento direto e indireto = **soma das colunas** `Faturamento_bruto_*` em todas as classes, igual a uma tabela dinâmica do Excel. A `DSC_CLASSE` só define a abertura: indireta de água = Corte, Religações, Ligações de Água, Sanções, Outros Água, Venda e Análise, Consertos e Reparos; indireta de esgoto = Ligações de Esgoto, Outros Esgoto; qualquer outra classe com valor aparece como "Outras classes". Economias e volumes vêm das classes `CONTAS DE ÁGUA` / `CONTAS DE ESGOTO`.
- Aba Dados › **Conferência com a tabela dinâmica**: soma de uma coluna por DSC_CLASSE no mês, por arquivo e no painel, para comparar com o Excel.
- Classes financeiras (arrecadação, impostos, juros, multa, acréscimo judicial, financiamentos, taxa de repasse, receita/despesa financeira, atualização monetária, abatimentos, descontos) são ignoradas; cancelamento vem da coluna `R__Cancelamento_total`. Na aba **DRE Histórico** o cancelamento é aberto pela `DSC_CLASSE` da linha: Contas de Água/Esgoto → direto de água/esgoto; classes indiretas → indireto de água/esgoto; classes com "Resíduo"/"Reúso" → resíduos/reúso; demais → outros.
- Tarifa média = faturamento ÷ volume; volume médio = volume ÷ economias. Economias em totais/acumulados = média mensal.
- **Visão Auditoria** (cabeçalho) filtra por `BASEINATIVACAO.SITUACAO_FINAL` (padrão: Ativa Faturando + Cortada).
- Filtros de **cidade** e **curva de cliente** ficam no DRE Histórico.

A aba **Orçado RF** mostra o orçado de todos os meses da referência (inclusive os próximos), com seletor de indicador, cartões-resumo e gráfico de realizado × orçado.

A aba **Dados** mostra o que foi lido, um resumo por mês dos valores identificados em cada arquivo, o que foi descartado, a soma por `DSC_CLASSE` e conferências (ex.: líquido da coluna vs. bruto + cancelamento) para validar a leitura.

## Versões
A versão aparece no topo da página, ao lado do título "DRE - Comercial" (ex.: **V1**). Ela sobe a cada alteração publicada no `main` (`VERSAO_BOOK` no script de `DRE_Unificado.html`: V1, V2, V3…) e também aparece no título da aba do navegador, nas mensagens de erro e no log.

| Versão | O que mudou |
|---|---|
| V4 | Indiretas (e diretas) passam a ser a soma das colunas em todas as classes, como a tabela dinâmica do Excel — inclui Consertos e Reparos (antes ignorado) e “Outras classes”. Nova Conferência com a tabela dinâmica na aba Dados. Aviso no DRE Histórico quando cidades repetidas entre arquivos estão sendo somadas. Rio Bonito só em LAGOS (Interior). |
| V3 | Lê todas as abas de cada Excel (antes só a primeira) e subpastas mais fundas. Aba Dados › Varredura ganha o quadro “cidades por arquivo e mês”, mostrando as cidades de cada arquivo por superintendência e quais foram substituídas por arquivo mais recente; o log lista as cidades de cada arquivo. |
| V2 | Todos os Excel validados pelo cabeçalho (mesmo com títulos acima da tabela). Arquivos combinados por cidade: o arquivo da LESTE não apaga mais os dados do INTERIOR no mesmo mês; vale também para Arrecadação e para o orçado (por superintendência). |
| V1 | Numeração reiniciada. Estado atual: DRE Histórico na estrutura "Econômico" recolhível (Faturamento de Água/Esgoto, Cancelamentos abertos, Faturamento Líquido, Arrecadação com aberturas), tabela compacta com tamanho ajustável, botão Baixar PDF e superintendências LESTE/LAGOS atualizadas. |

Histórico anterior à renumeração:

| Versão | O que mudou |
|---|---|
| v1 | DRE unificado (Comercial + Faturamento) com leitura de Excel por pasta, leitura em blocos para arquivos grandes, superintendência por cidade (LAGOS/LESTE), Visão Auditoria, Orçado RF, resumo por mês na aba Dados, barra de progresso e detalhes da leitura, mês opcional no Comercial. |
| v2 | Cabeçalho enxuto (título "DRE - Comercial"; detalhes da leitura ocultos após carregar, disponíveis na aba Dados). Nova ordem das abas: DRE, Arrecadação (antiga Caixa), Receita, Drivers comerciais, DRE Mensais (antiga DRE mês a mês), DRE Histórico, Orçado RF, Dados. |
| v3 | DRE Histórico passa para depois do Orçado RF. Ordem das abas: DRE, Arrecadação, Receita, Drivers comerciais, DRE Mensais, Orçado RF, DRE Histórico, Dados. |
| v4 | Varredura da pasta: lê todos os arquivos de cada tipo (Comercial, Arrecadação, RF), combina os meses e mostra na aba Dados o que foi encontrado em cada arquivo e uma matriz mês × arquivo. Mês repetido entre arquivos: prevalece o arquivo mais recente (ou soma, à escolha). Arquivo com problema ou sem coluna de mês não derruba os demais; o mês pode ser informado por arquivo. |
| v5 | Página inicial (`index.html`) com plano de fundo `Gemini_Generated_Image_.jpeg`, ajustado para a logo ficar sempre visível no canto superior esquerdo (computador, tablet e celular); botão renomeado para "DRE - Comercial". |
