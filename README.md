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
- A superintendência vem **só da relação SUP FINAL × cidade** (`CONFIG.supCidades`): 12 cidades em LAGOS (Interior, incluindo Rio Bonito e Cachoeiras de Macacu) e 8 em LESTE; a coluna `Sup` do Comercial é ignorada. Cidades fora da relação ficam em `SEM SUP` e são listadas na aba Dados.
- Nos painéis de orçado, `Sup` = `Interior` é exibido como **LAGOS**.
- Mês vem da coluna `Referência`.
- Descartados: linhas com `IsGrandTotalRowTotal` marcado e `DSC_CLASSE = 0`.
- Faturamento direto = coluna `Faturamento_bruto_direta_*` só nas classes `CONTAS DE ÁGUA` / `CONTAS DE ESGOTO` (valores dessa coluna em outras classes ficam de fora e são listados na aba Dados). Faturamento indireto = **soma da coluna** `Faturamento_bruto_indireta_*` em todas as classes, igual a uma tabela dinâmica do Excel. A `DSC_CLASSE` define a abertura: indireta de água = Corte, Religações, Ligações de Água, Sanções, Outros Água, Venda e Análise, Consertos e Reparos; indireta de esgoto = Ligações de Esgoto, Outros Esgoto; qualquer outra classe com valor aparece como "Outras classes". Economias e volumes vêm das classes `CONTAS DE ÁGUA` / `CONTAS DE ESGOTO`.
- Aba Dados › **Conferência com a tabela dinâmica**: soma de uma coluna por DSC_CLASSE no mês, por arquivo e no painel, para comparar com o Excel.
- Classes financeiras (arrecadação, impostos, juros, multa, acréscimo judicial, financiamentos, taxa de repasse, receita/despesa financeira, atualização monetária, abatimentos, descontos) são ignoradas; cancelamento vem da coluna `R__Cancelamento_total`. Na aba **DRE Histórico** o cancelamento é aberto pela `DSC_CLASSE` da linha: Contas de Água/Esgoto → direto de água/esgoto; classes indiretas → indireto de água/esgoto; classes com "Resíduo"/"Reúso" → resíduos/reúso; demais → outros.
- Tarifa média = faturamento ÷ volume; volume médio = volume ÷ economias. Economias em totais/acumulados = média mensal.
- **Visão Auditoria** (cabeçalho) filtra por `BASEINATIVACAO.SITUACAO_FINAL` (padrão: Ativa Faturando + Cortada).
- Filtros de **cidade** e **curva de cliente** ficam no DRE Histórico.

A aba **Orçado RF** mostra o orçado de todos os meses da referência (inclusive os próximos), com seletor de indicador, cartões-resumo e gráfico de realizado × orçado.

A aba **Dados** mostra o que foi lido, um resumo por mês dos valores identificados em cada arquivo, o que foi descartado, a soma por `DSC_CLASSE` e conferências (ex.: líquido da coluna vs. bruto + cancelamento) para validar a leitura.

## Versões
A versão aparece no topo da página, ao lado do título "DRE - Comercial" (ex.: **V1**). Ela sobe a cada alteração publicada no `main` (`VERSAO_BOOK` no script de `DRE_Unificado.html`: V1, V2, V3…) e também aparece no título da aba do navegador, nas mensagens de erro e no log.

O SAC segue a mesma regra: a versão (v5, v6…) fica no selo do cabeçalho de `SAC.html` (`VERSAO_SAC`) e sobe a cada alteração publicada. O visual segue o padrão dos painéis (cabeçalho marinho, abas, cartões brancos, faixa de KPIs). A Central de Links (`index.html`) mostra a sua no rodapé.

## SAC (`SAC.html`)
Conecta a pasta com os Excel, como o DRE, e identifica cada arquivo pelo cabeçalho: implantações de ligações, faturamento e arrecadação. A tela de validação mostra o tipo reconhecido, as linhas lidas e as colunas que faltam. A análise cruza as matrículas implantadas com o faturamento (DSC_CLASSE Ligações de Água, faturamento indireto de água) e com a arrecadação, e lista as que pagaram mas não estão como Ativa Faturando ou Cortada a partir do mês do pagamento. As regras ficam em `CONFIG` no script.

