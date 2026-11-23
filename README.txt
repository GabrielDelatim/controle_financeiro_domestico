FINANCAS DA CASA — VERSAO PWA CORRIGIDA

ARQUIVOS
- index.html: aplicacao
- manifest.webmanifest: configuracao de instalacao PWA
- sw.js: cache offline e service worker
- icons/: icones do aplicativo

PUBLICACAO NO GITHUB PAGES
1. Extraia o conteudo deste ZIP.
2. Envie index.html, manifest.webmanifest, sw.js e a pasta icons para a pasta publicada pelo GitHub Pages (normalmente a raiz do repositorio).
3. Publique em HTTPS e abra novamente o endereco da aplicacao.
4. No celular, use o botao Instalar quando aparecer. No iPhone/iPad, use Compartilhar > Adicionar a Tela de Inicio.

RECURSOS
- Lançamentos por semana, mês ou intervalo personalizado.
- Gerenciamento de categorias: adicionar e excluir; os lançamentos antigos são preservados.
- Recorrência mensal para entradas e despesas, com quantidade de meses ou prazo indeterminado.
- Meses futuros identificados como estimativas e lançamentos previstos.
- Backup e restauração em JSON.
- Layout adaptado para celular, navegação inferior e utilização offline após o primeiro carregamento.


DADOS E ATUALIZACAO
A aplicação continua usando a chave localStorage "fin-items" para os lançamentos e "fin-categories" para categorias. Ao atualizar no MESMO dominio/origem, os registros locais existentes devem continuar disponiveis. Faça um backup antes de publicar a atualização.
Os dados ficam no navegador/dispositivo; PWA e modo offline não significam sincronização em nuvem. Limpar os dados do site, trocar de navegador/dispositivo ou desinstalar pode remover os dados locais.

IMPORTANTE
Para instalação PWA, publique em HTTPS (GitHub Pages fornece HTTPS). Não abra somente o arquivo HTML localmente: service worker e instalação PWA não funcionam em file://.
