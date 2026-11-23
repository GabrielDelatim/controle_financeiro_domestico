-- Financas da Casa - estrutura inicial do Supabase
-- Execute uma unica vez no SQL Editor do seu projeto Supabase.

create table if not exists public.user_finances (
  user_id uuid primary key references auth.users (id) on delete cascade,
  transactions jsonb not null default '[]'::jsonb,
  categories jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now(),
  constraint user_finances_transactions_array check (jsonb_typeof(transactions) = 'array'),
  constraint user_finances_categories_array check (jsonb_typeof(categories) = 'array')
);

-- RLS e permissões: somente usuários autenticados podem acessar a própria linha.
alter table public.user_finances enable row level security;
revoke all on table public.user_finances from anon, authenticated;
grant select, insert, update, delete on table public.user_finances to authenticated;
grant usage on schema public to authenticated;

drop policy if exists "Users can read their own finances" on public.user_finances;
create policy "Users can read their own finances"
  on public.user_finances
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can create their own finances" on public.user_finances;
create policy "Users can create their own finances"
  on public.user_finances
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own finances" on public.user_finances;
create policy "Users can update their own finances"
  on public.user_finances
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their own finances" on public.user_finances;
create policy "Users can delete their own finances"
  on public.user_finances
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- Opcional: habilite Realtime para esta tabela no Dashboard se desejar atualizações
-- instantâneas entre telas. A aplicação atual carrega a versão mais recente ao entrar
-- e envia alterações automaticamente após cada inclusão, edição ou exclusão.
