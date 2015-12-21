uses
  'confirm.cfm';

begin
  ShowTitle('Продление академического отпуска');

  ShowNotChangeInfo;
  ShowInfo(#13#10);

  AddReason(3051);
end.
