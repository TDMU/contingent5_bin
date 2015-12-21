uses
  'confirm.cfm';

begin
  if Params.Item('IntReason_KEY').Value = 0 then // Повторное обучение
  begin
    ShowTitle('Предоставление ' + Params.Item('IntReason').Value + ' ' +
              Params.Item('Reason').Value);
    
    ShowInfo('Статус = ''Повторное обучение'''#13#10);

// 3101 - по состоянию здоровья
// 3102 - по семейным обстоятельствам
// 3103 - в связи с служебной командировкой

    AddReason(Params.Item('Reason_KEY').Value);

    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''П'''#13#10 +
                'ToDate=?ToDate');
  end
  else // Академический отпуск
  begin
    ShowTitle('Предоставление ' + Params.Item('IntReason').Value);
    
    ShowInfo('Статус = ''Академический отпуск'''#13#10);

// 3001 - академический отпуск по состоянию здоровья
// 3002 - академический отпуск по уходу за ребенком
// 0 - право прохождения повторного курса обучения

    AddReason(Params.Item('IntReason_KEY').Value);

    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''А'''#13#10 +
                'ToDate=?ToDate');
  end;
end.
