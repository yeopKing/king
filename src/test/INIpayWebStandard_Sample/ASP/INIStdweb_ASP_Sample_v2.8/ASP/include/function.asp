<%

'//// inval �� ���� ������ ���ʿ� padnum ��ü�ڸ����ڰ� �������� padchar�� ä���ֱ� )
function pad_left(inval, padnum, padchar)
	for pad_i = 0 to padnum - len(inval)-1
		inval = padchar & inval
	next
	pad_left = inval
end function


'//// inval �� ���� ������ �����ʿ� padnum ��ü�ڸ����ڰ� �������� padchar�� ä���ֱ� )
function pad_right(inval, padnum, padchar)
	for pad_i = 0 to padnum - len(inval)-1
		inval = inval & padchar
	next
	pad_right = inval
end function

function time_stamp(correct) 
	time_stamp			= DateDiff("s", "1970-01-01 "&correct&":00:00", now)*1000+clng(timer) 
end function 
'****************************************************************************************
'*
'*  �� �� : Function
'*  �� �� : Public Function URLEncode(URLStr)
'*  �� �� : URLStr ���ڷ� �Է¹��� ���ڿ��� URLEncoding �Ѵ�.
'*  �� �� : �ۿ���
'*  �� ¥ : 2001.12.03
'*
'****************************************************************************************
Public Function URLEncode(URLStr)

 Dim sURL                '** �Է¹��� URL ���ڿ�
 Dim sBuffer             '** Encoding ���� URL �� ���� Buffer ���ڿ�
 Dim sTemp               '** �ӽ� ���ڿ�
 Dim cChar               '** URL ���ڿ� ���� ���� Index �� ����

 Dim Index

 On Error Resume Next

 Err.Clear
    sURL = Trim(URLStr)     '** URL ���ڿ��� ��´�.
    sBuffer = ""            '** �ӽ� Buffer �� ���ڿ� ���� �ʱ�ȭ.


    '******************************************************
    '* URL Encoding �۾�
    '******************************************************

    For Index = 1 To Len(sURL)
        '** ���� Index �� ���ڸ� ��´�.
        cChar = Mid(sURL, Index, 1)

        If cChar = "0" Or _
           (cChar >= "1" And cChar <= "9") Or _
           (cChar >= "a" And cChar <= "z") Or _
           (cChar >= "A" And cChar <= "Z") Or _
           cChar = "-" Or _
           cChar = "_" Or _
           cChar = "." Or _
           cChar = "*" Then

            '** URL �� ���Ǵ� ���ڵ� :: Buffer ���ڿ��� �߰��Ѵ�.
            sBuffer = sBuffer & cChar

        ElseIf cChar = " " Then
            '** ���� ���� :: + �� ��ü�Ͽ� Buffer ���ڿ��� �߰��Ѵ�.
            sBuffer = sBuffer & "+"
        Else
            '** URL �� ������ �ʴ� ���ڵ� :: % �� Encoding �ؼ� Buffer ���ڿ��� �߰�
            sTemp = CStr(Hex(Asc(cChar)))

            If Len(sTemp) = 4 Then
                sBuffer = sBuffer & "%" & Left(sTemp, 2) & "%" & Mid(sTemp, 3, 2)
            ElseIf Len(sTemp) = 2 Then
                sBuffer = sBuffer & "%" & sTemp
            End If
        End If
    Next


    '** Error ó��
    If Err.Number > 0 Then
        URLEncode = ""
        Exit Function
    End If

    '** ����� �����Ѵ�.
    URLEncode = sBuffer
    Exit Function

End Function


'****************************************************************************************
'*
'*  �� �� : Function
'*  �� �� : Public Function URLDecode(URLStr)
'*  �� �� : URLStr ���ڷ� �Է¹��� ���ڿ��� URLDecoding �Ѵ�.
'*  �� �� : �ۿ���
'*  �� ¥ : 2001.12.03
'*
'****************************************************************************************
Public Function URLDecode(URLStr)

    Dim sURL                '** �Է¹��� URL ���ڿ�
    Dim sBuffer             '** Decoding ���� URL �� ���� Buffer ���ڿ�
    Dim cChar               '** URL ���ڿ� ���� ���� Index �� ����

    Dim Index
    Dim s,bUnicode

 On Error Resume Next

    Err.Clear
    sURL = Trim(URLStr)     '** URL ���ڿ��� ��´�.
    sBuffer = ""            '** �ӽ� Buffer �� ���ڿ� ���� �ʱ�ȭ.

    '******************************************************
    '* URL Decoding �۾�
    '******************************************************
    '�ѱ��� �ԷµǴ� ��찡 2���� ����
    ' "%C0%DA" ->�Ϲ� 
    ' "%uC911" ->�����ڵ� chr ��� chrW ���

    Index = 1
 
 '?,%�� ���ٸ� �˻��� �ʿ����
 if instr(1,pURL,"?",1) > 0 OR instr(1,pURL,"%",1) > 0 then
     Do While Index <= Len(sURL)
         cChar = Mid(sURL, Index, 1)
         If cChar = "+" Then        
             '** '+' ���� :: ' ' �� ��ü�Ͽ� Buffer ���ڿ��� �߰��Ѵ�.
             sBuffer = sBuffer & " "
             Index = Index + 1            
         ElseIf cChar = "%" Then        
             '** '%' ���� :: Decoding �Ͽ� Buffer ���ڿ��� �߰��Ѵ�.
             
             '�����ڵ����� �Ǵ��� �Ŀ� �Ϲݹ������� �ѱ����� ������
             bUnicode = false
             
             s = Mid(sURL, Index + 1, 5)
             bUnicode = boolUnicode(s)
             
             if bUnicode = true then
              cChar = Mid(sURL, Index + 2, 2)
             else
              cChar = Mid(sURL, Index + 1, 2)
             end if
 
             If CInt("&H" & cChar) < &H80 Then
                 '** �Ϲ� ASCII ����
                 sBuffer = sBuffer & Chr(CInt("&H" & cChar))
                 Index = Index + 3
             Else
                 '** 2 Byte �ѱ� ����
                 cChar = Replace(Mid(sURL, Index + 1, 5), "%", "")
                 
                 '�����ڵ��ΰ�� �Ǿ��� u�ڸ� �����ؾ� ��
                 if bUnicode = true then  'C0DA
                  cChar = mid(cChar,2,4)
                  sBuffer = sBuffer & ChrW(CInt("&H" & cChar))
                 else      'uC911
                  sBuffer = sBuffer & Chr(CInt("&H" & cChar))
                 end if
                 Index = Index + 6
             End If
         Else
             '** �� ���� �Ϲ� ���ڵ� :: Buffer ���ڿ��� �߰��Ѵ�.
             sBuffer = sBuffer & cChar
             Index = Index + 1
         End If
     Loop
 else
  sBuffer = ""
 end if
 
    '** Error ó��
    If Err.Number > 0 Then
        URLDecode = ""
        Exit Function
    End If

    '** ����� �����Ѵ�.
    URLDecode = sBuffer
    Exit Function

