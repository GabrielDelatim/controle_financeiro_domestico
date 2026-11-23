FINANCAS DA CASA — GITHUB PAGES + SUPABASE

INICIO RAPIDO
1. Crie um projeto Supabase.
2. Execute o arquivo supabase/setup.sql no SQL Editor.
3. Configure supabase-config.js com Project URL e chave publica publishable/anon.
4. Configure Site URL e Redirect URLs em Authentication > URL Configuration.
5. Publique todos os arquivos na raiz (ou pasta definida) do GitHub Pages.
6. Abra a URL HTTPS, crie uma conta e entre.

IMPORTANTE: use apenas a chave publishable/anon. Nunca inclua service_role/secret key no frontend ou no GitHub.

DADOS
A tabela public.user_finances possui uma linha por usuário e RLS permite que cada usuário acesse somente sua própria linha. O app envia lançamentos e categorias ao Supabase depois de cada alteração. O armazenamento local continua sendo usado como cache/contingência.

MIGRACAO
No primeiro login, se houver lançamentos locais e a conta ainda não possuir uma linha na nuvem, o app pergunta se deseja importar os dados existentes. Faça backup JSON antes.

PWA E OFFLINE
O app shell e o SDK do Supabase são armazenados em cache depois de um primeiro acesso conectado. Login/sincronização inicial exigem internet. Alterações offline ficam no aparelho; ao reconectar, o app confere se a nuvem também mudou e pergunta qual versão manter em caso de conflito.

LEIA README.md para as instruções completas e supabase/setup.sql para a estrutura de banco e políticas RLS.
