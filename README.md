# Finanças da Casa — GitHub Pages + Supabase

Aplicação web estática, instalável como PWA, com autenticação por e-mail/senha e armazenamento em nuvem usando Supabase.

## Estrutura do projeto

```text
/
├── index.html
├── manifest.webmanifest
├── sw.js
├── supabase-config.js
├── icons/
│   ├── icon-192.png
│   └── icon-512.png
└── supabase/
    └── setup.sql
```

## 1. Criar e preparar o Supabase

1. Crie um projeto no [Supabase](https://supabase.com/).
2. Abra **SQL Editor → New query**.
3. Cole e execute todo o conteúdo de `supabase/setup.sql`.
4. Em **Project Settings → API** (ou **API Keys**, conforme a interface), copie a **Project URL** e a chave pública **publishable** ou **anon**.
5. Em **Authentication → Providers**, confirme que o provedor **Email** está habilitado. A confirmação de e-mail pode permanecer ativa; nesse caso, o usuário precisa confirmar o endereço antes do primeiro login.

A tabela `public.user_finances` guarda uma linha por usuário. As políticas de Row Level Security (RLS) restringem leitura e escrita ao `auth.uid()` da própria sessão.

## 2. Configurar a aplicação

Abra `supabase-config.js` e substitua os dois valores de exemplo:

```js
window.SUPABASE_CONFIG = {
  url: "https://SEU-PROJETO.supabase.co",
  anonKey: "SUA_CHAVE_PUBLICA_PUBLISHABLE_OU_ANON"
};
```

Use somente a Project URL e a chave **publishable/anon**. A chave pública pode estar no frontend quando a tabela está protegida por RLS. **Nunca use a chave `service_role` ou uma secret key neste arquivo, no HTML ou no GitHub.**

## 3. Configurar autenticação e GitHub Pages

1. No Supabase, abra **Authentication → URL Configuration**.
2. Configure **Site URL** com o endereço publicado, por exemplo `https://SEU-USUARIO.github.io/SEU-REPOSITORIO/`.
3. Inclua esse mesmo endereço na lista de **Redirect URLs**. Se usar domínio próprio, adicione também o endereço HTTPS do domínio.
4. No GitHub, envie todos os arquivos e pastas deste pacote para a raiz (ou para a pasta que será publicada).
5. Abra **Settings → Pages** no repositório e escolha a branch e a pasta corretas (normalmente `main` e `/(root)`).
6. Aguarde a publicação do GitHub Pages e abra a URL HTTPS.

O Supabase deve ter a tabela `public.user_finances` disponível pela Data API. Se o projeto limitar os schemas expostos, exponha `public` ou autorize explicitamente essa tabela nas configurações da Data API.

## 4. Primeiro acesso e importação dos dados locais

- Se a aplicação já tinha lançamentos em `localStorage` neste mesmo navegador, no primeiro login será oferecida a importação ou mesclagem dos dados locais, conforme a conta já tenha ou não uma linha na nuvem.
- A migração só acontece após confirmação. Se cancelar a importação inicial, a sessão é encerrada e os dados locais permanecem no navegador; ao cancelar a mesclagem, a versão da nuvem será carregada.
- Quando a conta já tem dados na nuvem e não há associação anterior deste navegador à conta, o app oferece mesclar lançamentos locais que ainda não existem na nuvem e unir as categorias. IDs coincidentes mantêm a versão remota.
- Se outro usuário entrar no mesmo navegador, a aplicação não importa automaticamente os dados que estavam associados à conta anterior.
- Faça um backup JSON antes da migração e guarde-o em local seguro.

## 5. Como a sincronização funciona

- Inclusões, edições, exclusões, exceções de recorrência e alterações de categorias são salvas imediatamente no armazenamento local e enviadas ao Supabase após uma breve pausa.
- O status no cabeçalho informa se os dados estão locais, aguardando envio, sincronizados ou com falha.
- Ao entrar em outro dispositivo com a mesma conta, a aplicação carrega os dados da nuvem.
- Se a conexão cair durante o uso, as alterações continuam no armazenamento local. Ao voltar a internet, o app consulta a nuvem e tenta sincronizar novamente.
- Se a nuvem também tiver sido alterada enquanto o aparelho estava offline, o app pergunta qual versão deve prevalecer antes de substituir dados.
- O armazenamento atual mantém um documento JSON por conta. Evite editar a mesma conta simultaneamente em vários dispositivos, pois a sincronização é baseada na última gravação confirmada. Ao abrir em outro aparelho, a versão mais recente é carregada no login.
- O PWA mantém o app shell e o SDK do Supabase em cache após um primeiro carregamento conectado. O primeiro login e a sincronização inicial exigem internet.

## 6. Distribuir entradas entre saídas

Na seção **Distribuir entradas**, selecione uma entrada do mês e informe quanto dela será destinado a cada despesa. É possível fazer pagamentos parciais, usar mais de uma entrada para completar uma mesma despesa e revisar distribuições já salvas.

O botão **Sugerir melhor distribuição** prioriza os menores saldos em aberto, quitando o maior número possível de despesas integralmente com a entrada selecionada; se ainda sobrar dinheiro, ele abate parcialmente a próxima despesa. A sugestão pode ser ajustada antes de salvar. As distribuições ficam vinculadas à entrada e à ocorrência mensal, dentro dos dados dos lançamentos; por isso também são mantidas nos backups JSON e na sincronização do Supabase, sem alteração do SQL.

## 7. Atualizar a aplicação

Substitua os arquivos no repositório mantendo a mesma URL publicada. O `sw.js` tem uma nova versão de cache para que o navegador atualize o app shell. Depois da publicação, abra a aplicação com internet; no celular, feche e abra novamente o PWA se a interface antiga continuar em cache.

## 8. Segurança

- RLS é obrigatória e está habilitada no SQL incluído.
- A chave publishable/anon é pública por definição; a proteção dos registros vem das políticas RLS e do Supabase Auth.
- Não compartilhe nem publique `service_role`/secret keys.
- O conteúdo financeiro é pessoal: use senha forte e mantenha backups JSON periódicos.
