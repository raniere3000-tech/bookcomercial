# Instruções do projeto

Responda sempre em português do Brasil.

## Uso de skills

As skills ficam em `.claude/skills/`. Quando a tarefa se encaixar em uma delas, invoque a skill antes de começar, sem esperar o pedido explícito. Se mais de uma servir, use a mais específica.

### Interface, site e design
- Criar ou redesenhar página, landing page ou portfólio: `design-taste-frontend` (pasta `taste-skill`) para a direção e `superdesign` para explorar direções novas, só se houver conta no superdesign.dev.
- Implementar a partir de um design ou imagem de referência: `image-to-code`.
- Acabamento de UI (tipografia, sombras, raios, animações, áreas de clique): `make-interfaces-feel-better`. Use o modo `quick` em telas já prontas e o `full` em telas novas.
- Ícones: `better-icons`. Use uma coleção só no projeto e não use emoji no lugar de ícone.
- Revisar acessibilidade, UX ou conformidade da interface: `web-design-guidelines`.
- Testar ou automatizar o navegador: `playwright-cli`.
- Gráficos, painéis e dashboards: `dataviz`.

### Texto
- Escrever qualquer texto (página, post, e-mail, legenda, README): `anti-ai-slop-writing`.
- Checar se um texto parece escrito por IA, sem reescrever: `no-ai-slop` no modo de detecção.
- Reescrever só os trechos apontados, na voz do autor: `humanizer`. Peça uma amostra de texto do autor antes.
- Fluxo completo de texto: escrever com `anti-ai-slop-writing`, detectar com `no-ai-slop` e reescrever com `humanizer`, mostrando o resultado de cada etapa.

### Código e processo
- Qualquer criação, nova funcionalidade ou mudança de comportamento: `brainstorming` antes de codar.
- Plano com várias etapas: `writing-plans`, depois `executing-plans` ou `subagent-driven-development`.
- Implementar funcionalidade ou corrigir bug: `test-driven-development` ou `tdd`.
- Bug, falha de teste ou comportamento inesperado: `systematic-debugging` antes de propor correção. Para bug difícil ou lentidão, `diagnosing-bugs`.
- Antes de dizer que algo está pronto, corrigido ou passando: `verification-before-completion`. Rode os comandos e confira a saída antes de afirmar.
- Revisar mudanças: `code-review`. Pedir revisão: `requesting-code-review`. Receber revisão: `receiving-code-review`.
- Terminar uma branch: `finishing-a-development-branch`. Trabalho isolado: `using-git-worktrees`.
- Escrever código: siga `karpathy-guidelines` (mudanças pequenas e cirúrgicas, assumir pouco, critérios de sucesso verificáveis).
- Descrição de pull request: `pr`.
- Pesquisar um tema em fontes confiáveis: `research`.
- Criar ou editar skills, `CLAUDE.md` ou `AGENTS.md`: `writing-skills` e `writing-for-agents`.

## Escrita sem cara de IA (português do Brasil)

Vale para todo texto escrito neste projeto: página, post, e-mail, legenda, mensagem de commit e descrição de PR.

Nunca use:
- Contraste montado: não é X, é Y; não é só X, é Y; mais do que X, é Y
- Aberturas de aquecimento: no cenário atual, nos dias de hoje, vamos falar sobre, a verdade é que, já parou pra pensar
- Falsa revelação: o que ninguém te conta, o segredo que poucos sabem, a parte que todo mundo ignora
- Fechamento de efeito: é isso, pense nisso, o futuro já chegou, simples assim
- Palavras infladas: crucial, fundamental, revolucionário, divisor de águas, jornada, potencializar, alavancar, robusto, mergulhar fundo
- Autoridade vaga: estudos mostram, especialistas dizem, muitos acreditam
- Travessão como conector: use vírgula, dois pontos ou ponto

Sempre:
- Comece pela informação, não pela introdução
- Varie o tamanho das frases e só faça lista de três quando forem três coisas de verdade
- Use número, nome e data só se vierem do usuário ou de uma fonte citada. Se faltar, escreva [DADO] e pergunte
- Antes de entregar, releia procurando os itens acima e corrija

## Regras de interface

- Títulos com `text-wrap: balance`
- Raio de borda concentrico: raio de fora = raio de dentro + espaçamento
- Sombra para elevação, borda só para estrutura
- Números que mudam ou se alinham (preço, contador) com `tabular-nums`
- Área de clique de pelo menos 40x40 px no desktop e 44x44 px no celular
- Todos os ícones da mesma coleção, sem emoji fazendo papel de ícone
- Nada de `transition: all`; resposta de hover em até 150 ms
- Sem clichês de site de IA: degradê roxo e azul, blob, brilho neon
- Texto específico do negócio, nenhuma frase que serviria para qualquer empresa
- Uma cor de destaque só, usada com intenção
