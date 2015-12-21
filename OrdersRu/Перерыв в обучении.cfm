uses
  'confirm.cfm';

begin
  if Params.Item('IntReason_KEY').Value = 0 then // ��������� ��������
  begin
    ShowTitle('�������������� ' + Params.Item('IntReason').Value + ' ' +
              Params.Item('Reason').Value);
    
    ShowInfo('������ = ''��������� ��������'''#13#10);

// 3101 - �� ��������� ��������
// 3102 - �� �������� ���������������
// 3103 - � ����� � ��������� �������������

    AddReason(Params.Item('Reason_KEY').Value);

    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''�'''#13#10 +
                'ToDate=?ToDate');
  end
  else // ������������� ������
  begin
    ShowTitle('�������������� ' + Params.Item('IntReason').Value);
    
    ShowInfo('������ = ''������������� ������'''#13#10);

// 3001 - ������������� ������ �� ��������� ��������
// 3002 - ������������� ������ �� ����� �� ��������
// 0 - ����� ����������� ���������� ����� ��������

    AddReason(Params.Item('IntReason_KEY').Value);

    PartConfirm('Date=?FromDate'#13#10 +
                'Status=''�'''#13#10 +
                'ToDate=?ToDate');
  end;
end.
