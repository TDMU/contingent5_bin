uses
  'confirm.cfm';

begin
  ShowTitle('Отработка занятий ' + Params.Item('Reason_REASON').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('Reason_REASONID').Value);
end.
