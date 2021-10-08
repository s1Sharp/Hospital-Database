alter table infocard add column aud_who varchar;
alter table infocard add column aud_when timestamp(6);
alter table infocard add column aud_source varchar ;
alter table infocard add column aud_who_create varchar;
alter table infocard add column aud_when_create timestamp(6);
alter table infocard add column aud_source_create varchar ;

alter table employee add column aud_who varchar;
alter table employee add column aud_when timestamp(6);
alter table employee add column aud_source varchar ;
alter table employee add column aud_who_create varchar;
alter table employee add column aud_when_create timestamp(6);
alter table employee add column aud_source_create varchar ;


SHOW timezone;
SELECT now()::timestamp;
ALTER DATABASE hospital SET timezone TO 'Europe/Moscow';
SET timezone TO 'Europe/Moscow';
--SET timezone TO 'UTC';

-- аудит внутри таблицы
create or replace function audit_trigger_fun()
  returns trigger as $body$
  declare
    app_user   text;
    app_source text;
    cur_time timestamp;
  begin
    cur_time := now();
    --uses coalesce because have problem to equal with null
    if (tg_op = 'UPDATE' and (coalesce(new.aud_who_create, 'empty') != coalesce(old.aud_who_create, 'empty')
                              or coalesce(new.aud_when_create, cur_time) != coalesce(old.aud_when_create, cur_time)
                              or coalesce(new.aud_source_create, 'empty') != coalesce(old.aud_source_create, 'empty')
                              or coalesce(new.aud_who, 'empty') != coalesce(old.aud_who, 'empty')
                              or coalesce(new.aud_when, cur_time) != coalesce(old.aud_when, cur_time)
                              or coalesce(new.aud_source, 'empty') != coalesce(old.aud_source, 'empty'))
        or tg_op = 'INSERT' and (new.aud_who_create is not null or new.aud_when_create is not null or new.aud_source_create is not null
                                 or new.aud_who is not null or new.aud_when is not null or new.aud_source is not null)
    )
    then
      raise exception 'audit columns not editable';
      return null;
    end if;
    -- set value for extended_aud_trigger
    perform set_config('aud.when'::text, to_char(cur_time, 'yyyy-mm-dd hh24:mi:ss:ms'), true);
    begin
      select current_setting('app.user') into app_user;
      if (app_user = 'unknown')
      then
        app_user:= current_user;
      end if;
      exception
      when others then
        app_user:= current_user;
    end;

    begin
      select current_setting('app.source') into app_source;
      exception
      when others then
        app_source := 'db';
    end;

    new.aud_when:= cur_time;
    new.aud_who:= app_user;
    new.aud_source:= app_source;
    if (tg_op = 'INSERT')
    then
      new.aud_when_create:=new.aud_when;
      new.aud_who_create:=new.aud_who;
      new.aud_source_create:=new.aud_source;
    end if;
    return new;
  end;
  $body$
  language plpgsql volatile
  cost 100;

-- триггер для таблицы
create trigger "audit_trigger" before insert or update on infocard
for each row
execute procedure audit_trigger_fun();

create trigger "audit_trigger" before insert or update on employee
for each row
execute procedure audit_trigger_fun();

call new_patient(   'Alsu',
                    'Test',
                    22,
                    '88005553535',
                    'f', --don`t matter upper or lower prefix--
                    10000,              True, 0,'KORONAindia');

select * from infocard;
select * from employee;





