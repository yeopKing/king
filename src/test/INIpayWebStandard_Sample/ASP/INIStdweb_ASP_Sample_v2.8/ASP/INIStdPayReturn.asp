<% @Language="VBScript" CODEPAGE="949" %>
<%
Response.CharSet="euc-kr"
Session.codepage="949"
Response.codepage="949"
Response.ContentType="text/html;charset=euc-kr"
%>
<!--#include virtual="/include/function.asp"-->
<!--#include virtual="/include/signature.asp"-->
<!--#include virtual="/include/aspJSON1.17.asp"-->

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<style type="text/css">
		body { background-color: #efefef}
		body, tr, td {font-size:11pt font-family:����,verdana color:#433F37 line-height:19px}
		table, img {border:none}
		
	</style>
	<link rel="stylesheet" href="../css/group.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0>
	<div style="padding:10pxwidth:100%font-size:14pxcolor: #ffffffbackground-color: #000000text-align: center">
		�̴Ͻý� ǥ�ذ��� ������� ���� / ���ο�û, ���ΰ�� ǥ�� ����
	</div>
<% 
		'#############################
		' ������� �Ķ���� �ϰ� ����
		'#############################

		Set oJSON = New aspJSON
		'#####################
		' ������ ������ ��츸
		'#####################
		if ("0000"=request("resultCode")) then

			response.write ("<br/><br/><br/>")
			response.write ("####��������/���ο�û####")
			response.write ("<br/><br/><br/>")


			'############################################
			' 1.���� �ʵ� �� ����(***������ ���߼���***)
			'############################################
			
			maid 		= request("mid")							' ������ ID ���� ���� �����ͷ� ����
			signKey		= "SU5JTElURV9UUklQTEVERVNfS0VZU1RS"		' �������� ������ Ű(��ǥ�� ����Ű) (������ ������ ����) !!!����!! ���� �����ͷ� ��������
			correct 	= "09"										' ǥ�ؽÿ��� ���̸� 2�ڸ� ���ڷ� �Է� (��: ���ѹα��� ǥ�ؽÿ� 9�ð� �����̹Ƿ� 09)
			timestamp	= time_stamp(correct)
			charset 	= "EUC-KR"									' ��������[UTF-8,EUC-KR](������ ������ ����)
			format 		= "JSON"									' ��������[XML,JSON,NVP](������ ������ ����)	
			
			authToken	= request("authToken")						' ��� ��û tid�� ���� ������(������ ������ ����)
			authUrl		= request("authUrl")						' ���ο�û API url(���� ���� ������ ����, ���� ���� ����)
			netCancel	= request("netCancelUrl")					' ����� API url(���� ���� ������ ����, ���� ���� ����)
			merchantData= request("merchantData")					' ������ ���������� ����

				
			'#####################
			' 2.signature ����
			'#####################
			signParam = "authToken=" & replace(authToken," ", "+")	
			signParam = signParam & "&timestamp=" & timestamp
			' signature ������ ���� (signParam�� ���ĺ� ������ hash)
			signature = MakeSignature(signParam)
			

			'#####################
			' 3.API ��û ���� ����
			'#####################

			dim xmlHttp,  postdat
			Set xmlHttp = CreateObject("Msxml2.XMLHTTP")

			send_text = "mid="&maid
			send_text = send_text & "&timestamp="&timestamp
			send_text = send_text & "&signature="&signature
			send_text = send_text & "&authToken="&Server.URLEncode(authToken)
			send_text = send_text & "&&charset="&charset
			send_text = send_text & "&format="&format
			

			'#####################
			' 4.API ��� ����
			'#####################

			response.write("##���ο�û API ��û##<br>")
 			xmlHttp.Open "POST", authUrl, False
 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
			xmlHttp.Send send_text
			result=Cstr( xmlHttp.responseText )

			Set oJSON = New aspJSON
			oJSON.loadJSON(result)

			'############################################################
			'5.API ��Ű�� ó��(***������ ���߼���***)
			'############################################################
			response.write ("## ���� API ��� ##")
			response.write("<pre>")
			response.write("<table width='565' border='0' cellspacing='0' cellpadding='0'>")	


			' signature ������ ���� 
			authSignature = MakeSignatureAuth(maid, timestamp, oJSON.data("MOID"), oJSON.data("TotPrice"))

			if "0000"=oJSON.data("resultCode") and authSignature =oJSON.data("authSignature")  then

			    '/*****************************************************************************
			    ' * ���⿡ ������ ���� DB�� ���� ����� �ݿ��ϴ� ���� ���α׷� �ڵ带 �����Ѵ�.  
			    '
			    '   [�߿�!] ���γ��뿡 �̻��� ������ Ȯ���� �� ������ DB�� �ش���� ����ó�� �Ǿ����� �ݿ���
			    '            ó���� ���� �߻��� ����Ҹ� �Ѵ�.
			    '******************************************************************************/

						On Error Resume Next			' ������ �� ��� ����

					' �̺κп� DB ��ϵ� ���� ���� ���� 
					' ���� �߻��� �����
							If Err.Number > 0 Then 
							'### ����� ��� ����
								response.write("##����� ��û##</br>")
								send_text = "timestamp="&timestamp
								send_text = send_text & "&mid="&maid
								send_text = send_text & "&tid="&oJSON.data("tid")
								send_text = send_text & "&authToken="&Server.URLEncode(authToken)
								send_text = send_text & "&signature="&signature
								send_text = send_text & "&SignKey="&signKey
								send_text = send_text & "&format="&format
								send_text = send_text & "&charset="&charset
								
					 			xmlHttp.Open "POST", netCancel, False
					 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
								xmlHttp.Send send_text
								ask_result=Cstr( xmlHttp.responseText )
								Set xmlHttp = nothing
									response.write "<br>" &  ask_result &"<br>"
									'################# ask_result�� ��ȯ�� ���� ��  "resultCode": "0000"  �̸� ���� ����� ó��.
								response.end
			  			End If   
						Err.Clear      ' Clear the error.
						On Error GoTo 0
					' ����ҿ������
				Set xmlHttp = nothing
				
				response.write ("<tr><th class='td01'><p>�ŷ� ���� ����</p></th>")
				response.write ("<td class='td02'><p>����("&oJSON.data("payMethod")&")</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��� ����</p></th>")
				response.write("<td class='td02'><p>" &oJSON.data("resultMsg")&"</p></td></tr>")	
			else
				response.write("<tr><th class='td01'><p>�ŷ� ���� ����</p></th>")
				response.write("<td class='td02'><p>����("&oJSON.data("resultCode")&")</p></td></tr>")					
				if not (signature = oJSON.data("authSignature")) and "0000"=oJSON.data("resultCode") Then	' authSignature ���� ��ġ���� ���� ��� ��Ŷ������ �ǽ��غ�����
								
								response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
								response.write("<tr><th class='td01'><p>��� ����</p></th>")
								response.write("<td class='td02'><p>* ������ ������ üũ ���� </p></td></tr>")
								
						if "0000"=oJSON.data("resultCode")  Then		' ������ �̷�� ������ authSignature�� ��ġ ���� �ʴ� ��� �����
										response.write("##����� ��û##</br>")
										send_text = "timestamp="&timestamp
										send_text = send_text & "&mid="&maid
										send_text = send_text & "&tid="&oJSON.data("tid")
										send_text = send_text & "&authToken="&Server.URLEncode(authToken)
										send_text = send_text & "&signature="&signature
										send_text = send_text & "&SignKey="&signKey
										send_text = send_text & "&format="&format
										send_text = send_text & "&charset="&charset
										
							 			xmlHttp.Open "POST", netCancel, False
							 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
										xmlHttp.Send send_text
										ask_result=Cstr( xmlHttp.responseText )
										Set xmlHttp = nothing
											response.write "<br>" &  ask_result &"<br>"
										'################# ask_result�� ��ȯ�� ���� ��  "resultCode": "0000"  �̸� ���� ����� ó��.
						end if
								
								
				else
								response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
								response.write("<tr><th class='td01'><p>��� ����</p></th>")
								response.write("<td class='td02'><p>" &oJSON.data("resultMsg")&"</p></td></tr>")	
				end if

			end if
					
			'���� �κи�
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>�ŷ� ��ȣ</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("tid")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>�������(���Ҽ���)</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("payMethod")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>��� �ڵ�</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("resultCode")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>�����Ϸ�ݾ�</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("TotPrice")&"��</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>�ֹ� ��ȣ</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("MOID")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>���γ�¥</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("applDate")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>���νð�</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("applTime")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			
			if "VBank"=(oJSON.data("payMethod")) then'�������
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�Ա� ���¹�ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�Ա� �����ڵ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_BankCode")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�Ա� �����</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("vactBankName")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>������ ��</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Name")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�۱��� ��</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_InputName")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�۱� ����</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Date")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�۱� �ð�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Time")&"</p></td></tr>")
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")	
				
			elseif ("DirectBank"=(oJSON.data("payMethod"))) then'�ǽð�������ü
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�����ڵ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("ACCT_BankCode")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>���ݿ����� �߱ް���ڵ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CSHR_ResultCode")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>���ݿ����� �߱ޱ����ڵ�</p> <font color=red><b>(0 - �ҵ������, 1 - ����������)</b></font></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CSHR_Type")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				 
			elseif "HPP"=(oJSON.data("payMethod")) then	'�޴���
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��Ż�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("HPP_Corp")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>������ġ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("payDevice")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�޴�����ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("HPP_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")

			elseif "Culture"=(oJSON.data("payMethod")) then	'��ȭ��ǰ��
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��ȭ��ǰ�ǽ�������</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applDate")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��ȭ��ǰ�� ���νð�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applTime")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��ȭ��ǰ�� ���ι�ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��ó���� ���̵�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CULT_UserID")&"</p></td></tr>")
			elseif "DGCL"=(oJSON.data("payMethod")) then	'���ӹ�ȭ��ǰ��
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>���ӹ�ȭ��ǰ�ǽ��αݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_ApplPrice")&"��</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>����� ī���</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_Cnt")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>����� ī���ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num1")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>ī���ܾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price1")&"��</p></td></tr>")
				if(not ""=(oJSON.data("GAMG_Num2"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>����� ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num2")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>ī���ܾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price2")&"��</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num3"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>����� ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num3")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>ī���ܾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price3")&"��</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num4"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>����� ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num4")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>ī���ܾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price4")&"��</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num5"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>����� ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num5")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>ī���ܾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price5")&"��</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num6"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>����� ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num6")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>ī���ܾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price6")&"��</p></td></tr>")
				end if
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "OCBPoint"=(oJSON.data("payMethod")) then'������ ĳ����
			
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>���ұ���</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("PayOption")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�����Ϸ�ݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applPrice")&"��</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>OCB ī���ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>���� ���ι�ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_SaveApplNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��� ���ι�ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_PayApplNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")					
				response.write("<tr><th class='td01'><p>OCB ���� �ݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_PayPrice")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "GSPT"=(oJSON.data("payMethod")) then'GSPoint
			
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>���ұ���</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("PayOption")&"</p></td></tr>")					
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>GS ����Ʈ ���αݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GSPT_ApplPrice")&"��</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>GS ����Ʈ �����ݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GSPT_SavePrice")&"��</p></td></tr>")					
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>GS ����Ʈ ���ұݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GSPT_PayPrice")&"��</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "UPNT"=(oJSON.data("payMethod")) then'U-����Ʈ
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>U����Ʈ ī���ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("UPoint_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>��������Ʈ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("UPoint_usablePoint")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")			
				response.write("<tr><th class='td01'><p>����Ʈ���ұݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("UPoint_ApplPrice")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "TEEN"=(oJSON.data("payMethod")) then'ƾĳ��
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>ƾĳ�� ���ι�ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("TEEN_ApplNum")&"</p></td></tr>")									
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>ƾĳ�þ��̵�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("TEEN_UserID")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>ƾĳ�ý��αݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("TEEN_ApplPrice")&"��</p></td></tr>")	
									
			elseif "Bookcash"=(oJSON.data("payMethod")) then'������ȭ��ǰ��
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>������ǰ�� ���ι�ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("BCSH_ApplNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>������ǰ�� �����ID</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("BCSH_UserID")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>������ǰ�� ���αݾ�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("BCSH_ApplPrice")&"��</p></td></tr>")
				
			elseif "PhoneBill"=(oJSON.data("payMethod")) then'������ȭ����
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>������ȭ��ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("PHNB_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "Auth"=(oJSON.data("payMethod")) then'��������
                
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>����Ű</p></th>")
					if "BILL_CARD"=(oJSON.data("payMethodDetail")) then'ī��
                        response.write("<td class='td02'><p>" & oJSON.data("CARD_BillKey")& "</p></td></tr>")
                    elseif "BILL_HPP"=(oJSON.data("payMethodDetail")) then'�޴���
						response.write("<td class='td02'><p>" & oJSON.data("HPP_BillKey")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>��Ż�</p></th>")
						response.write("<td class='td02'><p>" & oJSON.data("HPP_Corp")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>������ġ</p></th>")
						response.write("<td class='td02'><p>"  & oJSON.data("payDevice")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>�޴�����ȣ</p></th>")
						response.write("<td class='td02'><p>"  & oJSON.data("HPP_Num")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>��ǰ��</p></th>")
						response.write("<td class='td02'><p>"  & oJSON.data("goodName")& "</p></td></tr>")
					end if			
				
			else 'ī��
				quota = CLng(oJSON.data("CARD_Quota"))
				
				if(oJSON.data("EventCode")<>null) then				
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>�̺�Ʈ �ڵ�</p></th>")					
					response.write("<td class='td02'><p>" & oJSON.data("EventCode")&"</p></td></tr>")
				end if
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>ī���ȣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�ҺαⰣ</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_Quota")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				if("1"=(oJSON.data("CARD_Interest")) or "1"=(oJSON.data("EventCode"))) then
					response.write("<tr><th class='td01'><p>�Һ� ����</p></th>")
					response.write("<td class='td02'><p>������</p></td></tr>")	
				elseif quota > 0 and  not "1"=(oJSON.data("CARD_Interest")) then
					response.write("<tr><th class='td01'><p>�Һ� ����</p></th>")
					response.write("<td class='td02'><p>������ <font color='red'> *�����ڷ� ǥ�õǴ��� EventCode �� EDI�� ���� ������ ó���� �� �� �ֽ��ϴ�.</font></p></td></tr>")
				end If
				
				if("1"=(oJSON.data("point"))) then
					response.write("<td class='td02'><p></p></td></tr>")
					response.write("<tr><th class='td01'><p>����Ʈ ��� ����</p></th>")
					response.write("<td class='td02'><p>���</p></td></tr>")
				else
					response.write("<td class='td02'><p></p></td></tr>")
					response.write("<tr><th class='td01'><p>����Ʈ ��� ����</p></th>")
					response.write("<td class='td02'><p>�̻��</p></td></tr>")
				end if
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>ī�� ����</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_Code")& "</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>ī�� �߱޻�</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_BankCode")& "</p></td></tr>")
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>�κ���� ���ɿ���</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_PRTC_CODE")& "</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>üũī�� ����</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_CheckFlag")& "</p></td></tr>")
				
				if( oJSON.data("OCB_Num")<>null and oJSON.data("OCB_Num") <> "") then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>OK CASHBAG ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("OCB_Num")& "</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>OK CASHBAG ���� ���ι�ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("OCB_SaveApplNum")& "</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>OK CASHBAG ����Ʈ���ұݾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("OCB_PayPrice")& "</p></td></tr>")
				end if
				if(oJSON.data("GSPT_Num")<>null and oJSON.data("GSPT_Num") <> "") then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>GS&Point ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GSPT_Num")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>GS&Point �ܿ��ѵ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GSPT_Remains")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>GS&Point ���αݾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GSPT_ApplPrice")& "</p></td></tr>")
				end if
				
				if(oJSON.data("UNPT_CardNum")<>null and oJSON.data("UNPT_CardNum") <> "") then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>U-Point ī���ȣ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("UNPT_CardNum")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>U-Point ��������Ʈ</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("UPNT_UsablePoint")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>U-Point ����Ʈ���ұݾ�</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("UPNT_PayPrice")& "</p></td></tr>")
				'end if
				end if
			response.write("</table>")			
			response.write("</pre>")
		
			' ���Ű���� �Ľ��� resultCode�� "0000"�̸� ���μ��� �̿� ����
			' ���������� ������ �Ľ��� ���� DB ó�� �� ȭ�鿡 ��� ǥ��


			' payViewType�� popup���� �ؼ� ������ �ϼ��� ���
			' ����ó���� ��ũ��Ʈ�� �̿��� opener�� ȭ�� ��ȯó���� �ϼ���
			end if

		else 
				'#############
				' ���� ���н�
				'#############
				response.write("<br/><br/><br/>")
				response.write("####��������####")

				For each item in Request.Form
				    for i = 1 to Request.Form(item).Count
				    	if not(item="authToken") then
								response.write("<pre>" & item & " = " & Request.Form(item)(i) & "</pre>")
							end if
				 Next
				Next



		end if
	Set oJSON = Nothing
%>
	</body>
</html>
