uses
  'confirm.cfm';

begin
  ShowTitle('Подовження академічної відпустки');

  ShowNotChangeInfo;
  ShowInfo(#13#10);

  AddReason(3051);
end.
