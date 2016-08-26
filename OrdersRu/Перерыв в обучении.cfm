uses
  'confirm.cfm';

begin
  if Params.Item('IntReason_KEY').Value = 0 then // Повторное обучение
  begin
    ShowTitle('Надання ' + Params.Item('IntReason').Value + ' ' +
              Params.Item('Reason').Value);
    
    ShowInfo('Статус = ''Повторне навчання'''#13#10);

// 3101 - за станом здоров'я
// 3102 - за сімейними обставинами
// 3103 - у зв'язку зі службовим відрядженням
// 3104 - у зв'язку з призовом на військову службу в Збройних силах України

    AddReason(Params.Item('Reason_KEY').Value);

    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''П'''#13#10 +
                'ToDate=?ToDate');
  end
  else // Академический отпуск
  begin
    ShowTitle('Надання ' + Params.Item('IntReason').Value);
    
    ShowInfo('Статус = ''Академічна відпустка'''#13#10);

// 3001 - академічної відпустки за станом здоров'я
// 3002 - академічної відпустки з догляду за дитиною
// 0 - права проходження повторного курсу навчання

    AddReason(Params.Item('IntReason_KEY').Value);

    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''А'''#13#10 +
                'ToDate=?ToDate');
  end;
end.
