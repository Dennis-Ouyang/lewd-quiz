-- 在 Supabase 的 SQL Editor 里整段运行一次即可

-- 1. 数据表：每行是一次完整作答，不含姓名和 IP
create table if not exists public.responses (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  version text not null,
  answers jsonb not null,
  scores jsonb not null,
  credibility int not null check (credibility between 0 and 100),
  flags text[] not null default '{}',
  result_type text,
  duration_sec int
);

-- 2. 网页只能插入，不能读取、修改或删除
alter table public.responses enable row level security;
drop policy if exists "anon insert only" on public.responses;
create policy "anon insert only" on public.responses
  for insert to anon with check (true);

-- 3. 方便导出 Excel 的展开视图：每道题、每个维度一列（只有你在后台能看）
create or replace view public.responses_flat with (security_invoker = true) as
select
  id, created_at, version, credibility, array_to_string(flags, ',') as flags, result_type, duration_sec,
  (scores->>'index')::int as idx, (scores->>'desire')::int as desire, (scores->>'accel')::int as accel,
  (scores->>'brake')::int as brake, (scores->>'relax')::int as relax, (scores->>'novelty')::int as novelty,
  (scores->>'casual')::int as casual, (scores->>'candor')::int as candor,
  (answers->>'L01')::int as l01,
  (answers->>'L02')::int as l02,
  (answers->>'L03')::int as l03,
  (answers->>'L04')::int as l04,
  (answers->>'L05')::int as l05,
  (answers->>'L06')::int as l06,
  (answers->>'L07')::int as l07,
  (answers->>'L08')::int as l08,
  (answers->>'L09')::int as l09,
  (answers->>'L10')::int as l10,
  (answers->>'L11')::int as l11,
  (answers->>'L12')::int as l12,
  (answers->>'L13')::int as l13,
  (answers->>'L14')::int as l14,
  (answers->>'L15')::int as l15,
  (answers->>'L16')::int as l16,
  (answers->>'L17')::int as l17,
  (answers->>'L18')::int as l18,
  (answers->>'L19')::int as l19,
  (answers->>'L20')::int as l20,
  (answers->>'L21')::int as l21,
  (answers->>'L22')::int as l22,
  (answers->>'L23')::int as l23,
  (answers->>'L24')::int as l24,
  (answers->>'L25')::int as l25,
  (answers->>'L26')::int as l26,
  (answers->>'L27')::int as l27,
  answers->>'S1' as s1,
  answers->>'S2' as s2,
  answers->>'S3' as s3,
  answers->>'S4' as s4,
  answers->>'S5' as s5,
  answers->>'S6' as s6
from public.responses;
revoke all on public.responses_flat from anon, authenticated;