| Versão | O que mudou |
|---|---|
| V25 | Arquivos de Arrecadação com aba de explicação (ex.: "Informações" do Tabela_BI): a aba só é lida como Arrecadação quando o cabeçalho tem Cidade, Mes/ano e Arrecadacao_Acumulada. Antes, a aba "Informações" era lida e dava erro de colunas ausentes. |
| V24 | DRE Histórico: a arrecadação passa a somar todas as cidades da superintendência que estão no arquivo de Arrecadação, inclusive as que não aparecem no Comercial. Antes, com o filtro LESTE, a arrecadação ficava vazia quando o Comercial não trazia cidades da LESTE. O filtro de cidades também lista essas cidades, e o botão da superintendência aparece mesmo quando ela só existe na Arrecadação. |
| V23 | Ícone de DRE na aba do navegador (painel e página inicial): `icone-dre.svg`, com `icone-dre-32.png` e `icone-dre-180.png` para navegadores sem SVG e atalho no celular. Cores da paleta Águas do Rio (degradê `#102840` → `#174f70`, barra `#16a5b8`). |
| V22 | Realizado antes do Orçado em todos os quadros: aba DRE (tela e PDF), DRE Mensais, Arrecadação, tabela do Orçado RF e Quadro para apresentação (imagem e tabela). Opção e nome de arquivo passam a “Só Realizado e Orçado” / `_Realizado_Orcado`. |
| V21 | PDF com cada visão inteira em uma página (a letra diminui até caber; A4 deitado, ou A3 quando não couber). Padrão: um arquivo só com a Visão Normal na página 1 e a Visão Auditoria na página 2 (`..._Visao_Normal_e_Auditoria.pdf`); continua dando para gerar dois arquivos ou uma visão só. No topo de cada página, “Visão Auditoria: Sim (situações)” sai destacado em amarelo. |
| V20 | Baixar PDF gera dois arquivos, Visão Normal e Visão Auditoria (padrão “As duas versões”; dá para escolher só uma). Nomes: `DRE_<Sup>_<AAAA-MM>[_Acum_RF_<RF>][_Orcado_Realizado]_Visao_Normal.pdf` / `_Visao_Auditoria.pdf` e `DRE_Historico_<Sup>_<início>_a_<fim>_Visao_...pdf`; o PNG do quadro segue o mesmo padrão. |
| V19 | DRE Histórico: Tarifa Média de Esgoto passa para dentro de Faturamento Direto de Esgoto; tarifas médias com 2 casas decimais (antes até 4). |
| V18 | Aba DRE, acumulado “Período do RF”: soma só os meses com valor no RF até o mês selecionado (mês vigente); meses futuros do RF ficam de fora e são informados. |
| V17 | Quadro para apresentação: diferença do volume médio e da tarifa média com duas casas decimais (ex.: 0,35; -0,66). |
| V16 | Aba Dados: “Quadro para apresentação” no formato DRE / Orçado / mês / Dif / %, em duas versões (Visão Auditoria Não e Sim), com botões Copiar imagem, Copiar tabela (Excel/PowerPoint) e Baixar PNG. |
| V15 | Aba DRE: opção “Período do RF” para o acumulado. O painel confere no RF selecionado quais meses têm valor preenchido (para a superintendência) e soma orçado e realizado só desses meses; mostra os meses usados, os sem valor no RF e os sem realizado. Vale também para o PDF. |
| V14 | Janela do PDF pergunta a versão (Completo ou Só Orçado e Realizado, na aba DRE) e se o PDF deve usar a Visão Auditoria (DRE e DRE Histórico). O PDF informa no topo e no nome do arquivo quando usa a auditoria. |
| V13 | Aba DRE: opção “Só Orçado e Realizado” (esconde Absoluto e Relativo), que vale também para o PDF e fica lembrada no navegador. |
| V12 | Aba DRE: Faturamento Bruto passa a ser o grupo principal, com (+) Faturamento de Água e (+) Faturamento de Esgoto e todas as aberturas dentro, e o valor é a soma delas. Volume Médio por Economia de Esgoto e Tarifa Média de Esgoto vão para dentro de Faturamento Direto de Esgoto. |
| V11 | Orçado (RF): rubricas CORTE, RELIGAÇÃO, LNA e SANÇÃO passam a alimentar o orçado das aberturas de Faturamento Indireto de Água na aba DRE (Corte de Água, Religações, Ligações de Água, Sanções). Marcadores como “▸” antes do nome da rubrica são ignorados. |
| V10 | Aba DRE: corrige as aberturas de indireta e de cancelamento, que apareciam vazias (só Corte de Água aparecia) por erro na soma do realizado do mês. |
| V9 | Aba DRE (mês e acumulado) no mesmo modelo do DRE Histórico: (+) Faturamento de Água e de Esgoto com direto e indireto, (-) Cancelamentos abertos, (=) Faturamento Líquido, Arrecadação e Outros indicadores (Faturamento Bruto, volume médio e tarifa de esgoto, Cut-Off), em árvore recolhível. Botão Baixar PDF com escolha de tópicos também na aba DRE. |
| V8 | Baixar PDF abre a lista de tópicos do DRE Histórico para escolher o que sai no PDF (marcar tudo, desmarcar, igual à tela ou só os totais); grupos marcam e desmarcam o que está dentro. |
| V7 | Cachoeiras de Macacu passa da LESTE para LAGOS (Interior). |
| V6 | Faturamento Direto volta a ser só CONTAS DE ÁGUA / CONTAS DE ESGOTO (na V4 passou a somar a coluna direta de todas as classes e ficava acima do Excel). A aba Dados lista as classes com valor na coluna direta fora de CONTAS. |
| V5 | O painel confere ao abrir se há versão mais nova publicada e recarrega sozinho (evita ficar preso numa cópia antiga do navegador, como a lista antiga da LESTE com Rio Bonito). O link da página inicial sempre abre a versão atual. |
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