End Function

'****************************************************************************************
'*  �� �� : Function
'*  �� �� : Public Function boolUnicode(s)
'*  �� �� : s ���ڷ� �Է¹��� ���ڿ��� �������� �����ڵ����� �Ǵ��Ѵ�.
'*  �� �� : kimyh
'*  �� ¥ : 2007.01.25
'****************************************************************************************
Function boolUnicode(s)
 'true = �����ڵ�(%uC911)  false=�Ϲ�(%C0%DA) �������� ���ڿ��� �߸��Ƿ�
 'ù��° %�� �����Ͽ� %�� �߰ߵ��� ������ �����ڵ�� �Ǵ�
 
 tmp = false
 if instr(1,s,"%",1) <= 0 then tmp = true
 boolUnicode = tmp
 
End Function


'---------------------------------------------------------------------
' URLEncodeUTF8 (�ƽ�Ű -> UTF8)
' Devpia.com ����ȣ(n4kjy)�� - 2002-07-24
'---------------------------------------------------------------------
Public Function URLEncodeUTF8(byVal szSource)

 Dim szChar, WideChar, nLength, i, result
 nLength = Len(szSource)

 szSource = Replace(szSource," ","+")

 For i = 1 To nLength
  szChar = Mid(szSource, i, 1)

  If Asc(szChar) < 0 Then             
   WideChar = CLng(AscB(MidB(szChar, 2, 1))) * 256 + AscB(MidB(szChar, 1, 1))

   If (WideChar And &HFF80) = 0 Then
    result = result & "%" & Hex(WideChar)
   ElseIf (WideChar And &HF000) = 0 Then
    result = result & _
    "%" & Hex(CInt((WideChar And &HFFC0) / 64) Or &HC0) & _
    "%" & Hex(WideChar And &H3F Or &H80)
   Else
    result = result & _
    "%" & Hex(CInt((WideChar And &HF000) / 4096) Or &HE0) & _
    "%" & Hex(CInt((WideChar And &HFFC0) / 64) And &H3F Or &H80) & _
    "%" & Hex(WideChar And &H3F Or &H80)
   End If
  Else
   result = result + szChar
  End If
 Next
 URLEncodeUTF8 = result
End Function


'---------------------------------------------------------------------
' URLDecodeUTF8 (UTF8 --> �ƽ�Ű )
' mongmong - 2003. 10 (URLEncodeUTF8 ����)
'---------------------------------------------------------------------
Public Function URLDecodeUTF8(byVal pURL)
 Dim i, s1, s2, s3, u1, u2, result
 pURL = Replace(pURL,"+"," ")
 
 '?,%�� ���ٸ� �˻��� �ʿ����
 if instr(1,pURL,"?",1) > 0 OR instr(1,pURL,"%",1) > 0 then
   For i = 1 to Len(pURL)
    if Mid(pURL, i, 1) = "%" then
     s1 = CLng("&H" & Mid(pURL, i + 1, 2))
  
     '2����Ʈ�� ���
     if ((s1 AND &HC0) = &HC0) AND ((s1 AND &HE0) <> &HE0) then
      s2 = CLng("&H" & Mid(pURL, i + 4, 2))
  
      u1 = (s1 AND &H1C) / &H04
      u2 = ((s1 AND &H03) * &H04 + ((s2 AND &H30) / &H10)) * &H10
      u2 = u2 + (s2 AND &H0F)
      result = result & ChrW((u1 * &H100) + u2)
      i = i + 5
  
     '3����Ʈ�� ���
     elseif (s1 AND &HE0 = &HE0) then
      s2 = CLng("&H" & Mid(pURL, i + 4, 2))
      s3 = CLng("&H" & Mid(pURL, i + 7, 2))
  
      u1 = ((s1 AND &H0F) * &H10)
      u1 = u1 + ((s2 AND &H3C) / &H04)
      u2 = ((s2 AND &H03) * &H04 +  (s3 AND &H30) / &H10) * &H10
      u2 = u2 + (s3 AND &H0F)
      result = result & ChrW((u1 * &H100) + u2)
      i = i + 8
     end if
    else
     result = result & Mid(pURL, i, 1)
    end if
   Next
 else
  result = ""
 end if
 URLDecodeUTF8 = result
End Function
%>
